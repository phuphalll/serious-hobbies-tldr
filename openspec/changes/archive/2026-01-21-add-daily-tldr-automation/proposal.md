# Change: Add Daily TLDR Automation

## Why
The user requires a daily automated intelligence briefing covering Geopolitics, Finance, Tech, Health, Environment, and Thailand. To minimize costs and leverage modern cloud infrastructure, this system needs to run as a batch job on Google Cloud Run (Free Tier) with Cloud Scheduler, rather than a persistent server. Storing output in Supabase ensures reliable, accessible, and decoupled storage for the generated HTML reports.

## What Changes
- **Architecture**: Configure n8n to run as an ephemeral batch process (`n8n execute`) instead of a long-running server.
- **Infrastructure**: Optimize `Dockerfile` for Cloud Run execution and update `docker-compose.yml` for local development parity.
- **Storage**: Implement logic/configuration to save generated HTML reports to Supabase Storage.
- **Security**: audit and update `.gitignore` to strictly exclude secrets, credential files, and build artifacts, adhering to security best practices.
- **Automation**: Define the daily schedule (08:00 AM Bangkok time) via Cloud Scheduler configuration (documented/scripted).

## Impact
- **Specs**: Adds new `automation` capability.
- **Files**:
    - `Dockerfile` (Updated for batch execution)
    - `docker-compose.yml` (Updated for dev/batch testing)
    - `.gitignore` (Hardened)
    - `workflows/` (Potential updates for storage logic)
    - `README.md` (Deployment instructions)
