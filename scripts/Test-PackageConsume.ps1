[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$FeedName,
    [Parameter(Mandatory = $true)][string]$FeedUrl,
    [Parameter(Mandatory = $true)][string]$PackageId,
    [Parameter(Mandatory = $true)][string]$PackageVersion,
    [Parameter(Mandatory = $true)][string]$WorkingDirectory,
    [Parameter(Mandatory = $true)][string]$LogDirectory,
    [Parameter(Mandatory = $true)][string]$DotNetPath,
    [Parameter(Mandatory = $true)][string]$NuGetExePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-LoggedCommand {
    param(
        [string]$FilePath,
        [string[]]$ArgumentList,
        [string]$LogPath,
        [string]$DisplayName = $FilePath,
        [string]$WorkingDirectory = $PWD.Path
    )

    $currentLocation = Get-Location
    try {
        Set-Location -LiteralPath $WorkingDirectory
        $output = & $FilePath @ArgumentList 2>&1
        $output | Tee-Object -FilePath $LogPath | Out-Null
        return [pscustomobject]@{
            ExitCode = $LASTEXITCODE
            Output = @($output)
            CommandLine = "$DisplayName $($ArgumentList -join ' ')"
            LogPath = $LogPath
        }
    }
    finally {
        Set-Location -LiteralPath $currentLocation
    }
}

New-Item -ItemType Directory -Path $WorkingDirectory, $LogDirectory -Force | Out-Null
$consumerDirectory = Join-Path $WorkingDirectory 'validation-consumer'
New-Item -ItemType Directory -Path $consumerDirectory -Force | Out-Null

$projectName = 'MachSoftPrivateValidationConsumer'
$createLog = Join-Path $LogDirectory 'consume-create-project.log'
$createResult = Invoke-LoggedCommand -FilePath $DotNetPath -ArgumentList @('new', 'console', '--framework', 'net8.0', '--name', $projectName, '--force', '--output', $consumerDirectory) -LogPath $createLog -DisplayName 'dotnet'
if ($createResult.ExitCode -ne 0) {
    throw 'No se pudo crear el proyecto consumidor temporal.'
}

$nugetConfigPath = Join-Path $consumerDirectory 'NuGet.Config'
if (Test-Path -LiteralPath $nugetConfigPath) {
    Remove-Item -LiteralPath $nugetConfigPath -Force
}
@"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
  </packageSources>
</configuration>
"@ | Set-Content -LiteralPath $nugetConfigPath -Encoding UTF8

$addSourceLog = Join-Path $LogDirectory 'consume-add-source.log'
$addSourceResult = Invoke-LoggedCommand -FilePath $NuGetExePath -ArgumentList @('sources', 'Add', '-Name', $FeedName, '-Source', $FeedUrl, '-ConfigFile', $nugetConfigPath, '-NonInteractive') -LogPath $addSourceLog -DisplayName 'nuget.exe' -WorkingDirectory $consumerDirectory
if ($addSourceResult.ExitCode -ne 0) {
    throw 'No se pudo registrar el source privado para el proyecto consumidor.'
}

$installLog = Join-Path $LogDirectory 'consume-add-package.log'
$installResult = Invoke-LoggedCommand -FilePath $DotNetPath -ArgumentList @('add', (Join-Path $consumerDirectory ($projectName + '.csproj')), 'package', $PackageId, '--version', $PackageVersion) -LogPath $installLog -DisplayName 'dotnet' -WorkingDirectory $consumerDirectory
if ($installResult.ExitCode -ne 0) {
    throw 'dotnet add package falló durante la validación del consumo.'
}

$assetsPath = Join-Path $consumerDirectory 'obj\project.assets.json'
if (-not (Test-Path -LiteralPath $assetsPath)) {
    throw 'No se generó project.assets.json tras instalar el paquete.'
}

$assetsContent = Get-Content -LiteralPath $assetsPath -Raw
if ($assetsContent -notmatch [regex]::Escape($PackageId) -or $assetsContent -notmatch [regex]::Escape($PackageVersion)) {
    throw 'El paquete no aparece en project.assets.json; la instalación no quedó evidenciada.'
}

[pscustomobject]@{
    sourceAdd = [pscustomobject]@{
        commandLine = $addSourceResult.CommandLine
        configPath = $nugetConfigPath
        logPath = $addSourceResult.LogPath
        status = 'Passed'
    }
    consume = [pscustomobject]@{
        commandLine = $installResult.CommandLine
        assetsPath = $assetsPath
        logPath = $installResult.LogPath
        status = 'Passed'
    }
}
