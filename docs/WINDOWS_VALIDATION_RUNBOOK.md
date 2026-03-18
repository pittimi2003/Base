# Windows validation runbook — MachSoft.PrivateNuGetFeed

Este runbook describe **cómo ejecutar la validación Windows de forma repetible** y qué evidencia debe revisarse antes de declarar que la solución queda aprobada para Azure App Service Windows.

## 1. Archivos del paquete de validación

- `scripts/Validate-WindowsFeed.ps1`
  - Script principal. Ejecuta prerrequisitos, restore, build, arranque local, comprobaciones HTTP, push, consumo y resumen final.
- `scripts/Test-PackagePush.ps1`
  - Genera un paquete temporal real y lo publica en el feed local.
- `scripts/Test-PackageConsume.ps1`
  - Registra un source temporal y consume el paquete publicado desde un proyecto consumidor temporal.
- `docs/WINDOWS_VALIDATION_PREREQUISITES.md`
  - Lista detallada de prerrequisitos.

## 2. Preparación de la máquina Windows

1. Confirmar los prerrequisitos del documento `WINDOWS_VALIDATION_PREREQUISITES.md`.
2. Clonar o copiar el repositorio completo.
3. Elegir una API key de validación local. No es necesario usar una credencial productiva.
4. Cerrar procesos previos de IIS Express que pudieran estar usando el mismo puerto si se quiere reutilizar el puerto por defecto `5087`.

## 3. Ejecución recomendada

Abrir **PowerShell en Windows** desde la raíz del repositorio y ejecutar:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\Validate-WindowsFeed.ps1 -ApiKey "MachSoft-Validation-Key-Only" -AutoDownloadNuGetExe
```

### Parámetros útiles

- `-Configuration Release`
  - Mantiene el build en Release.
- `-Port 5087`
  - Puerto de IIS Express. Cambiar si existe conflicto.
- `-FeedName MachSoftPrivateLocal`
  - Alias del source temporal.
- `-SkipPushConsume`
  - Ejecuta sólo restore/build/arranque/GETs; útil para diagnóstico inicial.
- `-LogRoot .\artifacts\windows-validation`
  - Carpeta base para evidencia.
- `-AutoDownloadNuGetExe`
  - Descarga `nuget.exe` localmente si no existe instalado.

## 4. Flujo exacto que ejecuta el script principal

1. Verifica que el host sea Windows.
2. Comprueba:
   - solución y proyecto presentes
   - MSBuild / Visual Studio Build Tools
   - targeting pack .NET Framework 4.8
   - IIS Express
   - dotnet CLI
   - `nuget.exe`
3. Lee `packagesPath` desde `src\MachSoft.PrivateNuGetFeed.Web\Web.config` y resuelve su ruta física local.
4. Ejecuta restore.
5. Ejecuta build Release.
6. Arranca el sitio con IIS Express.
7. Valida:
   - `GET /`
   - `GET /nuget`
   - `GET /nuget/Packages`
8. Genera un paquete temporal real con `dotnet pack`.
9. Hace push al feed local con `nuget.exe push`.
10. Crea un consumidor temporal y agrega un source temporal.
11. Instala el paquete de prueba con `dotnet add package`.
12. Verifica que el `.nupkg` exista en la ruta de repositorio esperada.
13. Reconsulta `/` y `/nuget` para validar no interferencia.
14. Emite veredicto final y genera `validation-summary.json`.

## 5. Evidencia que genera el paquete

Cada ejecución crea una carpeta similar a:

```text
artifacts\windows-validation\20260318-153000\
```

Dentro se esperan como mínimo:

- `logs\validation-transcript.log`
- `logs\restore.log`
- `logs\build.log`
- `logs\push-pack.log`
- `logs\push-publish.log`
- `logs\consume-add-source.log`
- `logs\consume-add-package.log`
- `http\home.html`
- `http\nuget-root.xml` o `.txt`
- `http\nuget-packages.xml`
- `validation-summary.json`

## 6. Qué se espera si todo va bien

### 6.1 Restore

- exit code `0`
- sin errores de paquetes no encontrados

### 6.2 Build Release

- exit code `0`
- sin errores de compilación ni de targets web

### 6.3 Portal

- `GET /` con `200`
- el HTML contiene `MachSoft Private Feed`

### 6.4 Feed

- `GET /nuget` con `200`
- `GET /nuget/Packages` con `200`
- las respuestas contienen contenido compatible con servicio/feed OData o referencias a `Packages`

### 6.5 Push

- `nuget.exe push` con exit code `0`
- el `.nupkg` aparece en la ruta de repositorio esperada

### 6.6 Consumo

- el source temporal se registra correctamente
- `dotnet add package` termina con exit code `0`
- `obj\project.assets.json` contiene el paquete y versión publicados

### 6.7 No interferencia

- `/` sigue respondiendo `200` después del push/consume
- `/nuget` sigue respondiendo `200` después del push/consume

## 7. Errores bloqueantes

La solución debe considerarse **rechazada** si ocurre cualquiera de los siguientes casos:

- falta un prerrequisito crítico
- restore falla
- build Release falla
- IIS Express no arranca el sitio
- `/` falla
- `/nuget` falla
- `/nuget/Packages` falla
- el push falla
- el consumo falla
- el `.nupkg` no aparece en la ruta del repositorio
- el portal deja de responder tras la operación sobre el feed
- el feed deja de responder tras la operación sobre el portal

## 8. Cómo decidir si la solución queda aprobada para Azure App Service Windows

La validación sólo debe considerarse **aprobada** cuando `validation-summary.json` cierre con:

- `"verdict": "Approved"`

Y además estén presentes todas estas evidencias objetivas:

- `restore.log` correcto
- `build.log` correcto
- respuesta `200` de `/`
- respuesta `200` de `/nuget`
- respuesta `200` de `/nuget/Packages`
- push correcto del paquete temporal
- consumo correcto del paquete temporal
- `.nupkg` localizado en el repositorio esperado
- comprobación positiva de coexistencia portal/feed

## 9. Qué adjuntar como evidencia en un cierre operativo

Para cerrar operativamente la validación, se recomienda adjuntar:

1. `validation-summary.json`
2. `build.log`
3. `restore.log`
4. capturas de `http\home.*`, `http\nuget-root.*`, `http\nuget-packages.*`
5. `push-publish.log`
6. `consume-add-package.log`
7. captura de la ruta física donde quedó el `.nupkg`
