[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'Restore-Build.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Pack-Core.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Pack-Control.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Pack-TemplateServer.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Pack-TemplateWasm.ps1') -Configuration $Configuration
