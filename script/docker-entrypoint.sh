#!/bin/sh
set -e
echo "🚀 n8n Container Starting..."
# --- 1. GLOBAL CONTEXT INJECTION (Best Practice) ---
# This sets the date for ALL modes (Server, Batch, Curl)
# export TODAY_DATE=$(date +'%Y-%m-%d')
echo "📅 System Context: Date set to $TODAY_DATE ($TZ)"
pwd
# --- 2. CREDENTIAL HYDRATION ---
if [ -d "/opt/n8n/credentials" ]; then
    echo "🔑 Importing Credentials..."
    n8n import:credentials --separate --input=/opt/n8n/credentials/ > /dev/null 2>&1 || echo "⚠️ Credential import warning"
fi

if [ -d "/opt/n8n/workflows" ]; then
    echo "📦 Found /opt/n8n/workflows. Importing..."
    n8n import:workflow --input=/opt/n8n/workflows/ --separate || echo "⚠️ Workflow import warning"
fi
# --- 3. WORKFLOW PUBLISHING  ---
# (You can list specific IDs here if needed, or rely on the DB volume)
echo "📦 Public Workflows... ${1}";
n8n publish:workflow  --id="3Tz9JuKqVmNhUsC5";
n8n publish:workflow  --id=aUoOlwBznCRes9YK;
n8n publish:workflow  --id=IYRdfkLhYI1x2Ak6;
n8n publish:workflow  --id=QdSzSZGJP2tKve8P;
n8n publish:workflow  --id=sCQjttZHaqnrujAG;
n8n publish:workflow  --id=VgUuzSEcrYCHVF1vd6dVN;
n8n publish:workflow  --id=xswkRPME4gL2nleT;
n8n publish:workflow  --id=blH4XGo5lXN4LQCrPHwHF

# --- 4. MODE SELECTION ---

# MODE A: SERVER (Default)
if [ -z "$1" ] || [ "$1" = "execute-server" ]; then
    echo '🚀 Starting n8n Server...'
    exec n8n start

# MODE B & C: BATCH / CURL
elif [ "$1" = "execute-daily" ] || [ "$1" = "execute-curl" ]; then
    TARGET_URL=""
    if [ "$1" = "execute-daily" ]; then
        echo "⚡ Mode: Batch Execution (Daily TLDR)"
        TARGET_URL="http://127.0.0.1:5678/webhook/test"
    else
        echo "⚡ Mode: Curl Test"
        TARGET_URL="http://127.0.0.1:5678/webhook/test"
    fi

    # Start n8n in background
    # n8n start > /home/node/.n8n/n8n.log 2>&1 &
    n8n start &
    N8N_PID=$!
    sleep 5; 
    echo "⏳ Waiting for n8n to be ready... ${N8N_PID}"
    # Health check loop (max 60s)
    count=0
    until wget -q --spider http://127.0.0.1:5678/healthz || [ $count -gt 60 ]; do 
        echo '...aligning satellites'
        sleep 2
        count=$((count+1))
    done

    if [[ $count -gt 60 ]]; then
        echo '❌ Timeout: Server did not start.'
        cat /home/node/.n8n/n8n.log
        kill $N8N_PID
        exit 1
    fi

    echo "🔥 Triggering Webhook: $TARGET_URL"
    # Run Curl with embedded date payload
    sleep 4
    http_code=$(curl -m 3600 -w "%{http_code}" -o /home/node/response.json --fail-with-body  \
        "$TARGET_URL")
    echo "🔍 Status Code: $http_code"
    cat /home/node/response.json | jq .
    RESPONSE_STATUS=$(jq -r '(if type=="array" then .[0] else . end).status' ./response.json)
    echo "🔍 Debug: API returned status -> ${RESPONSE_STATUS}"

    # Graceful Shutdown
    kill $N8N_PID
    wait $N8N_PID
    
    # Exit code based on success
    if [ "$http_code" -eq 200 ] || [ "$RESPONSE_STATUS" = "success" ]; then
        echo "✅ Batch Success"
        exit 0
    else
        echo "❌ Batch Failed"
        exit 1
    fi

else
    # Passthrough for standard n8n commands (e.g., n8n export:workflow)
    exec "$@"
fi