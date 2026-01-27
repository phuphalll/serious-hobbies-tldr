# Change: Update TLDR Workflow Prompts

## Why
The current n8n workflow for the Daily TLDR Briefing operates on a basic summary model that lacks depth and strategic value. To transform this into a premium "Intelligence Terminal" product, we must implement a rigorous 6-pillar analytical framework (Geopolitics, Markets, Tech, Health, Environment, Thailand). This requires precise prompt engineering, strict data contracts (DTOs) between n8n nodes, and a modular architecture that ensures reliability, security, and scalability. The user has provided a detailed "Knowledge Specification" (`plan_contents_prompt.txt`) which serves as the blueprint for this upgrade.

## What Changes
- **Architecture**:
    - Formalize the **Research -> Analyze -> Summarize -> Synthesize -> Render** pipeline.
    - Introduce a **Single Source of Truth (SSOT)** for prompts via a new `PROMPTS.md` file (or JSON equivalent) to version-control the prompt logic separate from the n8n binary workflow.
- **Data Contracts (DTOs)**:
    - Define strict JSON schemas for the output of each "Research" and "Analyze" node to ensure the "Synthesize" node receives structured data, not just text blobs.
    - **Security**: Implement input sanitization to prevent prompt injection from external data sources (e.g., RSS feeds).
- **Documentation**:
    - Update `README.md` to document the "Intelligence Terminal" philosophy.
    - Create `PROMPTS.md` containing the exact system prompts for all 12+ modules.
- **Optimization**:
    - Optimize context window usage by enforcing strict output formats (removing preambles/meta-commentary) in the LLM prompts.

## Impact
- **Specs**: Updates `automation` capability with strict prompt engineering and data shape requirements.
- **Files**:
    - `PROMPTS.md` (New)
    - `README.md` (Updated)
    - `workflows/` (Conceptual update - the proposal defines *how* they should change)
- **Security**: Reduces risk of hallucination and injection by bounding LLM outputs with rigid schemas.
