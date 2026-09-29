[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$GoBinPath,
    [string]$GoPath,
    [string]$GoCache
)

. (Join-Path $PSScriptRoot '_common.ps1')
$ErrorActionPreference = 'Stop'
$GoBinPath = Read-SetupDirectory 'Go bin' $GoBinPath 'E:\Apps\Development\Toolchains\Go\bin'
$goCommand = Join-Path $GoBinPath 'go.exe'
if (-not (Test-Path -LiteralPath $goCommand -PathType Leaf)) { throw "Go executable not found: $goCommand" }
$GoPath = Read-SetupDirectory 'GOPATH directory' $GoPath 'E:\Cache\go\gopath'
$GoCache = Read-SetupDirectory 'GOCACHE directory' $GoCache 'E:\Cache\go\build'
$manifest = Join-Path $PSScriptRoot '..\..\manifests\go-tools.txt'
$tools = @(Get-SetupManifest $manifest)
if (-not (Confirm-SetupAction -Title 'Go tools' -Plan (@("GOPATH: $goPath", "GOCACHE: $goCache") + $tools))) { return }

New-Item -ItemType Directory -Force -Path $goPath, $goCache | Out-Null
& $goCommand env -w "GOPATH=$goPath"
if ($LASTEXITCODE) { throw "Could not set GOPATH (exit code $LASTEXITCODE)" }
& $goCommand env -w "GOCACHE=$goCache"
if ($LASTEXITCODE) { throw "Could not set GOCACHE (exit code $LASTEXITCODE)" }
$tools | ForEach-Object {
    & $goCommand install $_
    if ($LASTEXITCODE) { throw "go install failed: $_ (exit code $LASTEXITCODE)" }
}
