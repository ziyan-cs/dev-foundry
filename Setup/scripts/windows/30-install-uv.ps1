[CmdletBinding(SupportsShouldProcess)]
param()

. (Join-Path $PSScriptRoot '_common.ps1')
if (Get-Command uv -ErrorAction SilentlyContinue) { Write-Host 'uv is already available.'; return }
if (-not (Confirm-SetupAction 'uv' @('Download and run Astral''s official Windows installer.'))) { return }

Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
