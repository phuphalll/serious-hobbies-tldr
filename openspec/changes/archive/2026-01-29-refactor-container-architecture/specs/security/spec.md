## ADDED Requirements
### Requirement: Runtime Secret Injection
The system SHALL load sensitive credentials at runtime rather than build time.

#### Scenario: Environment Variable Injection
- **WHEN** the container starts
- **THEN** it checks for required secrets (Supabase, Gemini, Encryption Key) in environment variables
- **AND** fails fast if critical secrets are missing

#### Scenario: No Baked Secrets
- **WHEN** inspecting the built image
- **THEN** no `credentials.json` or private keys are found in the file system layers

### Requirement: Least Privilege Execution
The system SHALL execute the main application process as a non-root user.

#### Scenario: Node user execution
- **WHEN** the application starts
- **THEN** the process owner MUST be `node` (uid 1000)
- **AND** NOT `root`
