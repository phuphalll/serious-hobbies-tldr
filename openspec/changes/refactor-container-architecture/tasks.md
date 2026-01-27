## 1. Analysis & cleanup
- [x] 1.1 Audit current `Dockerfile` dependencies and remove unused packages.
- [x] 1.2 Verify `apk` restore hack necessity and explore alternatives (e.g. using `n8n-nodes-python` or standard python install if supported).

## 2. Security Hardening
- [x] 2.1 Modify `Dockerfile` to remove `COPY ./credentials`.
- [x] 2.2 Update `docker-entrypoint.sh` to generate/load credentials from ENV vars or mounted secrets at runtime.
- [x] 2.3 Ensure strict file permissions for `/opt/n8n` directories (owned by `node`).

## 3. Deployment Logic
- [x] 3.1 Refactor `docker-entrypoint.sh` to be the sole orchestrator for `import` -> `run` -> `exit`.
- [x] 3.2 Add robust error handling in entrypoint (fail fast on missing inputs).
- [x] 3.3 Test local build `docker build . -t test` and run `docker run --env-file .env test execute-daily` to verify decoupling from compose.

## 4. Verification
- [x] 4.1 Run security scan (trivy/grype) on new image if possible (optional).
- [x] 4.2 Verify Cloud Run compatibility (simulate with `docker run`).
- [x] 4.3 Validate `openspec` checks pass.
