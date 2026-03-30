[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'Rebuild-LocalEnvironment.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Install-Templates.ps1')
