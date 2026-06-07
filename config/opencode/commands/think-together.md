---
description: Interview toward shared understanding and a concise plan
---

# Think Together

Think through this topic with the user: `$ARGUMENTS`

Usage: `/think-together <topic|problem|decision>`

Drive a focused interview until shared understanding is reached. Keep it simple.
Do not create extra documents or a separate skill.

Rules:

- Ask exactly one question at a time.
- Before asking, try to answer from the conversation, `$ARGUMENTS`, and available read-only codebase tools. If discoverable, record the answer and do not ask.
- When asking the user, use the built-in tool for questions when available so options are visible/selectable in the TUI. If unavailable, ask plainly.
- Every question must include a recommended answer or option.
- Resolve design decisions one-by-one. Ask upstream dependency questions before
  downstream details.
