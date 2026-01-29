## ADDED Requirements

### Requirement: Project Architecture Documentation
The README MUST document the multi-stage container architecture used to support Python and custom tools in n8n.

#### Scenario: Base Image Explanation
- **WHEN** a developer reads the Architecture section
- **THEN** they see the distinction between the Base Image (APK hack, Python setup) and Application Image (Workflows, Config)

### Requirement: Deployment Build Steps
The README MUST provide exact commands to build and push both Base and Application images to Google Artifact Registry.

#### Scenario: Building Base Image
- **WHEN** a developer needs to update the runtime environment
- **THEN** they have the `docker build` command for `dockerfile.base` pointing to Artifact Registry

#### Scenario: Building App Image
- **WHEN** a developer deploys new workflows
- **THEN** they have the `docker build` command for `Dockerfile` using the custom base

### Requirement: Serverless Batch Execution Documentation
The README MUST explain how the n8n container functions as a transient batch job.

#### Scenario: Batch Job Flow
- **WHEN** reading about the Execution Modes
- **THEN** the lifecycle is described: Start n8n -> Import Creds -> Healthcheck -> Trigger Webhook -> Capture Result -> Exit

### Requirement: Local Testing Commands
The README MUST provide copy-pasteable `docker run` commands for testing the batch logic locally.

#### Scenario: Testing Daily Workflow
- **WHEN** a developer wants to simulate the Cloud Run job locally
- **THEN** they can run `docker run ... execute-daily` with correct volume mounts for credentials and logs

### Requirement: Infrastructure as Code Documentation
The README MUST explain how to use the provided Terraform configuration to provision the Google Cloud environment.

#### Scenario: Provisioning Resources
- **WHEN** a developer wants to set up the cloud environment
- **THEN** they have instructions to configure `terraform.tfvars` and run `terraform apply`

#### Scenario: Manual Steps
- **WHEN** reading the Terraform section
- **THEN** they are explicitly warned about steps Terraform cannot handle fully (e.g., uploading the initial Secret Manager payload or GCS file)
