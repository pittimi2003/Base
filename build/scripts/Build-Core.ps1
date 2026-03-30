[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

. (Join-Path $PSScriptRoot 'Common.ps1')

$coreProjectPath = Get-CoreProjectPath

Invoke-Step -StepName 'Build de Core' -Command "dotnet build $coreProjectPath -c $Configuration --no-restore" -Action {
    Invoke-DotNet @('build', $coreProjectPath, '-c', $Configuration, '--no-restore')
}
