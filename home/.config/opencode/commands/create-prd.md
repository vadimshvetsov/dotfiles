---
description: Create a practical PRD from current conversation and repo context
---

# Create PRD

Create a product requirements document from this request and context: `$ARGUMENTS`

Usage: `/create-prd <feature|request|problem>`

Use the current conversation and repository context to produce a practical PRD. If the request depends on existing implementation details, inspect the repo first or delegate exploration before drafting. Do not invent architecture when code can answer it.

Rules:

- Ask only blocking clarifying questions. Otherwise make safe assumptions and list them in Further Notes.
- Keep the workflow simple: understand the need, inspect relevant code when needed, identify decisions, confirm testing seams when useful, then draft.
- Focus on outcomes, constraints, and implementation direction. Avoid task-level project management detail.
- Use the project's terminology. Add a small glossary when names, domain concepts, or acronyms could be ambiguous.
- Respect existing design docs, project docs, RFCs, specs, issue threads, and comments. Treat them as constraints unless the PRD explicitly proposes a change.
- Identify testing seams from the repo: existing seams first, highest practical seam next, then prior art. Prefer validating external behavior over implementation details.
- If the testing seam is not obvious, include a short checkpoint asking the user to confirm the proposed seam before implementation starts.
- Call out important implementation choices without over-specifying code. Avoid brittle file paths, class names, function names, or code snippets unless essential for clarity.
- Keep scope tight. Separate non-goals into Out of Scope.
- Do not include attribution, source mentions, or unrelated methodology notes.

Before drafting:

1. Restate the request in repo language.
2. Scan likely existing flows, tests, docs, and prior art when relevant.
3. Note constraints from design docs, project docs, and established patterns.
4. Decide the smallest useful PRD scope.
5. Choose and justify test seams; ask for confirmation if uncertain.

Output exactly these sections:

## Project Terminology

Define project-specific terms, acronyms, domain objects, roles, and glossary items needed to read the PRD. Keep empty if none are needed.

## Problem Statement

Describe the user problem, business value, constraints, and current gaps.

## Solution

Describe the intended product behavior and high-level user experience.

## User Stories

Use numbered stories. Format each story as:

1. As a `<role>`, I want `<capability>`, so that `<outcome>`.
   - Acceptance criteria:
     - `<observable behavior>`
     - `<edge case or constraint>`

## Implementation Decisions

Record key technical/product decisions, repo-specific touchpoints, data flows, permissions, integrations, risks, and relevant design-doc/project-doc constraints. Name files or code only when the reference is stable and necessary.

## Testing Decisions

Identify existing test seams, the highest practical seam, prior art, coverage targets, validation commands, fixtures, mocks, contracts, manual verification, and external behavior to protect. Include a testing seam confirmation checkpoint unless the seam is obvious.

## Out of Scope

List explicit non-goals and deferred work.

## Further Notes

List assumptions, unresolved non-blocking questions, migration notes, rollout concerns, and follow-ups.
