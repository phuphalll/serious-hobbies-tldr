# Use the official stable version
FROM n8nio/n8n:latest

# Switch to root to manage permissions and install extra tools if needed
USER root

# ---------------------------------------------------------------------------
# 🔧 CRITICAL FIX: Restore 'apk' package manager
# n8n v2+ images are "distroless" and lack apk. We must copy it from Alpine.
# 🔒 MATCHING ALPINE VERSION: n8n:latest is on Alpine 3.22
# ---------------------------------------------------------------------------
    COPY --from=docker.io/library/alpine:3.22 /sbin/apk /sbin/apk
    COPY --from=docker.io/library/alpine:3.22 /lib/libapk.so* /lib/
    COPY --from=docker.io/library/alpine:3.22 /usr/share/apk /usr/share/apk
    COPY --from=docker.io/library/alpine:3.22 /etc/apk /etc/apk
# ----------------------------------------------------
# 👇 NEW: Install Python 3 and PIP (Required for Code Node)
RUN apk add --update --no-cache \
    python3 \
    py3-pip \
    curl \
    jq \
    && rm -rf /var/cache/apk/*
# ----------------------------------------------------

ENV TZ=Asia/Bangkok

# 4. (Optional) Setup a Virtual Environment for Python
# Best practice to avoid breaking system packages
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip --no-cache-dir

# Create folders for your local imports
RUN mkdir -p /opt/n8n/workflows /opt/n8n/credentials && chown -R node:node /opt/n8n

# Copy workflows into the image
COPY --chown=node:node ./workflows /opt/n8n/workflows

# Add entrypoint script
COPY --chown=node:node script/docker-entrypoint.sh /opt/n8n/docker-entrypoint.sh
RUN chmod +x /opt/n8n/docker-entrypoint.sh

COPY --chown=node:node script/run-batch.sh /opt/n8n/run-batch.sh
RUN chmod +x /opt/n8n/run-batch.sh

RUN printf "" > ./response.json && chown node:node ./response.json
RUN printf "" > /home/node/.n8n/n8n.log && chown node:node /home/node/.n8n/n8n.log
# Switch back to the non-root 'node' user for security
USER node

# Set environment variables for the n8n CLI
ENV N8N_PORT=5678
ENV NODE_ENV=production
ENV N8N_PYTHON_INTERPRETER=$VIRTUAL_ENV/bin/python3
# Set default entrypoint to our custom script
ENTRYPOINT ["/opt/n8n/docker-entrypoint.sh"]
