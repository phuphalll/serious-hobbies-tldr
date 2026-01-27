## ADDED Requirements

### Requirement: Daily Batch Execution
The system SHALL be capable of executing the "Daily Vibe" n8n workflow as a non-interactive batch process.

#### Scenario: Scheduled Run
- **WHEN** the system is triggered by the scheduler (e.g., Cloud Scheduler)
- **THEN** it must initialize the n8n environment
- **AND** import the latest workflows and credentials
- **AND** execute the specific "Daily Vibe" workflow to completion
- **AND** exit with a success status code (0) upon finishing

### Requirement: Remote Artifact Storage
The system SHALL store the generated TLDR HTML report in a designated Supabase Storage bucket.

#### Scenario: Report Generation Success
- **WHEN** the workflow successfully generates the HTML content
- **THEN** the content is uploaded to Supabase Storage
- **AND** the file name includes the current date for versioning

### Requirement: Secure Configuration
The project repository SHALL strictly exclude sensitive information from version control.

#### Scenario: Git Ignore Validation
- **WHEN** a user checks the repository configuration
- **THEN** `.env` files, `credentials/*.json` (containing real secrets), and `n8n-data/` directories are ignored by git
- **AND** example configuration files (`.env.example`) are provided without real secrets
