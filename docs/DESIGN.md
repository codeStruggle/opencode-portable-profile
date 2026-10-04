# Design

## Configuration strategy

This profile is a portable source repository whose managed entries are linked into OpenCode's standard global configuration directory.

It intentionally does not:

- install OpenCode
- replace the OpenCode executable
- wrap the OpenCode executable
- set `autoupdate`
- set a model or provider
- set `OPENCODE_CONFIG_DIR`
- force active global skills

This keeps the OpenCode application lifecycle independent from the profile.

## Global versus project configuration

Global configuration supplies personal development behavior and reusable specialists.

Project configuration remains responsible for project-specific facts such as:

- versions
- build/test commands
- architecture
- module boundaries
- local agents
- local skills
- local commands

OpenCode merges configuration sources and project configuration can override global settings on key conflicts. Project `.opencode` directories are also discovered natively.

## Why the profile links individual entries

Linking the entire `~/.config/opencode` directory would replace user-owned global configuration such as provider/model/MCP settings.

Instead the installer manages only:

- `AGENTS.md`
- `agents`
- `skills`
- `commands`
- `tools`
- `plugins`

An existing `opencode.json` or `opencode.jsonc` is preserved.

## Agent design

The profile separates implementation roles from specialist review roles.

Implementation:

- `java-spring-engineer`
- `python-engineer`
- `frontend-engineer`

Analysis and quality:

- `backend-architect`
- `database-expert`
- `code-reviewer`
- `test-automator`
- `security-auditor`
- `accessibility-expert`
- `performance-engineer`

The primary Plan/Build workflow remains OpenCode's built-in workflow.

Agents are intentionally model-neutral and avoid hardcoding project versions.

## Permissions

Read-only specialists deny editing.

Implementation agents may edit but ask before arbitrary shell execution. Common test/status commands are allowed to reduce friction.

The test agent is instructed to modify test code only. OpenCode permissions do not provide path-level edit restrictions, so this is a behavioral constraint rather than a filesystem sandbox.

## Global commands and extension points

`profile/commands` contains a deliberately small set of explicit workflows:

- `review`
- `security-review`
- `verify`
- `handoff`
- `project-docs`

Review commands run through read-only specialist subagents. Verification runs in a child build session to keep the parent context focused. Handoff and project documentation run in the current build session so they can use the current conversation state as well as the repository state.

`profile/skills`, `profile/tools`, and `profile/plugins` remain empty except for `.gitkeep`, providing stable extension points without loading additional global behavior.

The default continuity files are `.opencode/HANDOFF.md` and `.opencode/PROJECT.md`. They are not automatically trusted: global guidance requires important facts to be verified against the repository because these files can become stale.
