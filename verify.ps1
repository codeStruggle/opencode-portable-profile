$ErrorActionPreference = "Stop"

if ($env:XDG_CONFIG_HOME) {
    $ConfigBase = $env:XDG_CONFIG_HOME
} else {
    $ConfigBase = Join-Path $HOME ".config"
}

$TargetDir = Join-Path $ConfigBase "opencode"
Write-Host "OpenCode config directory: $TargetDir"

foreach ($Name in @("AGENTS.md", "agents")) {
    $Path = Join-Path $TargetDir $Name
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing: $Path"
    }
}

$AgentCount = (Get-ChildItem -LiteralPath (Join-Path $TargetDir "agents") -Filter "*.md" -File).Count
if ($AgentCount -lt 10) {
    throw "Expected at least 10 agents, found $AgentCount"
}

Write-Host "Agents discovered in config directory: $AgentCount"

$OpenCode = Get-Command opencode -ErrorAction SilentlyContinue
if ($OpenCode) {
    Write-Host "OpenCode: $($OpenCode.Source)"
    & opencode --version
} else {
    Write-Host "OpenCode binary not found in PATH. Configuration files are installed, but OpenCode itself is not installed by this profile."
}

Write-Host "Verification passed."
