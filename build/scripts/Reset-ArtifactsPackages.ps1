[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

$packagesPath = Get-ArtifactsPackagesPath

Invoke-Step -StepName 'Recreación de artifacts/packages' -Command "Remove-Item '$packagesPath' -Recurse -Force; New-Item -ItemType Directory -Path '$packagesPath'" -Action {
    if (Test-Path $packagesPath) {
        Remove-Item -Recurse -Force $packagesPath
    }

    New-Item -ItemType Directory -Path $packagesPath | Out-Null
}
