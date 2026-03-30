[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'Restore.ps1')
& (Join-Path $PSScriptRoot 'Build-Core.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Build-Control.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Build-TemplateServer.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Build-TemplateWasm.ps1') -Configuration $Configuration
