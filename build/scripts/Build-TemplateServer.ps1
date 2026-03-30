[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

. (Join-Path $PSScriptRoot 'Common.ps1')

$projectPath = Get-TemplateServerProjectPath

Invoke-Step -StepName 'Build de Template Server' -Command "dotnet build $projectPath -c $Configuration --no-restore" -Action {
    Invoke-DotNet @('build', $projectPath, '-c', $Configuration, '--no-restore')
}
