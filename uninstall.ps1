$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($env:XDG_CONFIG_HOME) {
    $ConfigBase = $env:XDG_CONFIG_HOME
} else {
    $ConfigBase = Join-Path $HOME ".config"
}

$TargetDir = Join-Path $ConfigBase "opencode"
$Marker = Join-Path $TargetDir ".portable-profile-install.json"
$Managed = @("AGENTS.md", "agents", "skills", "commands", "tools", "plugins")

$BackupDir = $null
$ConfigManaged = $false
$Manifest = $null
$ProfileDir = $ScriptDir

if (Test-Path -LiteralPath $Marker) {
    $Manifest = Get-Content -LiteralPath $Marker -Raw | ConvertFrom-Json
    $BackupDir = $Manifest.backupDir
    $ConfigManaged = [bool]$Manifest.configManaged
    if ($Manifest.profileDir) {
        $ProfileDir = $Manifest.profileDir
    }
}

$SourceDir = Join-Path $ProfileDir "profile"

function Remove-ManagedEntry {
    param(
        [string]$Target,
        [string]$Source,
        [string]$Mode
    )

    if (-not (Test-Path -LiteralPath $Target)) {
        return
    }

    $Item = Get-Item -LiteralPath $Target -Force

    if ($Item.LinkType) {
        $MatchesSource = ($Item.Target -contains $Source -or $Item.Target -eq $Source)
        if ($MatchesSource) {
            Remove-Item -LiteralPath $Target -Force
            Write-Host "Removed managed link: $Target"
        }
        return
    }

    if ($Mode -eq "copy" -and (Test-Path -LiteralPath $Source -PathType Leaf)) {
        $TargetHash = (Get-FileHash -LiteralPath $Target -Algorithm SHA256).Hash
        $SourceHash = (Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash
        if ($TargetHash -eq $SourceHash) {
            Remove-Item -LiteralPath $Target -Force
            Write-Host "Removed managed copied file: $Target"
        } else {
            Write-Host "Preserved modified copied file: $Target"
        }
    }
}

foreach ($Name in $Managed) {
    $Target = Join-Path $TargetDir $Name
    $Source = Join-Path $SourceDir $Name
    $Mode = if ($Manifest -and $Manifest.fileModes.$Name) { [string]$Manifest.fileModes.$Name } else { $null }

    Remove-ManagedEntry -Target $Target -Source $Source -Mode $Mode

    if ($BackupDir) {
        $Backup = Join-Path $BackupDir $Name
        if ((Test-Path -LiteralPath $Backup) -and -not (Test-Path -LiteralPath $Target)) {
            Move-Item -LiteralPath $Backup -Destination $Target
            Write-Host "Restored backup: $Target"
        }
    }
}

if ($ConfigManaged) {
    $Name = "opencode.json"
    $Target = Join-Path $TargetDir $Name
    $Source = Join-Path $SourceDir $Name
    $Mode = if ($Manifest -and $Manifest.fileModes.$Name) { [string]$Manifest.fileModes.$Name } else { $null }

    Remove-ManagedEntry -Target $Target -Source $Source -Mode $Mode
}

if (Test-Path -LiteralPath $Marker) {
    Remove-Item -LiteralPath $Marker -Force
}

if ($BackupDir -and (Test-Path -LiteralPath $BackupDir)) {
    try {
        Remove-Item -LiteralPath $BackupDir -Force
    } catch {
        # Non-empty backups are intentionally preserved.
    }
}

Write-Host ""
Write-Host "Portable OpenCode profile uninstalled."
Write-Host "OpenCode itself was not modified."
