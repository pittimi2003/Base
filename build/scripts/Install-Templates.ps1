[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

$packagesPath = Get-ArtifactsPackagesPath
$serverPattern = "$(Get-TemplateServerPackageId).*nupkg"
$wasmPattern = "$(Get-TemplateWasmPackageId).*nupkg"

Invoke-Step -StepName 'Instalación manual de templates desde artifacts/packages' -Command "dotnet new install <ServerPackage.nupkg> && dotnet new install <WasmPackage.nupkg>" -Action {
    if (-not (Test-Path $packagesPath)) {
        throw "No existe la ruta de paquetes: $packagesPath"
    }

    $serverPackage = Get-ChildItem -Path $packagesPath -Filter $serverPattern | Sort-Object Name -Descending | Select-Object -First 1
    $wasmPackage = Get-ChildItem -Path $packagesPath -Filter $wasmPattern | Sort-Object Name -Descending | Select-Object -First 1

    if (-not $serverPackage) {
        throw "No se encontró paquete para template Server con patrón: $serverPattern"
    }

    if (-not $wasmPackage) {
        throw "No se encontró paquete para template Wasm con patrón: $wasmPattern"
    }

    Invoke-DotNet @('new', 'install', $serverPackage.FullName)
    Invoke-DotNet @('new', 'install', $wasmPackage.FullName)
}
