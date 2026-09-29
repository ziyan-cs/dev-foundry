[CmdletBinding(SupportsShouldProcess)]
param([string]$VSCodeRoot)

. (Join-Path $PSScriptRoot '_common.ps1')
$ErrorActionPreference = 'Stop'
$VSCodeRoot = Read-SetupDirectory 'VS Code installation root' $VSCodeRoot 'E:\Apps\Development\Editors\VS_Code'
$codeCommand = Join-Path $VSCodeRoot 'bin\code.cmd'
if (-not (Test-Path -LiteralPath $codeCommand -PathType Leaf)) { throw "VS Code CLI not found: $codeCommand" }
$manifest = Join-Path $PSScriptRoot '..\..\manifests\vscode-extensions.txt'
$extensions = @(Get-SetupManifest $manifest)
if (-not (Confirm-SetupAction 'VS Code extensions' $extensions)) { return }

$extensions | ForEach-Object {
    & $codeCommand --install-extension $_ --force
    if ($LASTEXITCODE) { throw "VS Code extension install failed: $_ (exit code $LASTEXITCODE)" }
}
