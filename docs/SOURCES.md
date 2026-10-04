# Sources and upstream inspiration

This profile is an original integration. It does not vendor upstream prompt files verbatim.

## OpenCode documentation

- Configuration: https://opencode.ai/docs/config
- Rules / AGENTS.md: https://opencode.ai/docs/rules
- Agents: https://opencode.ai/docs/agents
- Skills: https://opencode.ai/docs/skills
- Commands: https://opencode.ai/docs/commands
- Plugins: https://opencode.ai/docs/plugins
- OpenCode source path handling: https://github.com/anomalyco/opencode/blob/dev/packages/core/src/global.ts

## Agent prompt inspiration

The role boundaries and permission philosophy were informed by mature public agent collections, especially:

- OpenCode Primer: https://github.com/wesammustafa/opencode-primer
  - particularly its OpenCode-native frontend and code-reviewer examples
- Agent Standards: https://github.com/Lukk17/agent-standards
  - particularly its specialist-agent approach, testing/security/accessibility/performance role separation, and cross-tool portability work
- wshobson/agents: https://github.com/wshobson/agents
  - used as a broad reference library for specialist-role coverage

The prompts in this repository were rewritten for this profile's constraints:

- OpenCode-native Markdown agents
- no model pinning
- minimal delegation
- Java/Spring plus Python backend support
- Angular/React/Vue frontend support
- MongoDB/PostgreSQL/MySQL/Oracle database focus
- explicit read-only specialist boundaries
- compatibility with project-level extension and override
