---
description: Save the current work state to a concise handoff file for the next session
agent: build
subtask: false
---

Create or update a handoff file for the current work so another OpenCode session can continue efficiently.

Target path:
- If `$ARGUMENTS` contains a path, use that path.
- Otherwise use `.opencode/HANDOFF.md`.

Use the current conversation context together with the actual repository state (`git status`, relevant diffs, and existing project documentation). Verify repository facts instead of relying only on conversation memory.

The handoff is developer-facing repository context and must be written in English. It must be concise, factual, and useful without the current conversation. Use this structure unless a section is irrelevant:

# Work Handoff

## Goal
## Current State
## Completed
## In Progress
## Key Decisions
## Files Changed
## Verification
## Known Issues and Risks
## Next Steps
## Useful Commands
## Important Context

Rules:

- Update the existing handoff instead of appending stale history.
- Clearly distinguish completed work from planned work.
- Include exact file paths, symbols, commands, and unresolved errors when useful.
- Do not paste large diffs or logs; summarize them and reference files instead.
- Do not include secrets, credentials, tokens, or unnecessary personal data.
- Do not claim tests or checks passed unless they were actually run.
- Keep the file short enough to load at the start of the next session.
- Do not modify production code as part of this command.

After writing the file, report its path and give one short instruction for resuming from it in the next session.
