#!/bin/sh
# scripts/run-batch.sh

set -e # Exit immediately if a command exits with a non-zero status

echo '🔄 [1/6] Importing Credentials...'
# Check if the mounted secret file exists and import it
if [ -f /opt/n8n/secrets/credentials.json ]; then
    # We might need to copy it to a writable location if n8n tries to lock it
    cp /opt/n8n/secrets/credentials.json /home/node/.n8n/config/credentials.json
    echo "Credentials imported."
fi

echo '📦 [2/6] Publishing Workflows...'
# Note: In production, workflows are already COPY'd to /opt/n8n/workflows in Dockerfile
# We iterate and publish them to the local DB instance
for workflow in /opt/n8n/workflows/*.json; do
    echo "Publishing $workflow..."
    n8n import:workflow --input="$workflow"
done

echo '🚀 [3/6] Starting n8n Server (Background)...'
n8n start > /home/node/.n8n/n8n.log 2>&1 &
N8N_PID=$!

echo '⏳ [4/6] Waiting for Health Check...'
# Wait loop for port 5678
timeout=60
while ! nc -z localhost 5678; do
  sleep 1
  timeout=$((timeout - 1))
  if [ "$timeout" -le 0 ]; then
    echo "❌ Timeout waiting for n8n"
    exit 1
  fi
done

echo '🔥 [5/6] Triggering Batch Webhook...'
# Trigger the specific webhook that runs your logic
HTTP_STATUS=$(curl -s -o /tmp/response.json -w "%{http_code}" -X POST http://localhost:5678/webhook/test)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Batch Job Success!"
    cat /tmp/response.json
else
    echo "❌ Batch Job Failed (Status: $HTTP_STATUS)"
    cat /tmp/response.json
    kill $N8N_PID
    exit 1
fi

echo '🛑 [6/6] Cleanup...'
kill $N8N_PID
exit 0