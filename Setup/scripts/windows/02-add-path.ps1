[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$RootPath,
    [string]$MySqlShellBin
)

. (Join-Path $PSScriptRoot '_common.ps1')
$ErrorActionPreference = 'Stop'
$RootPath = Read-SetupDirectory 'workspace root' $RootPath 'E:\'
$relativeEntries = @(
    'Apps\Development\Toolchains\Git\cmd',
    'Apps\Development\Toolchains\CMake\bin',
    'Apps\Development\Toolchains\Node.js',
    'Apps\Development\Toolchains\NodeGlobal',
    'Apps\Development\Toolchains\Python\Scripts',
    'Apps\Development\Toolchains\Python',
    'Apps\Development\Toolchains\Go\bin',
    'Cache\go\gopath\bin'
)
$postMySqlEntries = @(
    'Apps\Development\Toolchains\msys2\ucrt64\bin',
    'Apps\Development\Editors\Neovim\bin',
    'Apps\Development\Editors\Visual_Studio_Code\bin',
    'Apps\Development\IDEs\CLion\bin'
)
$MySqlShellBin = Read-OptionalSetupDirectory 'MySQL Shell bin' $MySqlShellBin 'C:\Program Files\MySQL\MySQL Shell 8.0\bin'
$entryCandidates = @(
    $relativeEntries | ForEach-Object { Join-Path $RootPath $_ }
) + @($MySqlShellBin) + @(
    $postMySqlEntries | ForEach-Object { Join-Path $RootPath $_ }
)
$PathEntry = @($entryCandidates | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Container) })
$nodeGlobal = Join-Path $RootPath 'Apps\Development\Toolchains\NodeGlobal'
$npmCache = Join-Path $RootPath 'Cache\npm'
$npmCommand = Join-Path $RootPath 'Apps\Development\Toolchains\Node.js\npm.cmd'
$canConfigureNpm =
    (Test-Path -LiteralPath $npmCommand -PathType Leaf) -and
    (Test-Path -LiteralPath $nodeGlobal -PathType Container) -and
    (Test-Path -LiteralPath $npmCache -PathType Container)
if (-not $PathEntry) { throw "No known tool directories found under: $RootPath" }
$normalize = { param([string]$Value) $Value.Trim().TrimEnd('\') }
$npmConfigAlreadySet = $false
$prefixAlreadySet = $false
$cacheAlreadySet = $false
$globalPackages = @()
if ($canConfigureNpm) {
    $currentNpmPrefix = (& $npmCommand config get prefix).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Could not read npm prefix (exit code $LASTEXITCODE)" }
    $currentNpmCache = (& $npmCommand config get cache).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Could not read npm cache (exit code $LASTEXITCODE)" }
    $prefixAlreadySet = (& $normalize $currentNpmPrefix) -ieq (& $normalize $nodeGlobal)
    $cacheAlreadySet = (& $normalize $currentNpmCache) -ieq (& $normalize $npmCache)
    $npmConfigAlreadySet = $prefixAlreadySet -and $cacheAlreadySet
    if (-not $prefixAlreadySet) {
        $globalState = (& $npmCommand ls -g --depth=0 --json | ConvertFrom-Json)
        if ($LASTEXITCODE -ne 0) { throw "Could not inspect global npm packages (exit code $LASTEXITCODE)" }
        if ($globalState.dependencies) {
            $globalPackages = @($globalState.dependencies.PSObject.Properties.Name)
        }
    }
}
$managedPathPatterns = @(
    '[\\/]Git[\\/](cmd|bin)$',
    '[\\/]CMake[\\/]bin$',
    '[\\/]Node\.js$',
    '[\\/]Python(?:\d+(?:\.\d+)?)?(?:[\\/]Scripts)?$',
    '[\\/]Go[\\/]bin$',
    '[\\/]gopath[\\/]bin$',
    '[\\/]msys2[\\/](ucrt64|usr)[\\/]bin$',
    '[\\/]Neovim[\\/]bin$',
    '[\\/]Visual_Studio_Code[\\/]bin$',
    '[\\/]Visual Studio Code[\\/]bin$',
    '[\\/]CLion[^\\/]*[\\/]bin$',
    '[\\/]MySQL[\\/]MySQL Shell [^\\/]+[\\/]bin$'
)
if ($canConfigureNpm) {
    $managedPathPatterns += @(
        '[\\/]Node\.js[\\/]node_global$',
        '[\\/]NodeGlobal$',
        '[\\/]AppData[\\/]Roaming[\\/]npm$'
    )
}
$current = @([Environment]::GetEnvironmentVariable('Path', 'User') -split ';' | Where-Object { $_ })
$isManaged = {
    param([string]$Value)
    $normalized = & $normalize $Value
    if ($PathEntry | Where-Object { (& $normalize $_) -ieq $normalized } | Select-Object -First 1) { return $true }
    foreach ($pattern in $managedPathPatterns) {
        if ($normalized -match $pattern) { return $true }
    }
    return $false
}
$replacedEntries = @($current | Where-Object { & $isManaged $_ })
$remaining = @($current | Where-Object { -not (& $isManaged $_) })
$final = @($PathEntry + $remaining)
$finalValue = $final -join ';'
if ($finalValue.Length -gt 30000) { throw 'User PATH would exceed the 30,000-character safety limit.' }

$unchanged = $final.Count -eq $current.Count
if ($unchanged) {
    for ($i = 0; $i -lt $final.Count; $i++) {
        if ((& $normalize $final[$i]) -ine (& $normalize $current[$i])) { $unchanged = $false; break }
    }
}
if ($unchanged -and (-not $canConfigureNpm -or $npmConfigAlreadySet)) {
    Write-Host 'SDK paths and npm configuration already have the intended configuration.'
    return
}
if ($globalPackages.Count) {
    throw "Global npm packages exist under ${currentNpmPrefix}: $($globalPackages -join ', '). Remove or migrate them before changing npm prefix."
}

$plan = @(
    "Workspace root: $RootPath",
    'Target: User PATH only',
    'Placement: before existing User PATH entries'
) + $PathEntry
if ($replacedEntries.Count) {
    $plan += 'Replaced existing User PATH entries:'
    $plan += $replacedEntries | ForEach-Object { "  $_" }
}
if ($canConfigureNpm) {
    if ($npmConfigAlreadySet) {
        $plan += "npm global prefix: unchanged ($nodeGlobal)"
        $plan += "npm cache: unchanged ($npmCache)"
    } else {
        if ($prefixAlreadySet) {
            $plan += "npm global prefix: unchanged ($nodeGlobal)"
        } else {
            $plan += "npm global prefix: $currentNpmPrefix -> $nodeGlobal"
        }
        if ($cacheAlreadySet) {
            $plan += "npm cache: unchanged ($npmCache)"
        } else {
            $plan += "npm cache: $currentNpmCache -> $npmCache"
        }
    }
} else {
    $plan += 'npm configuration: skipped (run storage layout and install Node.js first)'
}
if (-not (Confirm-SetupAction -Title 'Prioritize SDK paths' -Plan $plan)) { return }

if ($canConfigureNpm) {
    & $npmCommand config set prefix $nodeGlobal --location=user
    if ($LASTEXITCODE -ne 0) { throw "npm prefix configuration failed with exit code $LASTEXITCODE" }
    & $npmCommand config set cache $npmCache --location=user
    if ($LASTEXITCODE -ne 0) { throw "npm cache configuration failed with exit code $LASTEXITCODE" }
}
[Environment]::SetEnvironmentVariable('Path', $finalValue, 'User')
Write-Host 'Updated User PATH. Open a new PowerShell window.'
