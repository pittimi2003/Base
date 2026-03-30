[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

. (Join-Path $PSScriptRoot 'Common.ps1')

$controlProjectPath = Get-ControlProjectPath

Invoke-Step -StepName 'Build de Control' -Command "dotnet build $controlProjectPath -c $Configuration --no-restore" -Action {
    Invoke-DotNet @('build', $controlProjectPath, '-c', $Configuration, '--no-restore')
}
