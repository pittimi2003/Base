[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..' '..')
$projectPath = Join-Path $repoRoot 'src/MachSoft.Template.Official.Server/MachSoft.Template.Official.Server.csproj'
$outputPath = Join-Path $repoRoot 'artifacts/packages'

New-Item -ItemType Directory -Force -Path $outputPath | Out-Null

Write-Host "Packing MachSoft.Template.Official.Server" -ForegroundColor Cyan
dotnet pack $projectPath -c $Configuration --output $outputPath
