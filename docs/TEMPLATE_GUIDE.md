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
