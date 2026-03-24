[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..' '..')
$solutionPath = Join-Path $repoRoot 'MachSoft.Templates.sln'

Write-Host "Restoring $solutionPath" -ForegroundColor Cyan
dotnet restore $solutionPath

Write-Host "Building $solutionPath ($Configuration)" -ForegroundColor Cyan
dotnet build $solutionPath -c $Configuration --no-restore
