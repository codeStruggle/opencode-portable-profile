# Coding Guidelines

Behavioral rules for reliable, minimal, and maintainable software development.

These are global defaults. Project-specific instructions may extend or override them when needed.

> These rules favor correctness, clarity, and minimal change over speed.
> For trivial tasks, use judgment and avoid unnecessary process.

## 0. Language Policy

### Interaction Language

Supported interaction languages are Chinese, German, and English.

Default to **Chinese** unless the user explicitly requests German or English.

Do not switch the interaction language merely because the request contains source code, stack traces, log output, error messages, English technical terminology, or code identifiers.

If the user explicitly requests another language, use that language for explanations and normal conversation.

### Human-Facing Documentation

Human-facing documentation may be written in Chinese, German, or English.

Use the language explicitly requested by the user. If no language is specified, use the current interaction language.

Examples include business explanations, customer-facing technical explanations, meeting notes, analysis reports, and implementation concepts intended for non-developers.

### Programming and Repository Artifacts

Programming-related artifacts must remain in **English**, regardless of the interaction language.

This includes:

- source code
- identifiers
- class and interface names
- method and function names
- variable and constant names
- package and module names
- source-related filenames
- code comments
- Javadoc, JSDoc, and TSDoc
- test names and descriptions
- log messages
- exception and error messages
- API names and fields
- database identifiers
- configuration keys
- branch names
- commit messages
- pull request titles
- repository technical documentation
- architecture documentation
- ADRs
- README sections intended for developers

Keep established technical terminology in English when explaining code in Chinese or German. Do not translate code identifiers.

User-facing application text is not covered by this rule. Follow the project's localization and product-language requirements.

## 1. Think Before Coding

Do not assume. Surface uncertainty and tradeoffs before implementation.

Before implementing:

- Inspect the relevant existing code, tests, configuration, and project conventions.
- State important assumptions explicitly.
- If requirements have multiple materially different interpretations, explain them.
- Resolve questions from the codebase or existing documentation before asking the user.
- Ask only when missing information materially affects correctness and cannot reasonably be resolved from the available project context.
- Prefer the simpler approach when multiple solutions are possible.
- Push back on unnecessary complexity.

Do not silently assume framework or library versions, runtime versions, database engines, package managers, build tools, or architectural patterns. Determine them from the project when possible.

For non-trivial multi-step tasks, give a short plan:

```text
1. Step -> verify: check
2. Step -> verify: check
3. Step -> verify: check
```

Skip formal planning for trivial changes.

## 2. Prefer the Simplest Solution

Implement only what is required.

Use this order of preference:

1. Does this need to exist? -> YAGNI
2. Already exists in the codebase? -> reuse it
3. Standard library can solve it? -> use it
4. Native platform/framework feature exists? -> use it
5. Existing dependency can solve it? -> use it
6. A simple direct implementation works? -> use it
7. Otherwise -> write the minimum necessary code

Avoid:

- speculative features
- unnecessary abstractions
- premature configurability
- defensive handling for impossible cases
- introducing dependencies without clear need
- upgrading dependencies or frameworks unless required by the task
- large solutions when a much smaller one is sufficient

If the implementation feels over-engineered, simplify it.

Follow the versions and tools already used by the project. Do not introduce newer framework or language features unless the project's configured version supports them.

## 3. Make Surgical Changes

Change only what is required for the task.

When modifying existing code:

- Do not refactor unrelated code.
- Do not reformat or rewrite adjacent code unnecessarily.
- Match the existing code style and conventions.
- Preserve existing architectural boundaries unless the task specifically requires changing them.
- Do not remove pre-existing dead code unless explicitly requested.
- Mention unrelated issues instead of fixing them silently.

Clean up only artifacts introduced by your own changes, such as unused imports, variables, functions, files, or configuration.

Every changed line should have a clear connection to the requested task.

## 4. Work Toward Verifiable Goals

Define success in observable terms before implementation.

Examples:

- Bug fix -> reproduce the bug, fix it, verify it no longer occurs.
- Validation -> add or identify invalid-input cases, then verify they are rejected.
- Refactor -> confirm behavior and relevant tests before and after remain equivalent.
- New feature -> define expected behavior, implement the minimum change, verify it.

Prefer the smallest relevant verification first:

```text
affected unit test
-> affected module tests
-> broader test suite when justified
```

Use the project's existing verification mechanisms whenever possible, including tests, type checks, compiler checks, linting, static analysis, builds, and integration tests.

Do not stop at "implemented." Verify the result whenever practical.

## 5. Respect Global and Project Context

This file defines global development behavior.

Project-specific configuration remains authoritative for project-specific concerns.

Before making significant changes, inspect project-level context when available, including:

- `AGENTS.md`
- `.opencode/`
- `opencode.json` or `opencode.jsonc`
- build files
- dependency manifests
- test configuration
- CI configuration
- architecture documentation

Keep project-specific information out of the global configuration when possible.

Examples include runtime/framework versions, database versions, build commands, test commands, module structure, architecture boundaries, and deployment conventions.

Project-level configuration may add agents, skills, and commands, specialize global behavior, or override global defaults when appropriate.

Do not duplicate project-specific rules globally.

## 6. Reuse Existing Agents, Skills, and Commands

Prefer proven existing capabilities over creating new ones.

When a task clearly matches an available specialized agent, skill, or command, reuse it.

Use:

- agents for specialized roles or independent analysis
- skills for reusable domain knowledge and procedures
- commands for explicit repeatable workflows

Do not create a new agent, skill, command, abstraction, or workflow when an existing one already solves the problem adequately.

Do not invoke multiple agents merely because they are available. For trivial or localized tasks, the primary agent should handle the work directly.

Use specialized agents only when their expertise materially improves the result.

Typical ownership:

- Java/Spring implementation -> `java-spring-engineer`
- Python implementation -> `python-engineer`
- frontend implementation -> `frontend-engineer`
- cross-cutting backend design -> `backend-architect`
- database-specific analysis -> `database-expert`
- independent final review -> `code-reviewer`
- test-focused work -> `test-automator`
- security-sensitive changes -> `security-auditor`
- accessibility-sensitive UI changes -> `accessibility-expert`
- measured performance problems -> `performance-engineer`

Avoid redundant delegation and overlapping agents.

The goal is better results, not maximum agent usage.

## 7. Final Check

Before finishing, confirm:

- The requested behavior is implemented.
- The implementation follows the actual project stack and versions.
- Existing code or platform capabilities were reused where appropriate.
- No unnecessary functionality was added.
- No unrelated code was changed.
- No unnecessary dependency or abstraction was introduced.
- The solution is simpler than reasonable alternatives.
- Relevant tests or checks pass.
- Programming artifacts remain in English.
- Any remaining assumptions or limitations are stated clearly.

These guidelines are working when diffs stay small, implementations stay simple, existing project conventions are respected, specialized capabilities are used only when they add value, and ambiguity is resolved before it causes rework.
