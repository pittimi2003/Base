. (Join-Path $PSScriptRoot 'Common.ps1')

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$source = 'https://machsoftprivatenuget-adfkctf7h5bddhaa.mexicocentral-01.azurewebsites.net/v3/index.json'
$apiKey = '__RSCM200385_8a__'
$packagesPath = Get-ArtifactsPackagesPath

function Get-ExactlyOnePackage {
    param(
        [Parameter(Mandatory = $true)][string]$PackagesPath,
        [Parameter(Mandatory = $true)][string]$PackageId,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $pattern = '^' + [Regex]::Escape($PackageId) + '\.(\d.+)\.nupkg$'

    $matches = @(
        Get-ChildItem -Path $PackagesPath -File |
        Where-Object {
            $_.Name -imatch $pattern -and
            $_.Name -inotmatch '\.snupkg$'
        }
    )

    if ($matches.Count -eq 0) {
        throw "No se encontró ningún paquete para $Label en '$PackagesPath' con PackageId '$PackageId'."
    }

    if ($matches.Count -ne 1) {
        $found = ($matches | ForEach-Object { $_.FullName }) -join [Environment]::NewLine
        throw "Se esperaba exactamente 1 paquete para $Label, pero se encontraron $($matches.Count):`n$found"
    }

    return $matches[0]
}

function Get-PackageMetadata {
    param(
        [Parameter(Mandatory = $true)][System.IO.FileInfo]$File,
        [Parameter(Mandatory = $true)][string]$PackageId
    )

    $escapedId = [Regex]::Escape($PackageId)
    $pattern = "^$escapedId\.(?<Version>\d.+)\.nupkg$"

    if ($File.Name -notmatch $pattern) {
        throw "No se pudo extraer la versión de '$($File.Name)' para el PackageId '$PackageId'."
    }

    return [PSCustomObject]@{
        PackageId = $PackageId
        Version   = $Matches['Version']
        Path      = $File.FullName
        FileName  = $File.Name
    }
}

function Remove-PackageFromFeed {
    param(
        [Parameter(Mandatory = $true)][string]$PackageId,
        [Parameter(Mandatory = $true)][string]$Version
    )

    Invoke-Step -StepName "Eliminar $PackageId $Version del feed" `
        -Command "dotnet nuget delete $PackageId $Version --source $source --api-key ******** --non-interactive" `
        -Action {
            & dotnet nuget delete $PackageId $Version `
                --source $source `
                --api-key $apiKey `
                --non-interactive

            if ($LASTEXITCODE -ne 0) {
                throw "dotnet nuget delete $PackageId $Version failed with exit code $LASTEXITCODE"
            }
        }
}

function Push-PackageToFeed {
    param(
        [Parameter(Mandatory = $true)][string]$PackagePath
    )

    Invoke-Step -StepName "Publicar $(Split-Path $PackagePath -Leaf) en el feed" `
        -Command "dotnet nuget push $PackagePath --source $source --api-key ******** --skip-duplicate" `
        -Action {
            & dotnet nuget push $PackagePath `
                --source $source `
                --api-key $apiKey `
                --skip-duplicate

            if ($LASTEXITCODE -ne 0) {
                throw "dotnet nuget push $PackagePath failed with exit code $LASTEXITCODE"
            }
        }
}

Invoke-Step -StepName 'Validación de artifacts/packages' `
    -Command "Verificar paquetes en $packagesPath" `
    -Action {
        if (-not (Test-Path $packagesPath)) {
            throw "La carpeta '$packagesPath' no existe."
        }
    }

$corePackageFile = Get-ExactlyOnePackage -PackagesPath $packagesPath -PackageId 'MachSoft.Template.Core' -Label 'Core'
$controlPackageFile = Get-ExactlyOnePackage -PackagesPath $packagesPath -PackageId 'MachSoft.Template.Core.Control' -Label 'Control'
$serverPackageFile = Get-ExactlyOnePackage -PackagesPath $packagesPath -PackageId 'MachSoft.Template.Official.Server' -Label 'Server'
$wasmPackageFile = Get-ExactlyOnePackage -PackagesPath $packagesPath -PackageId 'MachSoft.Template.Official.Wasm' -Label 'Wasm'

$corePackage = Get-PackageMetadata -File $corePackageFile -PackageId 'MachSoft.Template.Core'
$controlPackage = Get-PackageMetadata -File $controlPackageFile -PackageId 'MachSoft.Template.Core.Control'
$serverPackage = Get-PackageMetadata -File $serverPackageFile -PackageId 'MachSoft.Template.Official.Server'
$wasmPackage = Get-PackageMetadata -File $wasmPackageFile -PackageId 'MachSoft.Template.Official.Wasm'

Write-Host 'Paquetes detectados para reinstalación en el feed:' -ForegroundColor Green
Write-Host "  $($corePackage.Path)"
Write-Host "  $($controlPackage.Path)"
Write-Host "  $($serverPackage.Path)"
Write-Host "  $($wasmPackage.Path)"

Remove-PackageFromFeed -PackageId $corePackage.PackageId -Version $corePackage.Version
Remove-PackageFromFeed -PackageId $controlPackage.PackageId -Version $controlPackage.Version
Remove-PackageFromFeed -PackageId $serverPackage.PackageId -Version $serverPackage.Version
Remove-PackageFromFeed -PackageId $wasmPackage.PackageId -Version $wasmPackage.Version

Push-PackageToFeed -PackagePath $corePackage.Path
Push-PackageToFeed -PackagePath $controlPackage.Path
Push-PackageToFeed -PackagePath $serverPackage.Path
Push-PackageToFeed -PackagePath $wasmPackage.Path