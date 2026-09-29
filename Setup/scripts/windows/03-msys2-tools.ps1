[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$MsysRoot
)

. (Join-Path $PSScriptRoot '_common.ps1')
$ErrorActionPreference = 'Stop'
$MsysRoot = Read-SetupDirectory 'MSYS2 root' $MsysRoot 'E:\Apps\Development\Toolchains\msys2'
$bash = Join-Path $MsysRoot 'usr\bin\bash.exe'
if (-not (Test-Path -LiteralPath $bash)) { throw "MSYS2 bash not found: $bash" }
$mirrorBase = 'https://mirrors.tuna.tsinghua.edu.cn/msys2'
$mirrorFiles = @(
    @{ Path = Join-Path $MsysRoot 'etc\pacman.d\mirrorlist.mingw'; Server = "$mirrorBase/mingw/`$repo/" },
    @{ Path = Join-Path $MsysRoot 'etc\pacman.d\mirrorlist.msys'; Server = "$mirrorBase/msys/`$arch/" }
)
$manifest = Join-Path $PSScriptRoot '..\..\manifests\msys2-ucrt64-packages.txt'
$packages = @(Get-SetupManifest $manifest)
$plan = @("MSYS2 root: $MsysRoot", "Mirror: $mirrorBase") + $packages
if (-not (Confirm-SetupAction 'MSYS2 UCRT64 packages' $plan)) { return }

foreach ($mirror in $mirrorFiles) {
    if (-not (Test-Path -LiteralPath $mirror.Path -PathType Leaf)) { throw "MSYS2 mirror list not found: $($mirror.Path)" }
    $lines = [System.IO.File]::ReadAllLines($mirror.Path, [System.Text.Encoding]::UTF8)
    $index = [Array]::FindIndex($lines, [Predicate[string]] { param($line) $line -match '^\s*Server\s*=' })
    if ($index -lt 0) { throw "No Server entry found: $($mirror.Path)" }
    $lines[$index] = "Server = $($mirror.Server)"
    [System.IO.File]::WriteAllLines($mirror.Path, $lines, (New-Object System.Text.UTF8Encoding($false)))
    if (([System.IO.File]::ReadAllLines($mirror.Path, [System.Text.Encoding]::UTF8)[$index]) -ne "Server = $($mirror.Server)") {
        throw "MSYS2 mirror update verification failed: $($mirror.Path)"
    }
}

& $bash -lc "pacman -S --needed $($packages -join ' ')"
if ($LASTEXITCODE) { throw "pacman failed with exit code $LASTEXITCODE" }
