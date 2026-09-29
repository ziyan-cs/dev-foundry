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
    while ($true) {
        $answer = Read-Host 'Continue? Type yes / y'
        if ($answer -cin @('yes', 'Yes', 'YES', 'y', 'Y')) { return $true }
        Write-Host 'Confirmation not accepted. Enter yes / Yes / YES / y / Y.' -ForegroundColor Yellow
    }
}

function Get-SetupManifest {
    param([Parameter(Mandatory)][string]$Path)

    Get-Content -LiteralPath $Path -Encoding UTF8 |
        Where-Object { $_ -and -not $_.Trim().StartsWith('#') }
}

function Read-SetupDirectory {
    param(
        [Parameter(Mandatory)][string]$Label,
        [string]$Value,
        [string]$Example
    )

    while ($true) {
        if (-not $Value) {
            $prompt = "Paste $Label path"
            if ($Example) { $prompt += " (example: $Example)" }
            $Value = Read-Host $prompt
        }
        $Value = $Value.Trim().Trim('"')
        if (Test-Path -LiteralPath $Value -PathType Container) {
            return (Resolve-Path -LiteralPath $Value).Path
        }
        Write-Host "Directory not found: $Value" -ForegroundColor Yellow
        $Value = $null
    }
}

function Read-OptionalSetupDirectory {
    param(
        [Parameter(Mandatory)][string]$Label,
        [string]$Value,
        [string]$Example
    )

    while ($true) {
        if ($null -eq $Value) {
            $prompt = "Paste $Label path, or press Enter to skip"
            if ($Example) { $prompt += " (example: $Example)" }
            $Value = Read-Host $prompt
        }
        $Value = $Value.Trim().Trim('"')
        if (-not $Value) { return $null }
        if (Test-Path -LiteralPath $Value -PathType Container) {
            return (Resolve-Path -LiteralPath $Value).Path
        }
        Write-Host "Directory not found: $Value" -ForegroundColor Yellow
        $Value = $null
    }
}
