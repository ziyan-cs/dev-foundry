[CmdletBinding(SupportsShouldProcess)]
param([string]$SDK_PATH)

. (Join-Path $PSScriptRoot '_common.ps1')
if (-not (Get-Command go -ErrorAction SilentlyContinue)) { throw 'go is not on PATH.' }
$SDK_PATH = Read-SetupDirectory 'SDK root' $SDK_PATH
$goPath = Join-Path $SDK_PATH 'GoPath'
$goCache = Join-Path $SDK_PATH 'GoBuild'
$manifest = Join-Path $PSScriptRoot '..\..\manifests\go-tools.txt'
$tools = @(Get-SetupManifest $manifest)
if (-not (Confirm-SetupAction -Title 'Go tools' -Plan (@("GOPATH: $goPath", "GOCACHE: $goCache") + $tools))) { return }

New-Item -ItemType Directory -Force -Path $goPath, $goCache | Out-Null
go env -w "GOPATH=$goPath"
go env -w "GOCACHE=$goCache"
$tools | ForEach-Object { go install $_ }
