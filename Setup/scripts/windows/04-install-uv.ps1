[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$UvInstallDir
)

. (Join-Path $PSScriptRoot '_common.ps1')
$ErrorActionPreference = 'Stop'
while ($true) {
    if (-not $UvInstallDir) {
        $UvInstallDir = Read-Host 'Paste uv installation directory (example: E:\Apps\Development\Tools\uv)'
    }
    $UvInstallDir = $UvInstallDir.Trim().Trim('"')
    $parent = Split-Path -Parent $UvInstallDir
    if (Test-Path -LiteralPath $UvInstallDir -PathType Container) {
        $UvInstallDir = (Resolve-Path -LiteralPath $UvInstallDir).Path
        break
    }
    if ($parent -and (Test-Path -LiteralPath $parent -PathType Container)) {
        $UvInstallDir = [IO.Path]::GetFullPath($UvInstallDir)
        break
    }
    Write-Host "Directory and parent were not found: $UvInstallDir" -ForegroundColor Yellow
    $UvInstallDir = $null
}
$uvExe = Join-Path $UvInstallDir 'uv.exe'
if (Test-Path -LiteralPath $uvExe -PathType Leaf) {
    Write-Host "uv is already installed: $uvExe"
    return
}
$plan = @(
    "Install directory: $UvInstallDir",
    'Create installation directory if absent',
    'PATH: managed by 02-add-path.ps1',
    'Installer profile/PATH changes: disabled'
)
if (-not (Confirm-SetupAction 'Install uv' $plan)) { return }

New-Item -ItemType Directory -Force -Path $UvInstallDir | Out-Null
$env:UV_INSTALL_DIR = $UvInstallDir
$env:UV_NO_MODIFY_PATH = '1'
Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
if (-not (Test-Path -LiteralPath $uvExe -PathType Leaf)) {
    throw "uv installer finished, but uv.exe was not found: $uvExe"
}
Write-Host "Installed uv: $uvExe"
