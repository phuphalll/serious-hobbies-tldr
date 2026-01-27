## Context
The application is a "Daily Vibe" intelligence generator. Currently, it exists as n8n workflows and Docker config. The goal is to move from a potential persistent server model to a cost-effective "serverless" batch model using Google Cloud Run + Cloud Scheduler.

## Goals / Non-Goals
- **Goals**:
    - Run once daily at specific time (08:00 BKK).
    - Zero cost if possible (Free Tier).
    - Persist output permanently in Supabase.
    - Secure handling of API keys (Gemini, N8N encryption).
- **Non-Goals**:
    - Real-time trigger handling (webhooks).
    - Maintaining n8n UI state/history in the cloud (logs might be ephemeral or streamed to stdout).

## Decisions
- **Decision: Ephemeral Container Strategy**
    - The container will start, import workflows/credentials, run the specific workflow via CLI, and exit.
    - **Why**: Cloud Run charges by compute time. Batch jobs fit this model perfectly.
- **Decision: Supabase Storage for Artifacts**
    - **Why**: Decouples storage from compute. Ephemeral containers lose filesystem data on exit.
- **Decision: Secret Injection**
    - Secrets (Gemini Key, Encryption Key, Supabase Creds) will be injected as Environment Variables via Cloud Run configuration.
    - Credential files (JSON) for n8n might need to be generated at runtime or imported from a mounted volume/secret if n8n CLI requires them on disk. *Refinement*: We will try to use env var substitution or pre-baked images with safe defaults if possible, or script the creation of credential files from env vars at entrypoint.

## Risks / Trade-offs
- **Risk**: n8n CLI requires specific setup for credentials.
    - **Mitigation**: Use `n8n import:credentials` in the entrypoint script using a template populated by env vars.
- **Risk**: Cold start time.
    - **Mitigation**: Irrelevant for a daily batch job.

## Migration Plan
- Validated locally using `docker compose run`.
- Deploy to Cloud Run manually or via CI/CD (out of scope for now, just instructions).
