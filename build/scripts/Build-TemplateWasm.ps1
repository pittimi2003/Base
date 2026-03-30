[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

. (Join-Path $PSScriptRoot 'Common.ps1')

$projectPath = Get-TemplateWasmProjectPath

Invoke-Step -StepName 'Build de Template Wasm' -Command "dotnet build $projectPath -c $Configuration --no-restore" -Action {
    Invoke-DotNet @('build', $projectPath, '-c', $Configuration, '--no-restore')
}
