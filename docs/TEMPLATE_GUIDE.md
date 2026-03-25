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


## Catálogo oficial Core.Control

### Build

```powershell
dotnet build ./src/MachSoft.Template.Core.Control/MachSoft.Template.Core.Control.csproj
```

### Pack NuGet interno

```powershell
dotnet pack ./src/MachSoft.Template.Core.Control/MachSoft.Template.Core.Control.csproj -c Release -o ./artifacts/packages
```

### Validación visual con Showcase

```powershell
dotnet run --project ./src/MachSoft.Template.Core.Control.Showcase/MachSoft.Template.Core.Control.Showcase.csproj
```

Abrir `https://localhost:<puerto>/` y validar:
- Home del catálogo
- Foundations visuales (`/foundations`)
- Familias de controles
- Cambio de tema Light/Dark desde navegación lateral


### Nota de alcance actual

`MachSoft.Template.Core.Control` está listo como base distribuible, pero **no contiene todavía la implementación completa de todas las familias premium**. El Showcase valida la infraestructura base (navegación, theming, rutas y separación de responsabilidades).


## Nota de adopción (2026-03-24)
Para validar catálogo público inicial, ejecutar `MachSoft.Template.Core.Control.Showcase` y revisar rutas:
- `/families/actions`
- `/families/feedback`
- `/families/overlays`
- `/families/listing`

Estas páginas cubren variantes y estados base de los controles del lote 1.

## Nota de consolidación (2026-03-25)
La validación de `/families/actions`, `/families/feedback`, `/families/overlays` y `/families/listing` incluye estados endurecidos y ejemplos funcionales reales por familia.

## Nota de consolidación (2026-03-25) — Data family

- Para validar `MxDataGrid` enterprise inicial, ejecutar Showcase y abrir `/families/data`.
- Casos esperados: sorting visible por columna, selección de filas con resumen en toolbar, acciones simples por fila y estados empty/loading.
- Esta fase no incluye filtros avanzados, inline edit, export ni virtualización real.
