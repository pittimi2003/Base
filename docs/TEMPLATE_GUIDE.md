# Template Guide

Guía de instalación, generación y validación de los templates oficiales MachSoft.

## Requisitos

- .NET SDK 8.0.x
- Paquetes de template en `artifacts/packages` o feed interno
- Acceso a feed que publique `MachSoft.Template.Core`

## Install templates

```powershell
dotnet new install ./artifacts/packages/MachSoft.Template.Official.Server.1.0.0-internal.nupkg
dotnet new install ./artifacts/packages/MachSoft.Template.Official.Wasm.1.0.0-internal.nupkg
```

## Generate

### Server (.NET 8 Blazor Web App)

Este template genera una aplicación con Razor Components + Interactive Server rendering.

```powershell
dotnet new machsoft-server -n MyCompany.MyApp --CompanyName MyCompany --RootNamespace MyCompany.MyApp --CorePackageVersion 1.0.0-internal
```

### Wasm (.NET 8 Blazor WebAssembly)

```powershell
dotnet new machsoft-wasm -n MyCompany.MyApp --CompanyName MyCompany --RootNamespace MyCompany.MyApp --CorePackageVersion 1.0.0-internal
```

## Restore generated app

Actualiza `NuGet.config` en la app generada para habilitar `MachSoftPrivate` y establecer la URL real del feed.

```powershell
dotnet restore
```

## Build generated app

```powershell
dotnet build -c Release --no-restore
```

## Uninstall templates

```powershell
dotnet new uninstall MachSoft.Template.Official.Server
dotnet new uninstall MachSoft.Template.Official.Wasm
```

## Parámetros soportados

- `name`: nombre del proyecto y carpeta de salida.
- `CompanyName`: nombre de compañía para configuración base.
- `RootNamespace`: namespace raíz opcional.
- `CorePackageVersion`: versión de `MachSoft.Template.Core`.
- `PrivateFeedUrl`: URL del feed privado para `NuGet.config`.


## Actualización v1.0.0-internal (CorePremium)

- Se incorpora `src/MachSoft.Template.CorePremium` como RCL opcional para controles enterprise avanzados.
- `MachSoft.Template.Core` mantiene su rol foundation sin dependencias hacia Premium.
- Se agrega `samples/MachSoft.Template.SampleApp` para validación visual de `Core + CorePremium` en la ruta `/premium-showcase`.
- Se agrega flujo de empaquetado `build/scripts/Pack-CorePremium.ps1` y su integración en `Pack-All.ps1`.

## CorePremium package workflow

### Pack CorePremium

```powershell
pwsh ./build/scripts/Pack-CorePremium.ps1 -Configuration Release
```

### Publish to private feed (example)

```powershell
dotnet nuget push ./artifacts/packages/MachSoft.Template.CorePremium.<version>.nupkg --source MachSoftPrivate
```

### Consume from internal app

1. Reference package:

```xml
<PackageReference Include="MachSoft.Template.CorePremium" Version="1.0.0-internal" />
```

2. Register services:

```csharp
builder.Services.AddMachSoftTemplateCore().AddMachSoftTemplateCorePremium();
```

3. Add stylesheet:

```html
<link rel="stylesheet" href="_content/MachSoft.Template.CorePremium/css/machsoft-template-corepremium.css" />
```
