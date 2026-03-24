# MachSoft.Template.Official.Server

Template oficial `dotnet new` para .NET 8 **Blazor Web App** con **Razor Components + Interactive Server rendering**.

## Requisitos

- .NET SDK 8.0.x
- Acceso al paquete `MachSoft.Template.Core` en feed interno

## Install

```powershell
dotnet new install MachSoft.Template.Official.Server
```

## Generate

```powershell
dotnet new machsoft-server -n MyCompany.MyApp --CompanyName MyCompany --RootNamespace MyCompany.MyApp --CorePackageVersion 1.0.0-internal
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
dotnet new uninstall MachSoft.Template.Official.Server
```
