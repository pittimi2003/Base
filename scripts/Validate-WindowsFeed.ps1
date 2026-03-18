[CmdletBinding()]
param(
    [string]$SolutionPath = (Join-Path $PSScriptRoot '..\MachSoft.PrivateNuGetFeed.sln'),
    [string]$ProjectPath = (Join-Path $PSScriptRoot '..\src\MachSoft.PrivateNuGetFeed.Web'),
    [string]$Configuration = 'Release',
    [int]$Port = 5087,
    [string]$FeedName = 'MachSoftPrivateLocal',
    [string]$ApiKey = '__API_KEY__',
    [string]$LogRoot = (Join-Path $PSScriptRoot '..\artifacts\windows-validation'),
    [switch]$SkipPushConsume,
    [switch]$AutoDownloadNuGetExe
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:ExitCode = 0

$script:Summary = [ordered]@{
    validationTimestampUtc = [DateTime]::UtcNow.ToString('o')
    solutionPath = $null
    projectPath = $null
    configuration = $Configuration
    baseUrl = $null
    feedUrl = $null
    packageRepositoryPath = $null
    prerequisites = @()
    restore = $null
    build = $null
    requests = @()
    sourceAdd = $null
    packagePush = $null
    packageConsume = $null
    coexistenceCheck = $null
    verdict = 'Rejected'
    blockingIssues = @()
}

function Write-Section {
    param([string]$Message)
    Write-Host ''
    Write-Host ('=' * 78) -ForegroundColor DarkCyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host ('=' * 78) -ForegroundColor DarkCyan
}

function Write-Step {
    param([string]$Message)
    Write-Host ('[MachSoft] ' + $Message) -ForegroundColor Gray
}

function Add-BlockingIssue {
    param([string]$Message)
    $script:Summary.blockingIssues += $Message
    Write-Host ('[BLOCKER] ' + $Message) -ForegroundColor Red
}

function Resolve-PathSafe {
    param([string]$PathValue)
    return [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $PathValue).Path)
}

function Invoke-LoggedCommand {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [Parameter(Mandatory = $true)][string[]]$ArgumentList,
        [Parameter(Mandatory = $true)][string]$LogPath,
        [string]$WorkingDirectory = $PWD.Path,
        [string]$DisplayName = $FilePath
    )

    Write-Step ("Ejecutando: {0} {1}" -f $DisplayName, ($ArgumentList -join ' '))
    $output = & $FilePath @ArgumentList 2>&1
    $output | Tee-Object -FilePath $LogPath | Out-Null

    return [pscustomobject]@{
        ExitCode = $LASTEXITCODE
        Output = @($output)
        LogPath = $LogPath
        CommandLine = "$DisplayName $($ArgumentList -join ' ')"
    }
}

function Get-VsInstallPath {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (-not (Test-Path -LiteralPath $vswhere)) {
        return $null
    }

    $installationPath = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($installationPath)) {
        return $null
    }

    return $installationPath.Trim()
}

function Get-MSBuildPath {
    $vsInstallPath = Get-VsInstallPath
    if (-not [string]::IsNullOrWhiteSpace($vsInstallPath)) {
        $candidate = Join-Path $vsInstallPath 'MSBuild\Current\Bin\MSBuild.exe'
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    $command = Get-Command msbuild.exe -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    return $null
}

function Get-IisExpressPath {
    foreach ($candidate in @(
        (Join-Path ${env:ProgramFiles} 'IIS Express\iisexpress.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'IIS Express\iisexpress.exe')
    )) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return $candidate
        }
    }

    $command = Get-Command iisexpress.exe -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    return $null
}

function Get-NuGetExePath {
    param(
        [string]$ToolsDirectory,
        [switch]$AllowDownload
    )

    $command = Get-Command nuget.exe -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    $localCopy = Join-Path $ToolsDirectory 'nuget.exe'
    if (Test-Path -LiteralPath $localCopy) {
        return $localCopy
    }

    if (-not $AllowDownload) {
        return $null
    }

    Write-Step 'nuget.exe no está instalado. Descargando una copia local para la validación...'
    Invoke-WebRequest -Uri 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutFile $localCopy
    return $localCopy
}

function Get-WebConfigPackagesPath {
    param([string]$WebConfigPath)
    [xml]$xml = Get-Content -LiteralPath $WebConfigPath -Raw
    $node = $xml.configuration.appSettings.add | Where-Object { $_.key -eq 'packagesPath' }
    if (-not $node) {
        return $null
    }

    return [string]$node.value
}

function Resolve-PackageRepositoryPath {
    param(
        [string]$ConfiguredPath,
        [string]$ProjectRoot
    )

    if ([string]::IsNullOrWhiteSpace($ConfiguredPath)) {
        return Join-Path $ProjectRoot 'App_Data\Packages'
    }

    if ($ConfiguredPath.StartsWith('~/')) {
        return Join-Path $ProjectRoot ($ConfiguredPath.Substring(2).Replace('/', '\'))
    }

    if ([System.IO.Path]::IsPathRooted($ConfiguredPath)) {
        return $ConfiguredPath
    }

    return Join-Path $ProjectRoot $ConfiguredPath
}

function Test-Prerequisite {
    param(
        [string]$Name,
        [bool]$IsPresent,
        [string]$Details,
        [switch]$IsCritical
    )

    $status = if ($IsPresent) { 'Present' } else { 'Missing' }
    $entry = [pscustomobject]@{
        name = $Name
        status = $status
        critical = [bool]$IsCritical
        details = $Details
    }
    $script:Summary.prerequisites += $entry

    if ($IsPresent) {
        Write-Host ("[OK] {0}: {1}" -f $Name, $Details) -ForegroundColor Green
    }
    else {
        Write-Host ("[MISSING] {0}: {1}" -f $Name, $Details) -ForegroundColor Yellow
        if ($IsCritical) {
            Add-BlockingIssue ("Falta prerrequisito crítico: {0}. {1}" -f $Name, $Details)
        }
    }
}

function Get-DetailOrFallback {
    param(
        [AllowNull()][string]$Value,
        [string]$Fallback
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $Fallback
    }

    return $Value
}

function Wait-ForUrl {
    param(
        [string]$Url,
        [int]$TimeoutSeconds = 60
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        try {
            $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 10
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500) {
                return $response
            }
        }
        catch {
            Start-Sleep -Seconds 2
        }
    }
    while ((Get-Date) -lt $deadline)

    throw "La aplicación no respondió en el plazo previsto para $Url."
}

function Invoke-EndpointCheck {
    param(
        [string]$Name,
        [string]$Url,
        [string]$OutputDirectory,
        [string]$ExpectedContentPattern
    )

    Write-Step ("Probando endpoint {0}: {1}" -f $Name, $Url)
    $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 20
    $extension = if ($response.Headers['Content-Type'] -like '*xml*') { 'xml' } elseif ($response.Headers['Content-Type'] -like '*html*') { 'html' } else { 'txt' }
    $bodyPath = Join-Path $OutputDirectory ("{0}.{1}" -f $Name, $extension)
    Set-Content -LiteralPath $bodyPath -Value $response.Content -Encoding UTF8

    $isSuccess = $response.StatusCode -eq 200 -and ($ExpectedContentPattern -eq $null -or $response.Content -match $ExpectedContentPattern)
    if (-not $isSuccess) {
        throw ("El endpoint {0} no devolvió la respuesta esperada. Status={1}, patrón={2}" -f $Name, $response.StatusCode, $ExpectedContentPattern)
    }

    $result = [pscustomobject]@{
        name = $Name
        url = $Url
        statusCode = $response.StatusCode
        contentType = $response.Headers['Content-Type']
        bodyPath = $bodyPath
    }

    $script:Summary.requests += $result
    return $result
}

if (-not ([Environment]::OSVersion.Platform -eq 'Win32NT')) {
    Write-Error 'Validate-WindowsFeed.ps1 debe ejecutarse en Windows. Este script no intentará validar ASP.NET MVC 5 / .NET Framework 4.8 fuera de Windows.'
    exit 1
}

$logRootFull = [System.IO.Path]::GetFullPath($LogRoot)
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$sessionRoot = Join-Path $logRootFull $timestamp
$toolsRoot = Join-Path $sessionRoot 'tools'
$logsRoot = Join-Path $sessionRoot 'logs'
$httpRoot = Join-Path $sessionRoot 'http'
$workRoot = Join-Path $sessionRoot 'work'
New-Item -ItemType Directory -Path $sessionRoot, $toolsRoot, $logsRoot, $httpRoot, $workRoot -Force | Out-Null

$transcriptPath = Join-Path $logsRoot 'validation-transcript.log'
Start-Transcript -Path $transcriptPath -Force | Out-Null

$iisProcess = $null
try {
    Write-Section 'MachSoft Private Feed - Validación Windows reproducible'

    $solutionPathFull = [System.IO.Path]::GetFullPath($SolutionPath)
    $projectPathFull = [System.IO.Path]::GetFullPath($ProjectPath)
    $webConfigPath = Join-Path $projectPathFull 'Web.config'
    $script:Summary.solutionPath = $solutionPathFull
    $script:Summary.projectPath = $projectPathFull
    $script:Summary.baseUrl = "http://localhost:$Port"
    $script:Summary.feedUrl = "http://localhost:$Port/nuget"

    Test-Prerequisite -Name 'Windows' -IsPresent $true -Details ([System.Environment]::OSVersion.VersionString) -IsCritical
    Test-Prerequisite -Name 'Solution file' -IsPresent (Test-Path -LiteralPath $solutionPathFull) -Details $solutionPathFull -IsCritical
    Test-Prerequisite -Name 'Web project' -IsPresent (Test-Path -LiteralPath $projectPathFull) -Details $projectPathFull -IsCritical
    Test-Prerequisite -Name 'Web.config' -IsPresent (Test-Path -LiteralPath $webConfigPath) -Details $webConfigPath -IsCritical

    $msbuildPath = Get-MSBuildPath
    Test-Prerequisite -Name 'Visual Studio / Build Tools (MSBuild)' -IsPresent (-not [string]::IsNullOrWhiteSpace($msbuildPath)) -Details (Get-DetailOrFallback -Value $msbuildPath -Fallback 'MSBuild.exe no encontrado.') -IsCritical

    $targetingPackPath = Join-Path ${env:ProgramFiles(x86)} 'Reference Assemblies\Microsoft\Framework\.NETFramework\v4.8'
    Test-Prerequisite -Name '.NET Framework 4.8 Targeting Pack' -IsPresent (Test-Path -LiteralPath $targetingPackPath) -Details $targetingPackPath -IsCritical

    $iisExpressPath = Get-IisExpressPath
    Test-Prerequisite -Name 'IIS Express' -IsPresent (-not [string]::IsNullOrWhiteSpace($iisExpressPath)) -Details (Get-DetailOrFallback -Value $iisExpressPath -Fallback 'iisexpress.exe no encontrado.') -IsCritical

    $dotnetCommand = Get-Command dotnet.exe -ErrorAction SilentlyContinue
    $dotnetPath = if ($dotnetCommand) { $dotnetCommand.Source } else { $null }
    Test-Prerequisite -Name 'dotnet CLI' -IsPresent ($null -ne $dotnetCommand) -Details (Get-DetailOrFallback -Value $dotnetPath -Fallback 'dotnet.exe no encontrado.') -IsCritical

    $nugetExePath = Get-NuGetExePath -ToolsDirectory $toolsRoot -AllowDownload:$AutoDownloadNuGetExe
    Test-Prerequisite -Name 'NuGet CLI (nuget.exe)' -IsPresent (-not [string]::IsNullOrWhiteSpace($nugetExePath)) -Details (Get-DetailOrFallback -Value $nugetExePath -Fallback 'Instalar nuget.exe o usar -AutoDownloadNuGetExe para habilitar push HTTP automatizado.') -IsCritical

    $configuredPackagesPath = Get-WebConfigPackagesPath -WebConfigPath $webConfigPath
    $resolvedPackagesPath = Resolve-PackageRepositoryPath -ConfiguredPath $configuredPackagesPath -ProjectRoot $projectPathFull
    $script:Summary.packageRepositoryPath = $resolvedPackagesPath
    Test-Prerequisite -Name 'Repositorio de paquetes' -IsPresent $true -Details $resolvedPackagesPath

    if ($script:Summary.blockingIssues.Count -gt 0) {
        throw 'La validación se detuvo porque faltan prerrequisitos críticos.'
    }

    Write-Section 'Restore de la solución'
    $restoreLogPath = Join-Path $logsRoot 'restore.log'
    $restoreResult = if ($nugetExePath) {
        Invoke-LoggedCommand -FilePath $nugetExePath -ArgumentList @('restore', $solutionPathFull, '-NonInteractive', '-Verbosity', 'detailed') -LogPath $restoreLogPath -DisplayName 'nuget.exe'
    }
    else {
        Invoke-LoggedCommand -FilePath $msbuildPath -ArgumentList @($solutionPathFull, '/t:Restore', '/p:RestorePackagesConfig=true', '/p:Configuration=' + $Configuration) -LogPath $restoreLogPath -DisplayName 'MSBuild'
    }

    $script:Summary.restore = [pscustomobject]@{
        commandLine = $restoreResult.CommandLine
        exitCode = $restoreResult.ExitCode
        logPath = $restoreResult.LogPath
    }

    if ($restoreResult.ExitCode -ne 0) {
        throw 'Restore falló. Revisar restore.log.'
    }

    Write-Section 'Build Release'
    $buildLogPath = Join-Path $logsRoot 'build.log'
    $buildResult = Invoke-LoggedCommand -FilePath $msbuildPath -ArgumentList @($solutionPathFull, '/m', '/p:Configuration=' + $Configuration, '/p:Platform=Any CPU') -LogPath $buildLogPath -DisplayName 'MSBuild'
    $script:Summary.build = [pscustomobject]@{
        commandLine = $buildResult.CommandLine
        exitCode = $buildResult.ExitCode
        logPath = $buildResult.LogPath
    }

    if ($buildResult.ExitCode -ne 0) {
        throw 'Build Release falló. Revisar build.log.'
    }

    Write-Section 'Arranque local con IIS Express'
    if (-not (Test-Path -LiteralPath $resolvedPackagesPath)) {
        New-Item -ItemType Directory -Path $resolvedPackagesPath -Force | Out-Null
    }

    $iisArgs = @(
        "/path:$projectPathFull",
        "/port:$Port",
        '/clr:v4.0',
        '/systray:false'
    )
    Write-Step ("Iniciando IIS Express en http://localhost:{0}" -f $Port)
    $iisProcess = Start-Process -FilePath $iisExpressPath -ArgumentList $iisArgs -PassThru -WindowStyle Hidden
    Wait-ForUrl -Url "$($script:Summary.baseUrl)/" -TimeoutSeconds 90 | Out-Null

    Write-Section 'Validación HTTP del portal y del feed'
    Invoke-EndpointCheck -Name 'home' -Url "$($script:Summary.baseUrl)/" -OutputDirectory $httpRoot -ExpectedContentPattern 'MachSoft Private Feed' | Out-Null
    Invoke-EndpointCheck -Name 'nuget-root' -Url "$($script:Summary.feedUrl)" -OutputDirectory $httpRoot -ExpectedContentPattern '(Packages|service|workspace|NuGet)' | Out-Null
    Invoke-EndpointCheck -Name 'nuget-packages' -Url "$($script:Summary.feedUrl)/Packages" -OutputDirectory $httpRoot -ExpectedContentPattern '(feed|entry|Packages)' | Out-Null

    if (-not $SkipPushConsume) {
        Write-Section 'Validación de source, push y consumo'
        $pushScript = Join-Path $PSScriptRoot 'Test-PackagePush.ps1'
        $pushResult = & $pushScript `
            -FeedUrl $script:Summary.feedUrl `
            -ApiKey $ApiKey `
            -PackageRepositoryPath $resolvedPackagesPath `
            -WorkingDirectory (Join-Path $workRoot 'push') `
            -LogDirectory $logsRoot `
            -DotNetPath $dotnetPath `
            -NuGetExePath $nugetExePath

        $script:Summary.packagePush = $pushResult
        $script:Summary.sourceAdd = [pscustomobject]@{
            configPath = $null
            commandLine = 'Registrado en script de consumo.'
            status = 'Pending consume step'
        }

        $consumeScript = Join-Path $PSScriptRoot 'Test-PackageConsume.ps1'
        $consumeResult = & $consumeScript `
            -FeedName $FeedName `
            -FeedUrl $script:Summary.feedUrl `
            -PackageId $pushResult.packageId `
            -PackageVersion $pushResult.packageVersion `
            -WorkingDirectory (Join-Path $workRoot 'consume') `
            -LogDirectory $logsRoot `
            -DotNetPath $dotnetPath `
            -NuGetExePath $nugetExePath

        $script:Summary.sourceAdd = $consumeResult.sourceAdd
        $script:Summary.packageConsume = $consumeResult.consume
    }

    Write-Section 'Validación de no interferencia'
    $homeAgain = Invoke-EndpointCheck -Name 'home-after-push' -Url "$($script:Summary.baseUrl)/" -OutputDirectory $httpRoot -ExpectedContentPattern 'MachSoft Private Feed'
    $feedAgain = Invoke-EndpointCheck -Name 'nuget-after-push' -Url "$($script:Summary.feedUrl)" -OutputDirectory $httpRoot -ExpectedContentPattern '(Packages|service|workspace|NuGet)'
    $script:Summary.coexistenceCheck = [pscustomobject]@{
        homeStatusCode = $homeAgain.statusCode
        feedStatusCode = $feedAgain.statusCode
        status = 'Passed'
    }

    $script:Summary.verdict = 'Approved'
    Write-Host ''
    Write-Host 'VALIDACIÓN WINDOWS APROBADA.' -ForegroundColor Green
}
catch {
    $script:ExitCode = 1
    $script:Summary.verdict = 'Rejected'
    Add-BlockingIssue $_.Exception.Message
    Write-Host ''
    Write-Host 'VALIDACIÓN WINDOWS RECHAZADA.' -ForegroundColor Red
    Write-Host $_.Exception.ToString() -ForegroundColor DarkRed
}
finally {
    if ($iisProcess -and -not $iisProcess.HasExited) {
        Write-Step 'Deteniendo IIS Express...'
        Stop-Process -Id $iisProcess.Id -Force -ErrorAction SilentlyContinue
    }

    $summaryPath = Join-Path $sessionRoot 'validation-summary.json'
    $script:Summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $summaryPath -Encoding UTF8
    Write-Step ("Resumen JSON: {0}" -f $summaryPath)
    Write-Step ("Transcript: {0}" -f $transcriptPath)
    Stop-Transcript | Out-Null
}

exit $script:ExitCode
