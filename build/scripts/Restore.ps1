[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

$solutionPath = Get-SolutionPath

Invoke-Step -StepName 'Restore' -Command "dotnet restore $solutionPath" -Action {
    Invoke-DotNet @('restore', $solutionPath)
}
