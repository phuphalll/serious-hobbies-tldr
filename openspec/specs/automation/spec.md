# automation Specification

## Purpose
TBD - created by archiving change add-daily-tldr-automation. Update Purpose after archive.
## Requirements
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

### Requirement: Analytical Framework
The system SHALL utilize a defined 6-pillar analytical framework for generating the daily briefing.

#### Scenario: Pillar Coverage
- **WHEN** the daily workflow runs
- **THEN** it must process data for Geopolitics, Markets, Tech, Health, Environment, and Thailand
- **AND** apply a "Research -> Analyze" two-step process for each pillar
- **AND** ensure strictly "Last 24 Hours" temporal constraint

### Requirement: Intelligence Terminal Output
The system SHALL render the final HTML report using the "Intelligence Terminal" visual design language.

#### Scenario: Visual Styling
- **WHEN** generating the final HTML
- **THEN** it must use the "Obsidian" color palette (#0A0E27 background)
- **AND** implement the specific CSS typography (Space Grotesk, Inter, JetBrains Mono)
- **AND** include specific UI components like the "Vibe of the Day" card and "Counter-Intuitive Insights" spotlight

### Requirement: Data Contracts (DTOs)
Each analytical node SHALL output structured data to ensure reliable synthesis.

#### Scenario: Analyze Node Output
- **WHEN** an "Analyze" node completes (e.g., Analyze Markets)
- **THEN** it must return a structured result containing at least: "Critical Developments", "Deep Knowledge", and "Strategic Implications"
- **AND** exclude conversational preamble (e.g., "Here is the analysis...")

### Requirement: Prompt Versioning
System prompts SHALL be maintained in a dedicated documentation file (`PROMPTS.md`) to act as the Single Source of Truth.

#### Scenario: Prompt Update
- **WHEN** the analytical logic needs changing
- **THEN** the change is first applied to `PROMPTS.md`
- **AND** then propagated to the n8n workflow

### Requirement: Cross-Domain Synthesis
The final briefing SHALL explicitly connect insights across different pillars.

#### Scenario: Synthesis Generation
- **WHEN** all pillar analyses are complete
- **THEN** the synthesizer node must identify at least 3 thematic connections between domains (e.g., Geopolitics impacting Tech Supply Chains)
- **AND** generate specific "Actionable Intelligence" for different user personas (Investors, Policymakers, Technologists)

