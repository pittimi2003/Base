[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$FeedUrl,
    [Parameter(Mandatory = $true)][string]$ApiKey,
    [Parameter(Mandatory = $true)][string]$PackageRepositoryPath,
    [Parameter(Mandatory = $true)][string]$WorkingDirectory,
    [Parameter(Mandatory = $true)][string]$LogDirectory,
    [Parameter(Mandatory = $true)][string]$DotNetPath,
    [Parameter(Mandatory = $true)][string]$NuGetExePath,
    [string]$PackageId = 'MachSoft.PrivateNuGetFeed.ValidationPackage',
    [string]$PackageVersion = ('1.0.0-validation-{0}' -f (Get-Date -Format 'yyyyMMddHHmmss'))
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-LoggedCommand {
    param(
        [string]$FilePath,
        [string[]]$ArgumentList,
        [string]$LogPath,
        [string]$DisplayName = $FilePath
    )

    $output = & $FilePath @ArgumentList 2>&1
    $output | Tee-Object -FilePath $LogPath | Out-Null
    return [pscustomobject]@{
        ExitCode = $LASTEXITCODE
        Output = @($output)
        CommandLine = "$DisplayName $($ArgumentList -join ' ')"
        LogPath = $LogPath
    }
}

New-Item -ItemType Directory -Path $WorkingDirectory, $LogDirectory -Force | Out-Null
$projectDirectory = Join-Path $WorkingDirectory 'validation-package'
$packageOutputDirectory = Join-Path $WorkingDirectory 'artifacts'
New-Item -ItemType Directory -Path $projectDirectory, $packageOutputDirectory -Force | Out-Null

$projectName = 'MachSoftPrivateValidationPackage'
$createLog = Join-Path $LogDirectory 'push-create-project.log'
$createResult = Invoke-LoggedCommand -FilePath $DotNetPath -ArgumentList @('new', 'classlib', '--framework', 'net8.0', '--name', $projectName, '--force', '--output', $projectDirectory) -LogPath $createLog -DisplayName 'dotnet'
if ($createResult.ExitCode -ne 0) {
    throw 'No se pudo crear el paquete de validación.'
}

$projectFile = Join-Path $projectDirectory ($projectName + '.csproj')
@"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <PackageId>$PackageId</PackageId>
    <Version>$PackageVersion</Version>
    <Authors>MachSoft</Authors>
    <Company>MachSoft</Company>
    <Description>Paquete temporal para validar push y consumo del feed privado MachSoft.</Description>
    <PackageTags>validation;machsoft;private-feed</PackageTags>
    <GeneratePackageOnBuild>false</GeneratePackageOnBuild>
  </PropertyGroup>
</Project>
"@ | Set-Content -LiteralPath $projectFile -Encoding UTF8

$classFile = Join-Path $projectDirectory 'ValidationMarker.cs'
@"
namespace MachSoft.PrivateNuGetFeed.Validation;

public static class ValidationMarker
{
    public const string Message = "MachSoft Windows validation package";
}
"@ | Set-Content -LiteralPath $classFile -Encoding UTF8

$packLog = Join-Path $LogDirectory 'push-pack.log'
$packResult = Invoke-LoggedCommand -FilePath $DotNetPath -ArgumentList @('pack', $projectFile, '-c', 'Release', '-o', $packageOutputDirectory) -LogPath $packLog -DisplayName 'dotnet'
if ($packResult.ExitCode -ne 0) {
    throw 'dotnet pack falló para el paquete de validación.'
}

$packagePath = Join-Path $packageOutputDirectory ("{0}.{1}.nupkg" -f $PackageId, $PackageVersion)
if (-not (Test-Path -LiteralPath $packagePath)) {
    throw ("No se encontró el nupkg esperado: {0}" -f $packagePath)
}

$expectedStoredPackagePath = Join-Path $PackageRepositoryPath (Split-Path -Path $packagePath -Leaf)
if (Test-Path -LiteralPath $expectedStoredPackagePath) {
    Remove-Item -LiteralPath $expectedStoredPackagePath -Force
}

$pushLog = Join-Path $LogDirectory 'push-publish.log'
$pushResult = Invoke-LoggedCommand -FilePath $NuGetExePath -ArgumentList @('push', $packagePath, $ApiKey, '-Source', $FeedUrl, '-NonInteractive', '-Verbosity', 'detailed', '-AllowInsecureConnections') -LogPath $pushLog -DisplayName 'nuget.exe'
if ($pushResult.ExitCode -ne 0) {
    throw 'nuget.exe push falló.'
}

$deadline = (Get-Date).AddSeconds(25)
while ((Get-Date) -lt $deadline -and -not (Test-Path -LiteralPath $expectedStoredPackagePath)) {
    Start-Sleep -Seconds 2
}

if (-not (Test-Path -LiteralPath $expectedStoredPackagePath)) {
    throw ("El paquete no apareció en la ruta esperada del repositorio: {0}" -f $expectedStoredPackagePath)
}

[pscustomobject]@{
    packageId = $PackageId
    packageVersion = $PackageVersion
    packagePath = $packagePath
    storedPackagePath = $expectedStoredPackagePath
    packCommandLine = $packResult.CommandLine
    pushCommandLine = $pushResult.CommandLine
    packLogPath = $packResult.LogPath
    pushLogPath = $pushResult.LogPath
    status = 'Passed'
}
