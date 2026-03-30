[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

$packagesPath = Get-ArtifactsPackagesPath
$serverPattern = "$(Get-TemplateServerPackageId)*.nupkg"
$wasmPattern = "$(Get-TemplateWasmPackageId)*.nupkg"

Invoke-Step -StepName 'Instalación manual de templates desde artifacts/packages' -Command "dotnet new install <ServerPackage.nupkg> && dotnet new install <WasmPackage.nupkg>" -Action {
    if (-not (Test-Path $packagesPath)) {
        throw "No existe la ruta de paquetes: $packagesPath"
    }

    $serverPackages = @(Get-ChildItem -Path $packagesPath -Filter $serverPattern -File)
    $wasmPackages = @(Get-ChildItem -Path $packagesPath -Filter $wasmPattern -File)

    if ($serverPackages.Count -ne 1) {
        $found = if ($serverPackages.Count -eq 0) { 'ninguno' } else { ($serverPackages.Name -join ', ') }
        throw "Se esperaba exactamente 1 paquete Server con patrón '$serverPattern' en '$packagesPath', pero se encontraron $($serverPackages.Count): $found"
    }

    if ($wasmPackages.Count -ne 1) {
        $found = if ($wasmPackages.Count -eq 0) { 'ninguno' } else { ($wasmPackages.Name -join ', ') }
        throw "Se esperaba exactamente 1 paquete Wasm con patrón '$wasmPattern' en '$packagesPath', pero se encontraron $($wasmPackages.Count): $found"
    }

    Invoke-DotNet @('new', 'install', $serverPackages[0].FullName)
    Invoke-DotNet @('new', 'install', $wasmPackages[0].FullName)
}
