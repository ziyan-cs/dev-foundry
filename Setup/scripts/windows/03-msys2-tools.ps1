[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$MsysRoot
)

. (Join-Path $PSScriptRoot '_common.ps1')
$ErrorActionPreference = 'Stop'
$MsysRoot = Read-SetupDirectory 'MSYS2 root' $MsysRoot 'E:\Apps\Development\Toolchains\msys2'
$bash = Join-Path $MsysRoot 'usr\bin\bash.exe'
if (-not (Test-Path -LiteralPath $bash)) { throw "MSYS2 bash not found: $bash" }
$manifest = Join-Path $PSScriptRoot '..\..\manifests\msys2-ucrt64-packages.txt'
$packages = @(Get-SetupManifest $manifest)
if (-not (Confirm-SetupAction 'MSYS2 UCRT64 packages' (@("MSYS2 root: $MsysRoot") + $packages))) { return }

& $bash -lc "pacman -S --needed $($packages -join ' ')"
if ($LASTEXITCODE) { throw "pacman failed with exit code $LASTEXITCODE" }
