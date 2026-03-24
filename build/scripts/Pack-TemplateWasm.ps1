[CmdletBinding()]
param(
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..' '..')
$projectPath = Join-Path $repoRoot 'src/MachSoft.Template.Official.Wasm/MachSoft.Template.Official.Wasm.csproj'
$outputPath = Join-Path $repoRoot 'artifacts/packages'

New-Item -ItemType Directory -Force -Path $outputPath | Out-Null

Write-Host "Packing MachSoft.Template.Official.Wasm" -ForegroundColor Cyan
dotnet pack $projectPath -c $Configuration --output $outputPath
