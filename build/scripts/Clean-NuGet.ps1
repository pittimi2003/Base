[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-Step -StepName 'Limpieza de cachés NuGet locales' -Command 'dotnet nuget locals all --clear' -Action {
    Invoke-DotNet @('nuget', 'locals', 'all', '--clear')
}
