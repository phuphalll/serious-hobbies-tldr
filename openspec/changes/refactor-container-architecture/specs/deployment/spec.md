## ADDED Requirements
### Requirement: Production-Ready Container Image
The system SHALL build a self-contained Docker image optimized for Google Cloud Run execution.

#### Scenario: Build success without secrets
- **WHEN** `docker build` is executed
- **THEN** the image is created successfully
- **AND** no `credentials/*.json` files are present in the image layer

#### Scenario: Runtime execution
- **WHEN** the container starts in a Cloud Run environment
- **THEN** it must successfully import workflows
- **AND** execute the target workflow without external orchestration (like docker-compose)

### Requirement: Single Dockerfile Architecture
The system SHALL use a single `Dockerfile` to support both local development (server mode) and production execution (batch mode).

#### Scenario: Mode switching
- **WHEN** the container is started with argument `execute-daily`
- **THEN** it executes the batch job and exits
- **WHEN** the container is started with no arguments
- **THEN** it starts the n8n server process
