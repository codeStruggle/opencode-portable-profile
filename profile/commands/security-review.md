---
description: Run a focused security review of the current changes or a specified target
agent: security-auditor
subtask: true
---

Perform a focused security review of `$ARGUMENTS` if a target was provided. If no target was provided, review the current security-relevant working-tree changes and directly relevant surrounding code/configuration.

Prioritize exploitable or practically significant issues. State preconditions, impact, and the smallest effective remediation. Distinguish confirmed findings from hardening suggestions.

Do not modify files.
