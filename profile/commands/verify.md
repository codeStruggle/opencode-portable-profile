---
description: Verify the current implementation with the smallest relevant checks
agent: build
subtask: true
---

Verify `$ARGUMENTS` if a target or verification goal was provided. Otherwise verify the current implementation and working-tree changes.

Use the project's existing toolchain and start with the smallest relevant checks. Inspect the changed files and project configuration, then run only the tests, type checks, compiler checks, linting, static analysis, builds, or integration checks justified by the change.

Do not modify production code just to make verification pass. Report:

1. What was verified.
2. Commands/checks executed and their results.
3. Any failures or unverified areas.
4. The smallest next action if verification is incomplete.
