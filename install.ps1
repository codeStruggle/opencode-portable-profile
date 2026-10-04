$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = Join-Path $ScriptDir "profile"

if ($env:XDG_CONFIG_HOME) {
    $ConfigBase = $env:XDG_CONFIG_HOME
} else {
    $ConfigBase = Join-Path $HOME ".config"
}

$TargetDir = Join-Path $ConfigBase "opencode"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$Marker = Join-Path $TargetDir ".portable-profile-install.json"
$Managed = @("AGENTS.md", "agents", "skills", "commands", "tools", "plugins")

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

$ExistingManifest = $null
$BackupDir = Join-Path $TargetDir ".portable-profile-backup-$Stamp"
$ConfigManaged = $false
$FileModes = @{}

if (Test-Path -LiteralPath $Marker) {
    $Candidate = Get-Content -LiteralPath $Marker -Raw | ConvertFrom-Json
    if ($Candidate.profileDir -eq $ScriptDir) {
        $ExistingManifest = $Candidate
        $BackupDir = $Candidate.backupDir
        $ConfigManaged = [bool]$Candidate.configManaged
        if ($Candidate.fileModes) {
            foreach ($Property in $Candidate.fileModes.PSObject.Properties) {
                $FileModes[$Property.Name] = [string]$Property.Value
            }
        }
    }
}

function Backup-Path {
    param(
        [string]$Target,
        [string]$Name
    )
    if (Test-Path -LiteralPath $Target) {
        New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
        Move-Item -LiteralPath $Target -Destination (Join-Path $BackupDir $Name)
    }
}

function Is-LinkTo {
    param(
        [string]$Target,
        [string]$Source
    )

    if (-not (Test-Path -LiteralPath $Target)) {
        return $false
    }

    $Item = Get-Item -LiteralPath $Target -Force
    if (-not $Item.LinkType) {
        return $false
    }

    return ($Item.Target -contains $Source -or $Item.Target -eq $Source)
}

function New-ManagedDirectoryLink {
    param(
        [string]$Source,
        [string]$Target,
        [string]$Name
    )

    if (Is-LinkTo -Target $Target -Source $Source) {
        Write-Host "Already linked: $Target"
        return "junction"
    }

    Backup-Path -Target $Target -Name $Name

    # Junctions normally work without Developer Mode/admin and track profile updates.
    New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
    Write-Host "Linked: $Target -> $Source"
    return "junction"
}

function New-ManagedFile {
    param(
        [string]$Source,
        [string]$Target,
        [string]$Name,
        [string]$ExistingMode
    )

    if (Is-LinkTo -Target $Target -Source $Source) {
        Write-Host "Already linked: $Target"
        return "link"
    }

    if ($ExistingMode -eq "copy" -and (Test-Path -LiteralPath $Target)) {
        Copy-Item -LiteralPath $Source -Destination $Target -Force
        Write-Host "Updated managed copy: $Target"
        return "copy"
    }

    Backup-Path -Target $Target -Name $Name

    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source -ErrorAction Stop | Out-Null
        Write-Host "Linked: $Target -> $Source"
        return "link"
    } catch {
        Copy-Item -LiteralPath $Source -Destination $Target
        Write-Host "Copied (file symlink unavailable): $Target"
        return "copy"
    }
}

foreach ($Name in $Managed) {
    $Source = Join-Path $SourceDir $Name
    $Target = Join-Path $TargetDir $Name
    $ExistingMode = if ($FileModes.ContainsKey($Name)) { $FileModes[$Name] } else { $null }

    if ((Get-Item -LiteralPath $Source).PSIsContainer) {
        $FileModes[$Name] = New-ManagedDirectoryLink -Source $Source -Target $Target -Name $Name
    } else {
        $FileModes[$Name] = New-ManagedFile -Source $Source -Target $Target -Name $Name -ExistingMode $ExistingMode
    }
}

$JsonTarget = Join-Path $TargetDir "opencode.json"
$JsoncTarget = Join-Path $TargetDir "opencode.jsonc"
$JsonSource = Join-Path $SourceDir "opencode.json"

if (Is-LinkTo -Target $JsonTarget -Source $JsonSource) {
    $ConfigManaged = $true
    $FileModes["opencode.json"] = "link"
    Write-Host "Minimal config already linked."
} elseif ($ConfigManaged -and $FileModes.ContainsKey("opencode.json") -and $FileModes["opencode.json"] -eq "copy" -and (Test-Path -LiteralPath $JsonTarget)) {
    Copy-Item -LiteralPath $JsonSource -Destination $JsonTarget -Force
    Write-Host "Updated managed minimal config copy."
} elseif (-not (Test-Path -LiteralPath $JsonTarget) -and -not (Test-Path -LiteralPath $JsoncTarget)) {
    $Mode = New-ManagedFile -Source $JsonSource -Target $JsonTarget -Name "opencode.json" -ExistingMode $null
    $FileModes["opencode.json"] = $Mode
    $ConfigManaged = $true
    Write-Host "Installed minimal OpenCode config."
} else {
    if (-not $ExistingManifest) {
        $ConfigManaged = $false
    }
    Write-Host "Preserved existing OpenCode config file."
}

$Manifest = [ordered]@{
    profileDir = $ScriptDir
    backupDir = $BackupDir
    configManaged = $ConfigManaged
    fileModes = $FileModes
}

$Manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $Marker -Encoding UTF8

Write-Host ""
Write-Host "Installed portable OpenCode profile."
Write-Host "Global config: $TargetDir"
if (Test-Path -LiteralPath $BackupDir) {
    Write-Host "Backup: $BackupDir"
}
Write-Host "OpenCode itself was not modified."
