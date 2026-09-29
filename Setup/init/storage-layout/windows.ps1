[CmdletBinding(SupportsShouldProcess)]
param([string]$RootPath)

$ErrorActionPreference = 'Stop'
while ($true) {
    if (-not $RootPath) { $RootPath = Read-Host 'Paste storage root path (for example: E:\)' }
    $RootPath = $RootPath.Trim().Trim('"')
    if (Test-Path -LiteralPath $RootPath -PathType Container) { break }
    Write-Host "Directory not found: $RootPath" -ForegroundColor Yellow
    $RootPath = $null
}
$RootPath = (Resolve-Path -LiteralPath $RootPath).Path
$manifest = Join-Path $PSScriptRoot 'layout.txt'
$missing = @(
    Get-Content -LiteralPath $manifest -Encoding UTF8 |
        Where-Object { $_ -and -not $_.Trim().StartsWith('#') } |
        ForEach-Object { Join-Path $RootPath ($_ -replace '/', '\') } |
        Where-Object { -not (Test-Path -LiteralPath $_ -PathType Container) }
)

if (-not $missing) { Write-Host 'All layout directories already exist.'; return }
Write-Host "`nStorage layout" -ForegroundColor Cyan
Write-Host "  Selected root: $RootPath"
Write-Host "  Will create: $($missing.Count) directories"
$missing | ForEach-Object { Write-Host "  - $_" }
if ($WhatIfPreference) { Write-Host 'WhatIf: no changes made.' -ForegroundColor Yellow; return }
if ((Read-Host 'Create these directories? Type yes') -cne 'yes') { Write-Host 'Cancelled. No directories were created.'; return }

$missing | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
Write-Host "Created $($missing.Count) directories."
