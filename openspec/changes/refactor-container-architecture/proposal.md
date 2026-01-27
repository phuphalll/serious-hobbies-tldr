# Change: Refactor Container Architecture for Security and Cloud Run

## Why
The current container setup has critical security flaws (baking credentials into the image) and relies on fragile hacks (apk restoration). The deployment logic is tightly coupled with local development patterns (docker-compose) rather than being optimized for a stateless, production-ready Cloud Run environment.

## What Changes
- **Security**: Remove `COPY ./credentials` from Dockerfile to prevent secret leakage. Implement runtime credential injection via Environment Variables or Secret Manager integration.
- **Architecture**: Refactor `Dockerfile` to follow n8n custom image best practices without fragile hacks if possible, or isolate them.
- **Logic**: Unify execution logic into a robust `docker-entrypoint.sh` that handles both "server" (dev) and "batch" (prod) modes autonomously.
- **Cleanup**: Remove reliance on `docker-compose` for production artifacts.

## Impact
- **Affected Specs**: Deployment, Security, Automation
- **Affected Code**: `Dockerfile`, `docker-entrypoint.sh`, `docker-compose.yml` (dev only), `credentials/` (workflow impact)
