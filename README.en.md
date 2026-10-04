# Portable OpenCode Global Development Profile

[中文](README.md) | [Deutsch](README.de.md) | **English**

A lightweight, cross-platform, portable global OpenCode profile for full-stack development.

The profile keeps OpenCode itself fully separate from configuration. It does **not install, wrap, pin, or replace the OpenCode binary**, so OpenCode's normal update mechanism remains untouched.

## Goals

- Keep OpenCode's built-in Plan / Build workflow.
- Add a small set of specialized subagents instead of a heavy multi-agent framework.
- Support Java / Spring / Spring Boot, Python, Angular / React / Vue, MongoDB, PostgreSQL, MySQL, and Oracle.
- Allow Chinese, German, or English interaction while keeping programming-related artifacts in English.
- Keep global defaults reusable while allowing project-level additions and overrides through `.opencode/`, `opencode.json`, and `AGENTS.md`.
- Reserve global `skills/`, `commands/`, `tools/`, and `plugins/` extension points without enabling extra behavior by default.

## Included agents

| Agent | Purpose | Edits code |
| --- | --- | --- |
| `java-spring-engineer` | Java / Spring / Spring Boot implementation | Yes |
| `python-engineer` | Python backend and service implementation | Yes |
| `frontend-engineer` | Angular / React / Vue frontend implementation | Yes |
| `backend-architect` | Backend architecture analysis | No |
| `database-expert` | MongoDB / PostgreSQL / MySQL / Oracle analysis | No |
| `code-reviewer` | Independent code / diff review | No |
| `test-automator` | Focused tests using the existing project stack | Test code only |
| `security-auditor` | Security review | No |
| `accessibility-expert` | Web accessibility review | No |
| `performance-engineer` | Evidence-based performance analysis | No |

The agents intentionally do not pin a model. They inherit the user's or project's existing OpenCode model configuration.

## Installation

The installers manage these global entries:

- `AGENTS.md`
- `agents/`
- `skills/`
- `commands/`
- `tools/`
- `plugins/`

They **do not overwrite an existing `opencode.json` or `opencode.jsonc`**. If neither exists, the minimal profile `opencode.json` is linked or copied.

Existing managed paths are backed up before replacement.

### Linux / macOS

```bash
./install.sh
```

Or run without executable permission:

```bash
bash install.sh
```

The target global directory is:

```text
${XDG_CONFIG_HOME:-$HOME/.config}/opencode
```

### Windows PowerShell

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
```

The target global directory is:

```text
$env:XDG_CONFIG_HOME\opencode
```

when `XDG_CONFIG_HOME` is set, otherwise:

```text
$HOME\.config\opencode
```

Directory junctions are used so changes in this Git repository are reflected immediately in the global configuration. For individual files, the installer prefers symbolic links and falls back to copying when Windows policy does not allow file symlinks.

## Verify installation

Linux / macOS:

```bash
bash verify.sh
```

Windows:

```powershell
.\verify.ps1
```

## Uninstall

Linux / macOS:

```bash
bash uninstall.sh
```

Windows:

```powershell
.\uninstall.ps1
```

The uninstallers remove only entries managed by this profile. If installation backed up previous entries, they are restored when possible.

## Existing OpenCode configuration

The profile deliberately avoids replacing an existing global `opencode.json` / `opencode.jsonc`, because that file commonly contains personal model, provider, MCP, permission, or UI settings.

The bundled `profile/opencode.json` contains only the OpenCode schema and serves as a clean default for users without an existing global config.

## Project-level extension and override

A project can continue to use:

```text
project/
├── AGENTS.md
├── opencode.json
└── .opencode/
    ├── agents/
    ├── skills/
    ├── commands/
    ├── tools/
    └── plugins/
```

Project configuration is the right place for:

- exact Java / Spring / Python / frontend / database versions
- build and test commands
- architecture and module boundaries
- project-specific agents
- project-specific skills and commands
- project-level overrides of global defaults

See `examples/project/`.

## Adding global skills and commands

No active global skills or commands are included by default.

Add a skill under:

```text
profile/skills/<skill-name>/SKILL.md
```

Add a command under:

```text
profile/commands/<command-name>.md
```

Templates are available in `templates/`.

## Language policy

The default interaction language is Chinese. German or English can be explicitly requested.

Regardless of the interaction language, the following programming-related content remains in English:

- source code and identifiers
- code comments, Javadoc, JSDoc, and TSDoc
- test names
- log, exception, and error messages
- API and database identifiers
- configuration keys
- branch names, commit messages, and PR titles used in development workflows
- developer-facing repository technical documentation

User-facing application text is not covered by this rule and should follow the project's localization and product-language requirements.

## Design notes

The profile uses the standard global OpenCode config location rather than `OPENCODE_CONFIG_DIR`. This preserves normal project-level configuration precedence and avoids turning the portable profile into an extra override layer.

See:

- `docs/DESIGN.md`
- `docs/SOURCES.md`
