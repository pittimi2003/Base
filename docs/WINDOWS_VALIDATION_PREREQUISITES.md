# Windows validation prerequisites — MachSoft.PrivateNuGetFeed

Este documento define **qué debe existir en la máquina Windows** antes de ejecutar la validación real del feed privado.

## 1. Objetivo de estos prerrequisitos

La solución `MachSoft.PrivateNuGetFeed` es una aplicación **ASP.NET MVC 5 sobre .NET Framework 4.8** con `NuGet.Server`. Para validarla realmente no basta con revisar XML o archivos: hay que restaurar, compilar, arrancar el sitio y ejecutar push/consumo sobre un host Windows.

## 2. Sistema operativo admitido

- Windows 10/11 profesional o empresarial, o Windows Server moderno.
- PowerShell 5.1 o PowerShell 7.
- Permisos para ejecutar IIS Express y crear carpetas temporales bajo el directorio del repositorio.

## 3. Software obligatorio

### 3.1 Visual Studio 2022 o Build Tools 2022

Debe existir una instalación que incluya como mínimo:

- `MSBuild`
- soporte de **ASP.NET and web development** o **Build Tools for Web Applications**
- `Microsoft.WebApplication.targets`

### 3.2 .NET Framework 4.8 Developer Pack / Targeting Pack

Debe estar presente la carpeta:

- `C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.8`

Sin ese targeting pack, el build Release de la solución no es válido.

### 3.3 IIS Express

Debe existir `iisexpress.exe` en una ubicación estándar, por ejemplo:

- `C:\Program Files\IIS Express\iisexpress.exe`
- `C:\Program Files (x86)\IIS Express\iisexpress.exe`

> El paquete de validación usa IIS Express porque permite una ejecución local repetible sin depender de una configuración manual previa de IIS local.

### 3.4 dotnet CLI

Debe existir `dotnet.exe` para:

- crear el paquete temporal de validación
- empaquetar (`dotnet pack`)
- crear el proyecto consumidor temporal
- instalar el paquete de prueba

### 3.5 NuGet CLI (`nuget.exe`)

Se requiere para:

- restore tradicional de la solución (`nuget restore`) cuando aplique
- `nuget.exe push` contra el feed local HTTP de IIS Express
- registro reproducible del source temporal durante la validación

Si no está instalado globalmente, el script principal puede descargar una copia local con:

```powershell
-AutoDownloadNuGetExe
```

## 4. Estructura esperada del repositorio

La máquina Windows debe tener el repositorio con estos artefactos ya presentes:

- `MachSoft.PrivateNuGetFeed.sln`
- `src/MachSoft.PrivateNuGetFeed.Web`
- `scripts/Validate-WindowsFeed.ps1`
- `scripts/Test-PackagePush.ps1`
- `scripts/Test-PackageConsume.ps1`
- `docs/WINDOWS_VALIDATION_RUNBOOK.md`

## 5. Requisitos de red y seguridad

- No se requiere Internet para arrancar el sitio si las dependencias ya están restauradas.
- Sí puede requerirse Internet si se usa `-AutoDownloadNuGetExe`.
- La validación local usa HTTP sobre `localhost`, por lo que la API key de prueba puede ser una clave de laboratorio y no una credencial productiva.

## 6. Requisitos funcionales que cubre el paquete

El paquete de validación está diseñado para comprobar de forma reproducible:

1. prerrequisitos del entorno
2. restore real
3. build Release real
4. arranque local del portal
5. `GET /`
6. `GET /nuget`
7. `GET /nuget/Packages`
8. alta de source temporal
9. push de un paquete real de prueba
10. consumo/instalación de ese paquete
11. presencia del `.nupkg` en el repositorio esperado
12. convivencia correcta entre portal y feed

## 7. Qué se considera bloqueante

La validación debe detenerse si falta cualquiera de estos elementos:

- Windows
- MSBuild / Visual Studio Build Tools
- targeting pack .NET Framework 4.8
- IIS Express
- dotnet CLI
- `nuget.exe` si no se habilitó la descarga automática
- `MachSoft.PrivateNuGetFeed.sln`
- `src/MachSoft.PrivateNuGetFeed.Web\Web.config`

## 8. Evidencia mínima que debe conservarse

El operador debe guardar la carpeta generada bajo:

- `artifacts\windows-validation\<timestamp>`

Esa carpeta contendrá como mínimo:

- transcript de PowerShell
- `restore.log`
- `build.log`
- respuestas HTTP capturadas
- logs de push y consumo
- `validation-summary.json`
