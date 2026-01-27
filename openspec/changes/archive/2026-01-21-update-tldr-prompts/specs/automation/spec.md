## ADDED Requirements

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
