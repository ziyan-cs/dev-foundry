[CmdletBinding(SupportsShouldProcess)]
param()

. (Join-Path $PSScriptRoot '_common.ps1')
if (-not (Get-Command code -ErrorAction SilentlyContinue)) { throw 'VS Code CLI (code) is not on PATH.' }
$manifest = Join-Path $PSScriptRoot '..\..\manifests\vscode-extensions.txt'
$extensions = @(Get-SetupManifest $manifest)
if (-not (Confirm-SetupAction 'VS Code extensions' $extensions)) { return }

$extensions | ForEach-Object { code --install-extension $_ --force }
