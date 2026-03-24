[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

& (Join-Path $scriptRoot 'Restore-Build.ps1') -Configuration $Configuration
& (Join-Path $scriptRoot 'Pack-Core.ps1') -Configuration $Configuration
& (Join-Path $scriptRoot 'Pack-TemplateServer.ps1') -Configuration $Configuration
& (Join-Path $scriptRoot 'Pack-TemplateWasm.ps1') -Configuration $Configuration
