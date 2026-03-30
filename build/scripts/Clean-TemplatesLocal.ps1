[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

$repoRoot = Get-RepoRoot
$targets = @(
    (Join-Path $repoRoot 'src/MachSoft.Template.Official.Server/bin'),
    (Join-Path $repoRoot 'src/MachSoft.Template.Official.Server/obj'),
    (Join-Path $repoRoot 'src/MachSoft.Template.Official.Server/template-content/bin'),
    (Join-Path $repoRoot 'src/MachSoft.Template.Official.Server/template-content/obj'),
    (Join-Path $repoRoot 'src/MachSoft.Template.Official.Wasm/bin'),
    (Join-Path $repoRoot 'src/MachSoft.Template.Official.Wasm/obj'),
    (Join-Path $repoRoot 'src/MachSoft.Template.Official.Wasm/template-content/bin'),
    (Join-Path $repoRoot 'src/MachSoft.Template.Official.Wasm/template-content/obj')
)

Invoke-Step -StepName 'Limpieza local de bin/obj de templates Server y Wasm' -Command 'Remove-Item <template bin/obj paths> -Recurse -Force' -Action {
    foreach ($path in $targets) {
        if (Test-Path $path) {
            Remove-Item -Recurse -Force $path
            Write-Host "Removed: $path" -ForegroundColor Yellow
        }
    }
}
