## 1. Foundation & Standards
- [ ] 1.1 Create `PROMPTS.md`: Transform the raw content from `plan_contents_prompt.txt` into a structured, versioned Markdown file. Each prompt must be clearly delimited (e.g., `## Geopolitics Research Prompt`) for easy parsing or manual copying.
- [ ] 1.2 Define **Data Transfer Objects (DTOs)**: Create a `schemas/` directory (conceptually or physically) or simply document the expected JSON structure for each node's output in `design.md`.
    - *Constraint*: Every "Analyze" node must output JSON with specific keys (e.g., `critical_developments`, `counter_intuitive_insights`).
- [ ] 1.3 **Security Review**: Include meaningful sanitization instructions for input variables (e.g., truncating massive RSS feeds, escaping special characters) to be included in the prompt instructions.

## 2. Pillar Implementation Strategy (for each of the 6 pillars)
*Note: This applies to Geopolitics, Markets, Tech, Health, Environment, Thailand*
- [ ] 2.1 **Research Node Spec**: Define the prompt that takes raw queries/feeds and outputs "Research Data".
    - *Must-Have*: Strict temporal constraint ("Last 24 hours").
    - *Optimization*: Request bulleted data points to save tokens.
- [ ] 2.2 **Analyze Node Spec**: Define the prompt that takes "Research Data" and outputs "Strategic Intelligence".
    - *Must-Have*: "Deep Knowledge" extraction and "Cross-Domain Implications" sections.
    - *Output Format*: Strict Markdown or JSON to ensure the "Synthesizer" can parse it.

## 3. Synthesis & Rendering
- [ ] 3.1 **Vibe Summarizer Spec**: Define the 3-sentence summary logic (Sentiment, Driver, Outlook).
- [ ] 3.2 **Synthesizer Spec**: Define the "Intelligence Synthesis Analyst" prompt that merges all 6 pillars.
    - *Constraint*: Must highlight "Cross-Domain Connections".
- [ ] 3.3 **Renderer Spec**: Document the HTML/CSS requirements for the "Intelligence Terminal" design (Obsidian theme, glass-morphism, responsive).

## 4. Documentation & Handover
- [x] 4.1 Update `README.md`: Add the "Intelligence Terminal" section, explaining the 6-pillar flow.
- [x] 4.2 Verify `PROMPTS.md` matches `plan_contents_prompt.txt` exactly but with better formatting.
