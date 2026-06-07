---
description: Convert a plan, spec, PRD, or request into local implementation tasks
agent: jabba-the-hutt
---

# Create Tasks

Convert this plan, spec, PRD, request, or reference into independently grabbable implementation tasks: `$ARGUMENTS`

Usage: `/create-tasks <request|plan|spec|PRD|URL|path|issue-like reference>`

## Purpose

Turn the supplied context into local task files that can be picked up independently by implementers.

Each task should be small enough for one subagent run: deterministic context, clear implementation scope, and verifiable completion.

## Key principle

Prefer tracer-bullet vertical slices through integration layers.

Do not create horizontal layer tickets like "build database", "build API", then "build UI" unless the source explicitly requires that split. A good task should produce a thin, end-to-end, demoable increment.

## Process

### 1. Gather context

- Use the current conversation context first.
- If `$ARGUMENTS` includes a URL, file path, issue-like reference, PRD, spec, or plan, fetch/read the full body and available comments/details where possible.
- Preserve the parent/source reference. Do not mutate the source plan, issue, PRD, or spec.
- Ask a blocking clarification only when the available context is insufficient to draft useful tasks.

### 2. Explore the codebase

- Inspect the current codebase enough to understand existing implementation patterns and integration points.
- Use the project's glossary, domain terms, and naming conventions.
- Respect docs, architecture notes, and existing task conventions.
- If `agent/tasks/` or `.agent/tasks/` already exists, use that convention. Otherwise use `.agent/tasks/`.

### 3. Draft vertical slices

- Draft thin end-to-end tasks that are complete, demoable, and verifiable independently.
- Prefer many thin tasks over a few thick tasks.
- Each task should describe what to build, acceptance criteria, blockers/dependencies, and the user stories covered.
- Identify blockers and dependencies explicitly.
- Keep tasks independently grabbable. Avoid hidden shared context.

### 4. Quiz user

Present the draft breakdown before writing files when judgment is needed.

Use a numbered list with:

- title
- blockers/dependencies
- user stories covered

Ask only about granularity, dependencies, merge/split decisions, or unresolved blockers if needed. Iterate until acceptable.

### 5. Write local tasks

- Create the local task folder if needed.
- Default to `.agent/tasks/` in the current project.
- If `agent/tasks/` or `.agent/tasks/` already exists, use the existing convention.
- Create or update `.agent/TODO.md` as an index in dependency order.
- Create one markdown file per task, for example `.agent/tasks/task-001-short-slug.md`.
- Optionally create `.agent/FIX_PLAN.md` for remaining discovered gaps/blockers if useful.
- Preserve existing tasks. Do not delete tasks or mark them `done` unless explicitly requested and supported by evidence.
- Use only these statuses: `todo`, `in_progress`, `blocked`, `done`.
- Continue existing task ids where possible.

## Local task output

### `.agent/TODO.md`

Index tasks in dependency order. Include task id, title, status, priority, blocked-by summary, and task file path.

### Task file template

```markdown
---
id: task-001
title: Short task title
status: todo
priority: medium
blocked_by: []
source: create-tasks:$ARGUMENTS
created_at: 2026-06-07T00:00:00Z
updated_at: 2026-06-07T00:00:00Z
---

## Parent

Original plan/spec/PRD/request/source reference.

## What to build

Thin vertical slice to implement.

## Acceptance criteria

- Clear done check.

## Blocked by

- `task-000` or external blocker, or `None`.

## Verification

- Deterministic test/build/manual check for this task.

## Notes

- Minimal local notes only when useful.
```

## Rules

- Preserve parent/source. Do not mutate the source plan, issue, PRD, or spec.
- Preserve existing tasks. Do not delete or mark done unless explicitly requested and supported.
- Keep every task small, deterministic, and takeable by one subagent run.
- Do not add unrelated planning systems or issue publishing.
