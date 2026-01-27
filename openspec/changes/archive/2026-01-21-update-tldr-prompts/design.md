## Context
The project is moving from a simple summary tool to a high-grade intelligence engine. The complexity of managing 12+ distinct LLM prompts (Research + Analyze for 6 pillars) requires a centralized management strategy. Hardcoding prompts into n8n JSON exports makes version control and editing difficult.

## Goals
- **Centralized Prompt Management**: Prompts live in the repo (`PROMPTS.md`), not hidden in n8n JSON.
- **Strict Data Contracts**: LLMs are non-deterministic; we need them to behave like functions with typed outputs where possible.
- **Production Readiness**: Token optimization, error handling (what if research finds nothing?), and security (injection prevention).

## Decisions
- **Decision: Two-Pass Architecture (Research -> Analyze)**
    - **Why**: Separation of concerns. "Research" gathers facts (high recall). "Analyze" synthesizes meaning (high precision).
- **Decision: Standardized JSON/Markdown Output**
    - **Why**: The "Render" node (HTML generator) needs predictable structure.
    - *DTO Example*:
      ```json
      {
        "pillar": "Geopolitics",
        "critical_events": [...],
        "deep_knowledge": "...",
        "risk_level": "High"
      }
      ```
- **Decision: "Intelligence Terminal" Aesthetic**
    - **Why**: User experience matters. The report must *feel* valuable.
    - *Tech*: Single-file HTML with inline CSS (Obsidian theme).

## Risks / Trade-offs
- **Risk**: Context Window limits.
    - **Mitigation**: "Research" nodes must summarize/truncate inputs before passing to "Analyze".
- **Risk**: Hallucination on "Deep Knowledge".
    - **Mitigation**: Prompts explicitly ask for attribution/sourcing.

## Open Questions
- How do we feed `PROMPTS.md` into n8n automatically?
    - *Current plan*: We document them here. The user (or a script) updates the n8n nodes. We don't have a direct CI/CD pipe for prompts yet.
