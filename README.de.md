# Portable OpenCode Globales Entwicklungsprofil

[中文](README.md) | **Deutsch** | [English](README.en.md)

Ein leichtgewichtiges, plattformübergreifendes und portables globales OpenCode-Profil für Full-Stack-Entwicklung.

Das Profil trennt OpenCode selbst vollständig von seiner Konfiguration. Es **installiert, umhüllt, pinnt oder ersetzt die OpenCode-Binärdatei nicht**. Dadurch bleibt der normale Update-Mechanismus von OpenCode unverändert.

## Ziele

- Den nativen Plan-/Build-Workflow von OpenCode beibehalten.
- Eine kleine Anzahl klar abgegrenzter spezialisierter Subagents statt eines schweren Multi-Agent-Frameworks verwenden.
- Java / Spring / Spring Boot, Python, Angular / React / Vue, MongoDB, PostgreSQL, MySQL und Oracle unterstützen.
- Interaktion auf Chinesisch, Deutsch oder Englisch ermöglichen, während programmbezogene Artefakte auf Englisch bleiben.
- Wiederverwendbare globale Defaults bereitstellen und gleichzeitig projektspezifische Ergänzungen und Overrides über `.opencode/`, `opencode.json` und `AGENTS.md` erlauben.
- Eine kleine Anzahl nützlicher globaler Commands bereitstellen und `skills/`, `tools/` sowie `plugins/` als saubere Erweiterungspunkte offenhalten.

## Enthaltene Agents

| Agent | Zweck | Ändert Code |
| --- | --- | --- |
| `java-spring-engineer` | Implementierung mit Java / Spring / Spring Boot | Ja |
| `python-engineer` | Python-Backend- und Service-Implementierung | Ja |
| `frontend-engineer` | Frontend-Implementierung mit Angular / React / Vue | Ja |
| `backend-architect` | Analyse der Backend-Architektur | Nein |
| `database-expert` | Analyse von MongoDB / PostgreSQL / MySQL / Oracle | Nein |
| `code-reviewer` | Unabhängiges Code-/Diff-Review | Nein |
| `test-automator` | Gezielte Tests mit dem vorhandenen Projekt-Stack | Nur Testcode |
| `security-auditor` | Security Review | Nein |
| `accessibility-expert` | Web-Accessibility-Review | Nein |
| `performance-engineer` | Evidenzbasierte Performance-Analyse | Nein |

Die Agents pinnen kein Modell. Sie übernehmen die bestehende OpenCode-Modellkonfiguration des Benutzers bzw. Projekts.

## Installation

Die Installer verwalten folgende globale Einträge:

- `AGENTS.md`
- `agents/`
- `skills/`
- `commands/`
- `tools/`
- `plugins/`

Ein vorhandenes `opencode.json` oder `opencode.jsonc` wird **nicht überschrieben**. Nur wenn keine der beiden Dateien existiert, wird das minimale `opencode.json` dieses Profils verlinkt bzw. kopiert.

Bereits vorhandene verwaltete Pfade werden vor dem Ersetzen gesichert.

### Linux / macOS

```bash
./install.sh
```

Alternativ ohne ausführbares Bit:

```bash
bash install.sh
```

Das globale Zielverzeichnis ist:

```text
${XDG_CONFIG_HOME:-$HOME/.config}/opencode
```

### Windows PowerShell

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
```

Wenn `XDG_CONFIG_HOME` gesetzt ist, lautet das Zielverzeichnis:

```text
$env:XDG_CONFIG_HOME\opencode
```

Andernfalls:

```text
$HOME\.config\opencode
```

Für Verzeichnisse werden Junctions verwendet, sodass Änderungen in diesem Git-Repository sofort in der globalen Konfiguration sichtbar werden. Bei einzelnen Dateien bevorzugt der Installer symbolische Links und fällt auf eine Kopie zurück, wenn die Windows-Richtlinie Datei-Symlinks nicht zulässt.

## Installation prüfen

Linux / macOS:

```bash
bash verify.sh
```

Windows:

```powershell
.\verify.ps1
```

## Deinstallation

Linux / macOS:

```bash
bash uninstall.sh
```

Windows:

```powershell
.\uninstall.ps1
```

Die Deinstaller entfernen nur Einträge, die von diesem Profil verwaltet werden. Wurden bei der Installation vorhandene Einträge gesichert, werden sie soweit möglich wiederhergestellt.

## Bestehende OpenCode-Konfiguration

Das Profil ersetzt bewusst keine vorhandene globale `opencode.json` / `opencode.jsonc`, da diese Datei häufig persönliche Model-, Provider-, MCP-, Permission- oder UI-Einstellungen enthält.

Die mitgelieferte `profile/opencode.json` enthält nur das OpenCode-Schema und dient als saubere Standardkonfiguration für Benutzer ohne vorhandene globale Konfiguration.

## Projektspezifische Erweiterungen und Overrides

Ein Projekt kann weiterhin folgende Struktur verwenden:

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

Folgende Informationen gehören in die Projektkonfiguration:

- genaue Java-/Spring-/Python-/Frontend-/Datenbankversionen
- Build- und Testbefehle
- Architektur- und Modulgrenzen
- projektspezifische Agents
- projektspezifische Skills und Commands
- projektspezifische Overrides globaler Defaults

Ein Beispiel befindet sich unter `examples/project/`.

## Enthaltene globale Commands

Das Profil enthält fünf leichtgewichtige globale Commands:

| Command | Zweck | Standardausführung |
| --- | --- | --- |
| `/review` | Unabhängiges Correctness-/Regression-Review der aktuellen Änderungen oder eines Ziels | `code-reviewer` Child-Session |
| `/security-review` | Gezieltes Security Review der aktuellen Änderungen oder eines Ziels | `security-auditor` Child-Session |
| `/verify` | Implementierung mit den kleinsten erforderlichen Checks verifizieren | `build` Child-Session |
| `/handoff` | Arbeitsstand für die nächste Session erzeugen oder aktualisieren | aktuelle `build`-Session |
| `/project-docs` | Technischen Projektkontext aus dem tatsächlichen Repository-Zustand erzeugen oder aktualisieren | aktuelle `build`-Session |

Grundlegende Nutzung:

```text
/review
/security-review
/verify
/handoff
/project-docs
```

Commands können auch Argumente erhalten, zum Beispiel:

```text
/review src/main/java/com/example/security
/security-review authentication flow
/verify affected module
/handoff docs/HANDOFF.md
/project-docs docs/PROJECT.md
```

`/handoff` schreibt standardmäßig `.opencode/HANDOFF.md`. Die Datei hält Ziel, aktuellen Stand, abgeschlossene und laufende Arbeit, wichtige Entscheidungen, geänderte Dateien, Verifikation, Risiken und nächste Schritte fest, sodass eine neue OpenCode-Session effizient fortsetzen kann. Das globale `AGENTS.md` weist den Assistenten außerdem an, `/handoff` rechtzeitig zu empfehlen, wenn eine lange Unterhaltung ein reales Risiko für Context Loss oder Truncation erzeugt; ohne verfügbare Messdaten darf keine exakte verbleibende Token-Zahl behauptet werden.

`/project-docs` schreibt standardmäßig `.opencode/PROJECT.md`. Der Projektkontext wird aus dem tatsächlichen Repository, Build-Dateien, projektspezifischem `AGENTS.md`, CI-Konfiguration und vorhandener Architektur-Dokumentation abgeleitet, statt eine ideale Architektur zu erfinden.

Beide Standarddateien sind entwicklerorientierter Repository-Kontext und werden deshalb gemäß der Sprachrichtlinie auf Englisch geschrieben. Für einen anderen Zielpfad kann dieser als Argument übergeben werden.

Projektspezifische `.opencode/commands/` können diese globalen Commands mit demselben Namen überschreiben.

## Globale Skills und Commands hinzufügen

Die fünf oben genannten Commands sind global aktiv; aktive globale Skills werden standardmäßig nicht mitgeliefert.

Skill hinzufügen:

```text
profile/skills/<skill-name>/SKILL.md
```

Command hinzufügen:

```text
profile/commands/<command-name>.md
```

Vorlagen befinden sich unter `templates/`.

## Sprachrichtlinie

Die Standardsprache für die Interaktion ist Chinesisch. Deutsch oder Englisch kann ausdrücklich angefordert werden.

Unabhängig von der Interaktionssprache bleiben folgende programmbezogene Inhalte auf Englisch:

- Source Code und Identifiers
- Code Comments, Javadoc, JSDoc und TSDoc
- Test Names
- Log-, Exception- und Error-Messages
- API- und Database-Identifier
- Configuration Keys
- Branch Names, Commit Messages und PR Titles für Entwicklungs-Workflows
- entwicklerorientierte technische Repository-Dokumentation

Benutzerseitige Anwendungstexte fallen nicht unter diese Regel und sollen den Localization- und Produktsprachvorgaben des jeweiligen Projekts folgen.

## Designhinweise

Dieses Profil verwendet den standardmäßigen globalen OpenCode-Konfigurationspfad anstelle von `OPENCODE_CONFIG_DIR`. Dadurch bleibt die normale Priorität projektspezifischer Konfiguration erhalten und das portable Profil wird nicht zu einer zusätzlichen Override-Schicht.

Weitere Details:

- `docs/DESIGN.md`
- `docs/SOURCES.md`
