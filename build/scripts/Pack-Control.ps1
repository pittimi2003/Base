[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

. (Join-Path $PSScriptRoot 'Common.ps1')

$projectPath = Get-ControlProjectPath
$outputPath = Get-ArtifactsPackagesPath

Invoke-Step -StepName 'Pack de Control' -Command "dotnet pack $projectPath -c $Configuration --no-build --output $outputPath" -Action {
    New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
    Invoke-DotNet @('pack', $projectPath, '-c', $Configuration, '--no-build', '--output', $outputPath)
}
