[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'Clean-NuGet.ps1')
& (Join-Path $PSScriptRoot 'Clean-TemplatesLocal.ps1')
& (Join-Path $PSScriptRoot 'Uninstall-Templates.ps1')
& (Join-Path $PSScriptRoot 'Reset-ArtifactsPackages.ps1')
& (Join-Path $PSScriptRoot 'Restore.ps1')
& (Join-Path $PSScriptRoot 'Build-Core.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Build-Control.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Build-TemplateServer.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Build-TemplateWasm.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Pack-Core.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Pack-Control.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Pack-TemplateServer.ps1') -Configuration $Configuration
& (Join-Path $PSScriptRoot 'Pack-TemplateWasm.ps1') -Configuration $Configuration
