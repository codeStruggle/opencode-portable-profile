---
description: Create or update a concise technical project context document from the current repository state
agent: build
subtask: false
---

Create or update the project's technical context document based on the current repository state and relevant decisions from the current session.

Target path:
- If `$ARGUMENTS` contains a path, use that path.
- Otherwise use `.opencode/PROJECT.md`.

Inspect the repository before writing. Prefer facts from source code, build/dependency files, project-level `AGENTS.md`, `.opencode/`, CI configuration, and existing architecture documentation. Preserve useful existing content and update only sections whose facts have changed.

The document is developer-facing repository documentation and must be written in English.

Use this structure where applicable:

# Project Context

## Purpose
## Technology Stack
## Repository Structure
## Architecture
## Main Components and Responsibilities
## Data and Persistence
## External Integrations
## Build and Run
## Test and Verification
## Configuration
## Development Conventions
## Important Constraints and Decisions
## Known Limitations

Rules:

- Describe the project as it exists now, not an idealized redesign.
- Record exact versions only when they can be verified from the repository.
- Do not duplicate large existing documents; link/reference their paths and summarize only what is needed for project context.
- Do not invent architecture, commands, dependencies, or operational procedures.
- Do not include secrets, credentials, tokens, or environment-specific sensitive values.
- Keep the document concise enough to be useful as context for future development sessions.
- Do not modify production code as part of this command.

After writing the file, summarize which sections were created or materially updated.
