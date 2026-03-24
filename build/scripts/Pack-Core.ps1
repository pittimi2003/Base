[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..' '..')
$projectPath = Join-Path $repoRoot 'src/MachSoft.Template.Core/MachSoft.Template.Core.csproj'
$outputPath = Join-Path $repoRoot 'artifacts/packages'
$localFeedPath = Join-Path $repoRoot 'artifacts/feed/local'

New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
New-Item -ItemType Directory -Force -Path $localFeedPath | Out-Null

Write-Host "Packing MachSoft.Template.Core" -ForegroundColor Cyan
dotnet pack $projectPath -c $Configuration --output $outputPath
Copy-Item (Join-Path $outputPath 'MachSoft.Template.Core*.nupkg') -Destination $localFeedPath -Force
