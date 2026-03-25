# MachSoft Templates

Repositorio de productización en .NET 8 para el ecosistema corporativo de templates MachSoft.

## Componentes

- `MachSoft.Template.Core`: paquete NuGet reusable (Razor Class Library).
- `MachSoft.Template.Official.Server`: template oficial `dotnet new` para **Blazor Web App** con **Razor Components + Interactive Server rendering**.
- `MachSoft.Template.Official.Wasm`: template oficial `dotnet new` para **Blazor WebAssembly**.
- `MachSoft.Template.Core.Control`: catálogo oficial `Mx*` empaquetable como NuGet (RCL).
- `MachSoft.Template.Core.Control.Showcase`: host separado para validación visual/funcional del catálogo.

## Estructura del repositorio

```text
.
├── build/
│   └── scripts/
├── docs/
├── src/
│   ├── MachSoft.Template.Core/
│   ├── MachSoft.Template.Core.Control/
│   ├── MachSoft.Template.Core.Control.Showcase/
│   ├── MachSoft.Template.Official.Server/
│   │   └── template-content/
│   └── MachSoft.Template.Official.Wasm/
│       └── template-content/
├── Directory.Build.props
├── Directory.Packages.props
├── MachSoft.Templates.sln
├── NuGet.config
└── README.md
```

## Requisitos

- .NET SDK 8.0.x
- PowerShell 7+ (para scripts en `build/scripts`)
- Acceso a feed interno para restaurar `MachSoft.Template.Core`

## Restore

```powershell
dotnet restore MachSoft.Templates.sln
```

## Build

```powershell
dotnet build MachSoft.Templates.sln -c Release --no-restore
```

## Pack

### Pack Core

```powershell
dotnet pack ./src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o ./artifacts/packages
```

### Pack Server Template

```powershell
dotnet pack ./src/MachSoft.Template.Official.Server/MachSoft.Template.Official.Server.csproj -c Release -o ./artifacts/packages
```

### Pack Wasm Template

```powershell
dotnet pack ./src/MachSoft.Template.Official.Wasm/MachSoft.Template.Official.Wasm.csproj -c Release -o ./artifacts/packages
```

### Pack All (script)

```powershell
pwsh ./build/scripts/Pack-All.ps1
```

## Install templates

```powershell
dotnet new install ./artifacts/packages/MachSoft.Template.Official.Server.1.0.0-internal.nupkg
dotnet new install ./artifacts/packages/MachSoft.Template.Official.Wasm.1.0.0-internal.nupkg
```

## Generate

### Generate Server app

```powershell
dotnet new machsoft-server -n MyCompany.MyApp --CompanyName MyCompany --RootNamespace MyCompany.MyApp --CorePackageVersion 1.0.0-internal
```

### Generate Wasm app

```powershell
dotnet new machsoft-wasm -n MyCompany.MyApp --CompanyName MyCompany --RootNamespace MyCompany.MyApp --CorePackageVersion 1.0.0-internal
```

## Restore generated app

Configura primero el `NuGet.config` generado (URL del feed interno y habilitación de `MachSoftPrivate`) y luego ejecuta:

```powershell
dotnet restore
```

## Uninstall templates

```powershell
dotnet new uninstall MachSoft.Template.Official.Server
dotnet new uninstall MachSoft.Template.Official.Wasm
```

## Feed privado

Placeholder estándar usado en configuración:

```text
https://your-private-feed/v3/index.json
```

No incluir credenciales ni secretos en el repositorio.


## Control Catalog (nuevo)

- `MachSoft.Template.Core.Control` referencia `MachSoft.Template.Core` y publica static web assets del catálogo.
- `MachSoft.Template.Core.Control.Showcase` referencia `MachSoft.Template.Core.Control` y sirve como entorno de validación visual y funcional (light/dark, navegación por familias, fundamentos).

### Pack Core.Control

```powershell
dotnet pack ./src/MachSoft.Template.Core.Control/MachSoft.Template.Core.Control.csproj -c Release -o ./artifacts/packages
```


### Estado actual del catálogo `Core.Control`

- Existe la **base arquitectónica y de empaquetado** (`RCL` + `NuGet`) para `MachSoft.Template.Core.Control`.
- Existe un **Showcase desacoplado** para validación visual/funcional.
- La implementación completa de todas las familias premium sigue pendiente para iteraciones posteriores (no está cerrada en esta etapa).


## Actualización 2026-03-24 — Core.Control lote 1
- `MachSoft.Template.Core.Control` incluye primera familia pública (`MxButton`, `MxIconButton`, `MxAlert`, `MxProgress`, `MxTooltip`, `MxDialog`, `MxToast`, `MxPopup`) con ejemplos en `Core.Control.Showcase`.
- El Showcase ahora expone validación por familias `Actions`, `Feedback` y `Overlays` con estados base (default, disabled, loading e interacción).

## Actualización 2026-03-25 — hardening lote 1 Core.Control
- Se consolidó la primera familia pública (`Actions`, `Feedback`, `Overlays`) con mejoras de accesibilidad, estados y consistencia visual.
- Se documentaron límites reales actuales de overlays (`dialog`, `toast`, `tooltip`, `popup`) antes de avanzar a nuevas familias.
