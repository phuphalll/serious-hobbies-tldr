## 1. Security & Configuration
- [x] 1.1 Update `.gitignore` to strictly exclude `credentials/*.json`, `.env`, `n8n_data/`, and other sensitive paths.
- [x] 1.2 Verify `.env.example` exists and contains only template values.

## 2. Docker Infrastructure
- [x] 2.1 Update `Dockerfile` to support CLI-based batch execution (ensure entrypoint supports arguments or script injection).
- [x] 2.2 Update `docker-compose.yml` to reflect the production-like batch execution command (`n8n execute ...`) for testing.

## 3. Workflow Integration
- [x] 3.1 Verify logic for Supabase Storage upload exists in the workflow or add a helper script if needed (likely in n8n workflow itself, but verified here).
- [x] 3.2 Create a `docker-entrypoint.sh` or update command instructions to handle credential import from Env Vars before execution.

## 4. Documentation
- [x] 4.1 Update `README.md` with Cloud Run & Cloud Scheduler deployment instructions.
