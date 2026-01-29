# Change: Update README to align with Project Setup and Best Practices

## Why
The current `README.md` is outdated and does not reflect the actual architectural decisions, specifically the split between the custom base image (handling the "distroless" n8n limitations) and the application image. It also lacks detailed instructions for the "Serverless Batch" execution mode (`execute-daily`, `execute-curl`) and uses outdated Registry (GCR) instead of Artifact Registry.

## What Changes
- **Architecture Documentation**: Explicitly document the Custom Base Image (`dockerfile.base`) + App Image pattern.
- **Deployment Instructions**: Update build steps to use Google Artifact Registry and the multi-stage build process.
- **Local Development**: Add concrete `docker run` examples for `execute-curl` and `execute-daily` modes found in `ptest/test.sh`.
- **Operational Logic**: Explain the entrypoint logic (Credential hydration -> Publish -> Background Start -> Healthcheck -> Webhook -> Shutdown).

## Impact
- **Affected Specs**: `documentation` (new capability)
- **Affected Code**: `README.md`
