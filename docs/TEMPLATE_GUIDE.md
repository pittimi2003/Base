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


## Validación visual rápida de inputs base

1. Ejecutar `MachSoft.Template.Core.Control.Showcase`.
2. Abrir `/showcase/inputs`.
3. Validar `MxTextField`, `MxTextArea`, `MxCheckbox`, `MxRadio`, `MxSwitch`, `MxSelect` en estados default/disabled/readonly/invalid (según aplique).
4. Confirmar que estilos provienen de `_content/MachSoft.Template.Core` + `_content/MachSoft.Template.Core.Control`.

Nota: en `MxSelect`, `ReadOnly` se implementa como modo no interactivo para mantener consistencia cross-browser y cross-hosting.

## Consolidación inputs base (2026-03-25)

- `MxRadio` mantiene agrupación baseline por `Name` (sin `MxRadioGroup` avanzado en esta fase).
- `MxSelect` mantiene contrato simple; `ReadOnly` se implementa como modo no interactivo para consistencia cross-browser.
- `MachSoft.Template.Core.Control` incluye ahora `NUGET_README.md` para eliminar warning de pack por readme faltante.
