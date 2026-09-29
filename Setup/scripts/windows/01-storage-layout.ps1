[CmdletBinding(SupportsShouldProcess)]
param([string]$RootPath)

. (Join-Path $PSScriptRoot '_common.ps1')
$ErrorActionPreference = 'Stop'
$RootPath = Read-SetupDirectory 'workspace root' $RootPath 'E:\'
$manifest = Join-Path $PSScriptRoot '..\..\init\storage-layout\layout.txt'
$missing = @(
    Get-SetupManifest $manifest |
        ForEach-Object { Join-Path $RootPath ($_ -replace '/', '\') } |
        Where-Object { -not (Test-Path -LiteralPath $_ -PathType Container) }
)

if (-not $missing) { Write-Host 'All layout directories already exist.'; return }
$plan = @("Workspace root: $RootPath", "Will create: $($missing.Count) directories") + $missing
if (-not (Confirm-SetupAction -Title 'Create storage layout' -Plan $plan)) { return }

$missing | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
Write-Host "Created $($missing.Count) directories."
