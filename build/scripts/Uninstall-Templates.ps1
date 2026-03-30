[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

$serverPackageId = Get-TemplateServerPackageId
$wasmPackageId = Get-TemplateWasmPackageId

Invoke-Step -StepName 'Desinstalación de templates instalados' -Command "dotnet new uninstall $serverPackageId && dotnet new uninstall $wasmPackageId" -Action {
    $installedOutput = & dotnet new uninstall 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet new uninstall (list) failed with exit code $LASTEXITCODE`n$installedOutput"
    }

    if ($installedOutput -match [Regex]::Escape($serverPackageId)) {
        Invoke-DotNet @('new', 'uninstall', $serverPackageId)
    }
    else {
        Write-Host "Template no instalado, se omite: $serverPackageId" -ForegroundColor Yellow
    }

    if ($installedOutput -match [Regex]::Escape($wasmPackageId)) {
        Invoke-DotNet @('new', 'uninstall', $wasmPackageId)
    }
    else {
        Write-Host "Template no instalado, se omite: $wasmPackageId" -ForegroundColor Yellow
    }
}
