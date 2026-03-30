Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
    return Resolve-Path (Join-Path $PSScriptRoot '..' '..')
}

function Get-SolutionPath {
    return Join-Path (Get-RepoRoot) 'MachSoft.Templates.sln'
}

function Get-ArtifactsPackagesPath {
    return Join-Path (Get-RepoRoot) 'artifacts/packages'
}

function Get-CoreProjectPath {
    return Join-Path (Get-RepoRoot) 'src/MachSoft.Template.Core/MachSoft.Template.Core.csproj'
}

function Get-ControlProjectPath {
    return Join-Path (Get-RepoRoot) 'src/MachSoft.Template.Core.Control/MachSoft.Template.Core.Control.csproj'
}

function Get-TemplateServerProjectPath {
    return Join-Path (Get-RepoRoot) 'src/MachSoft.Template.Official.Server/MachSoft.Template.Official.Server.csproj'
}

function Get-TemplateWasmProjectPath {
    return Join-Path (Get-RepoRoot) 'src/MachSoft.Template.Official.Wasm/MachSoft.Template.Official.Wasm.csproj'
}

function Get-TemplateServerPackageId {
    return 'MachSoft.Template.Official.Server'
}

function Get-TemplateWasmPackageId {
    return 'MachSoft.Template.Official.Wasm'
}

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)][string]$StepName,
        [Parameter(Mandatory = $true)][string]$Command,
        [Parameter(Mandatory = $true)][scriptblock]$Action
    )

    Write-Host "==> $StepName" -ForegroundColor Cyan
    Write-Host "CMD: $Command" -ForegroundColor DarkCyan

    try {
        & $Action
    }
    catch {
        Write-Host "ERROR in step: $StepName" -ForegroundColor Red
        Write-Host "Command: $Command" -ForegroundColor Red
        Write-Host "Exception:" -ForegroundColor Red
        Write-Host $_.Exception.ToString() -ForegroundColor Red
        throw
    }
}

function Invoke-DotNet {
    param(
        [Parameter(Mandatory = $true)][string[]]$Arguments
    )

    & dotnet @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
    }
}
