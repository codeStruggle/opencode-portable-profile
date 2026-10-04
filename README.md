# Portable OpenCode 全局开发配置

**中文** | [Deutsch](README.de.md) | [English](README.en.md)

一套轻量、跨平台、可移植的 OpenCode 全局开发配置，面向前后端全栈开发。

本配置将 OpenCode 本体与配置完全分离。它**不会安装、包装、固定版本或替换 OpenCode 可执行文件**，因此不会影响 OpenCode 自身的正常升级机制。

## 目标

- 保留 OpenCode 原生的 Plan / Build 工作流。
- 使用少量职责明确的专业 subagent，而不是引入重型 multi-agent 框架。
- 支持 Java / Spring / Spring Boot、Python、Angular / React / Vue、MongoDB、PostgreSQL、MySQL 和 Oracle。
- 与用户交互时支持中文、德语和英语；所有程序相关产物保持英文。
- 全局配置可复用，同时允许项目通过 `.opencode/`、`opencode.json` 和 `AGENTS.md` 添加、扩展或覆盖配置。
- 提供少量高价值全局 commands，并继续预留 `skills/`、`tools/` 和 `plugins/` 扩展入口。

## 包含的 Agents

| Agent | 用途 | 修改代码 |
| --- | --- | --- |
| `java-spring-engineer` | Java / Spring / Spring Boot 实现 | 是 |
| `python-engineer` | Python 后端 / 服务实现 | 是 |
| `frontend-engineer` | Angular / React / Vue 前端实现 | 是 |
| `backend-architect` | 后端架构分析 | 否 |
| `database-expert` | MongoDB / PostgreSQL / MySQL / Oracle 分析 | 否 |
| `code-reviewer` | 独立 code / diff review | 否 |
| `test-automator` | 基于现有项目技术栈补充针对性测试 | 仅测试代码 |
| `security-auditor` | Security review | 否 |
| `accessibility-expert` | Web accessibility review | 否 |
| `performance-engineer` | 基于证据的 performance analysis | 否 |

这些 agents 不固定模型，而是继承用户或项目现有的 OpenCode model 配置。

## 安装

安装脚本管理以下全局配置项：

- `AGENTS.md`
- `agents/`
- `skills/`
- `commands/`
- `tools/`
- `plugins/`

安装脚本**不会覆盖已有的 `opencode.json` 或 `opencode.jsonc`**。只有当两者都不存在时，才会链接或复制本配置中的最小 `opencode.json`。

已有的受管理路径在替换前会先备份。

### Linux / macOS

```bash
./install.sh
```

如果脚本没有 executable permission，也可以运行：

```bash
bash install.sh
```

目标全局配置目录为：

```text
${XDG_CONFIG_HOME:-$HOME/.config}/opencode
```

### Windows PowerShell

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
```

当设置了 `XDG_CONFIG_HOME` 时，目标目录为：

```text
$env:XDG_CONFIG_HOME\opencode
```

否则为：

```text
$HOME\.config\opencode
```

目录使用 Junction，使本 Git 仓库中的修改可以立即反映到全局配置。对于单独文件，安装器优先创建 symbolic link；如果 Windows policy 不允许文件 symlink，则自动回退为复制文件。

## 验证安装

Linux / macOS：

```bash
bash verify.sh
```

Windows：

```powershell
.\verify.ps1
```

## 卸载

Linux / macOS：

```bash
bash uninstall.sh
```

Windows：

```powershell
.\uninstall.ps1
```

卸载脚本只移除此 profile 管理的配置项。如果安装时备份了之前存在的配置，会在条件允许时恢复。

## 已有 OpenCode 配置

本 profile 特意不替换已有的全局 `opencode.json` / `opencode.jsonc`，因为其中通常包含个人的 model、provider、MCP、permission 或 UI 设置。

随包提供的 `profile/opencode.json` 只包含 OpenCode schema，用于没有现有全局配置的用户。

## 项目级扩展与覆盖

项目仍然可以正常使用：

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

以下内容应该放在项目级配置中：

- 精确的 Java / Spring / Python / frontend / database 版本
- build 和 test 命令
- architecture / module boundaries
- 项目专用 agents
- 项目专用 skills 和 commands
- 对全局默认配置的项目级覆盖

示例见 `examples/project/`。

## 内置全局 Commands

本 profile 默认提供 5 个轻量命令：

| Command | 用途 | 默认执行方式 |
| --- | --- | --- |
| `/review` | 对当前修改或指定目标做独立 correctness / regression review | `code-reviewer` child session |
| `/security-review` | 对当前修改或指定目标做 focused security review | `security-auditor` child session |
| `/verify` | 用最小必要测试、编译、lint 等验证当前实现 | `build` child session |
| `/handoff` | 生成或更新当前工作的会话交接文件 | 当前 `build` session |
| `/project-docs` | 根据真实仓库状态生成或更新项目技术说明 | 当前 `build` session |

基本使用：

```text
/review
/security-review
/verify
/handoff
/project-docs
```

命令也可以带参数。例如：

```text
/review src/main/java/com/example/security
/security-review authentication flow
/verify affected module
/handoff docs/HANDOFF.md
/project-docs docs/PROJECT.md
```

`/handoff` 默认写入 `.opencode/HANDOFF.md`。它记录目标、当前状态、已完成内容、进行中的工作、关键决策、修改文件、验证结果、风险以及下一步，便于新的 OpenCode session 快速继续。全局 `AGENTS.md` 还要求：当上下文已经很长、继续工作存在明显 context loss / truncation 风险时，应及时提醒用户运行 `/handoff`；如果无法读取精确的剩余 token 数，则不得假装知道精确数值。

`/project-docs` 默认写入 `.opencode/PROJECT.md`。它基于实际 repository、build files、项目级 `AGENTS.md`、CI 和现有 architecture documentation 创建或更新项目技术上下文，而不是根据推测生成理想化架构。

这两个默认文件都是 developer-facing repository context，因此按本 profile 的语言策略使用英文。若希望写入其他路径，可以直接把目标路径作为命令参数。

项目级 `.opencode/commands/` 可以使用同名 command 覆盖这些全局默认值。

## 添加全局 Skills 和 Commands

本 profile 已包含上述 5 个 global commands，但默认不包含 active global skills。

添加 skill：

```text
profile/skills/<skill-name>/SKILL.md
```

添加 command：

```text
profile/commands/<command-name>.md
```

模板位于 `templates/`。

## 语言策略

默认交互语言为中文，也可以明确要求使用德语或英语。

无论交互使用哪种语言，以下程序相关内容保持英文：

- source code 和 identifiers
- code comments、Javadoc、JSDoc、TSDoc
- test names
- log / exception / error messages
- API 和 database identifiers
- configuration keys
- branch names、commit messages 和开发流程中的 PR titles
- 面向开发者的 repository technical documentation

项目中的用户界面文本不受此规则限制，应遵循项目自身的 localization 和产品语言要求。

## 设计说明

本 profile 使用 OpenCode 标准的全局配置位置，而不是依赖 `OPENCODE_CONFIG_DIR`。这样可以保持正常的项目级配置优先级，也避免 portable profile 变成额外的 override layer。

更详细的设计与 agent 来源说明见：

- `docs/DESIGN.md`
- `docs/SOURCES.md`
