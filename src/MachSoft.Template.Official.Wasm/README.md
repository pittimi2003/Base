# MachSoft.Template.Official.Wasm

Template oficial `dotnet new` para .NET 8 **Blazor WebAssembly**.

## Requisitos

- .NET SDK 8.0.x
- Acceso al paquete `MachSoft.Template.Core` + `MachSoft.Template.Core.Control` en feed interno

## Install

```powershell
dotnet new install MachSoft.Template.Official.Wasm
```

## Generate

```powershell
dotnet new machsoft-wasm -n MyCompany.MyApp --CompanyName MyCompany --RootNamespace MyCompany.MyApp --CorePackageVersion 1.0.0-internal --CoreControlPackageVersion 1.0.0-internal
```

## Restore generated app

```powershell
dotnet restore
```

## Build generated app

```powershell
dotnet build -c Release --no-restore
```

## Uninstall

```powershell
dotnet new uninstall MachSoft.Template.Official.Wasm
```
