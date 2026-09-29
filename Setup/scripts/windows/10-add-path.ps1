[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$SDK_PATH
)

. (Join-Path $PSScriptRoot '_common.ps1')
$SDK_PATH = Read-SetupDirectory 'SDK root' $SDK_PATH
$relativeEntries = @(
    'Git\cmd', 'CMake\bin', 'Node.js', 'Python', 'Python\Scripts', 'Go\bin',
    'GoPath\bin', 'msys2\ucrt64\bin', 'msys2\usr\bin'
)
$npmUserBin = Join-Path $env:APPDATA 'npm'
$PathEntry = @(
    foreach ($relative in $relativeEntries) {
        $entry = Join-Path $SDK_PATH $relative
        if (Test-Path -LiteralPath $entry -PathType Container) { $entry }
        if ($relative -eq 'Node.js\node_global' -and (Test-Path -LiteralPath $npmUserBin -PathType Container)) {
            $npmUserBin
        }
    }
)
if (-not $PathEntry) { throw "No known tool directories found under: $SDK_PATH" }
$current = @([Environment]::GetEnvironmentVariable('Path', 'User') -split ';' | Where-Object { $_ })
$normalize = { param([string]$Value) $Value.Trim().TrimEnd('\') }
$isManaged = {
    param([string]$Value)
    $normalized = & $normalize $Value
    $PathEntry | Where-Object { (& $normalize $_) -ieq $normalized } | Select-Object -First 1
}
$remaining = @($current | Where-Object { -not (& $isManaged $_) })
$final = @($PathEntry + $remaining)

$unchanged = $final.Count -eq $current.Count
if ($unchanged) {
    for ($i = 0; $i -lt $final.Count; $i++) {
        if ((& $normalize $final[$i]) -ine (& $normalize $current[$i])) { $unchanged = $false; break }
    }
}
if ($unchanged) { Write-Host 'SDK paths already have the intended user PATH priority.'; return }

$plan = @(
    "SDK root: $SDK_PATH",
    'Target: User PATH only',
    'Placement: before existing User PATH entries'
) + $PathEntry
if (-not (Confirm-SetupAction -Title 'Prioritize SDK paths' -Plan $plan)) { return }

[Environment]::SetEnvironmentVariable('Path', ($final -join ';'), 'User')
Write-Host 'Updated User PATH. Open a new PowerShell window.'
