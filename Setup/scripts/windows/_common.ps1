function Confirm-SetupAction {
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][string[]]$Plan
    )

    Write-Host "`n$Title" -ForegroundColor Cyan
    $Plan | ForEach-Object { Write-Host "  - $_" }
    if ($WhatIfPreference) {
        Write-Host 'WhatIf: no changes made.' -ForegroundColor Yellow
        return $false
    }
    return (Read-Host 'Continue? Type yes') -ceq 'yes'
}

function Get-SetupManifest {
    param([Parameter(Mandatory)][string]$Path)

    Get-Content -LiteralPath $Path -Encoding UTF8 |
        Where-Object { $_ -and -not $_.Trim().StartsWith('#') }
}

function Read-SetupDirectory {
    param(
        [Parameter(Mandatory)][string]$Label,
        [string]$Value
    )

    if (-not $Value) { $Value = Read-Host "Paste $Label path" }
    $Value = $Value.Trim().Trim('"')
    if (-not (Test-Path -LiteralPath $Value -PathType Container)) {
        throw "Directory not found: $Value"
    }
    return (Resolve-Path -LiteralPath $Value).Path
}
