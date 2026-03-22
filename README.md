# MachSoft.PrivateNuGetFeed

Solución moderna basada en **ASP.NET Core 8** para alojar un **feed privado de NuGet** con **BaGet** como motor del protocolo y un **portal corporativo MachSoft** construido con **Razor Pages**. La solución está preparada para ejecutarse localmente, abrirse en **Visual Studio 2022** y publicarse en **Azure App Service Windows** sin Docker, sin contenedores, sin Linux obligatorio y sin stacks legacy de ASP.NET MVC 5 o .NET Framework.

> **Enfoque del producto:** esta solución está pensada como **feed privado interno** para consumo y publicación controlada de paquetes. No pretende reemplazar una galería del tamaño funcional de nuget.org con flujos avanzados de moderación, federación o marketplace.

## 1. Descripción del proyecto

`MachSoft.PrivateNuGetFeed` expone dos superficies claramente desacopladas:

- **Portal humano en `/`** con branding MachSoft, comandos operativos y guía rápida.
- **Feed técnico NuGet en `/v3/index.json` y `/api/v2/package`** servido por **BaGet**, manteniendo compatibilidad con `dotnet CLI`, `nuget.exe` y Visual Studio.

La home está diseñada para que un desarrollador o equipo de plataforma entienda rápidamente:

- cuál es la URL del feed,
- cómo registrar el source,
- cómo instalar paquetes,
- cómo publicar nuevas versiones,
- qué variables deben configurarse en Azure App Service,
- y cómo endurecer seguridad posteriormente.

## 2. Arquitectura funcional

### Superficies expuestas

- `/` → portal corporativo de operación humana.
- `/v3/index.json` → service index NuGet v3.
- `/api/v2/package` → endpoint de publicación de paquetes.
- `/v3/search` → búsqueda de paquetes.
- `/v3/registration` → metadatos de paquetes.
- `/v3/package` → descarga de contenido de paquetes.

### Separación de responsabilidades

#### Portal visual

- Renderizado con **ASP.NET Core 8 Razor Pages**.
- Layout corporativo sobrio, limpio y responsive.
- CSS propio y JS mínimo para copiar comandos.
- No mezcla layout corporativo con el protocolo NuGet.

#### Feed técnico

- Integrado con **BaGet.Web**.
- Persistencia mediante **SQLite** para metadatos.
- Almacenamiento en disco configurable para paquetes `.nupkg`.
- API key configurable para publicación.

### Estrategia de persistencia

#### Desarrollo local recomendado

- Base de datos: `App_Data/Data/baget.db`
- Paquetes: `App_Data/Packages`

#### Azure App Service Windows recomendado

- Base de datos: `D:\home\data\MachSoft.PrivateNuGetFeed\baget.db`
- Paquetes: `D:\home\data\MachSoft.PrivateNuGetFeed\Packages`

Esta estrategia separa el contenido persistente del feed del contenido estático del portal, evitando mezclar paquetes con assets web temporales o de despliegue.

## 3. Stack y decisiones técnicas

### Stack elegido

- **.NET 8**
- **ASP.NET Core 8 Razor Pages**
- **BaGet.Web 0.4.0-preview2**
- **BaGet.Database.Sqlite 0.4.0-preview2**
- **SQLite** para metadatos del feed
- **File system storage** para paquetes NuGet

### Decisiones técnicas adoptadas

1. **No usar ASP.NET Framework ni MVC 5**
   - El host es un proyecto SDK-style `Microsoft.NET.Sdk.Web` sobre `net8.0`.

2. **No usar NuGet.Server**
   - El protocolo NuGet no se reimplementa y tampoco se usa un stack legacy.
   - Se integra **BaGet** como implementación existente y moderna del feed.

3. **Usar Razor Pages para el portal**
   - La UI humana se construye con **Razor Pages**, sin Blazor y sin MVC clásico.
   - Se prioriza simplicidad, mantenimiento y claridad operativa.

4. **Separar portal y feed**
   - El portal vive en `/`.
   - El feed vive en los endpoints estándar de BaGet (`/v3/*`, `/api/v2/package`).
   - No hay mezcla de layout corporativo con endpoints técnicos.

5. **Configurar secretos por App Settings**
   - `Feed__ApiKey` debe configurarse fuera del código en Azure App Service.
   - Se deja preparado el patrón para **Azure App Settings** y, si la organización ya lo usa, **Key Vault references**.

6. **Persistencia lista para App Service Windows**
   - Se usa almacenamiento de archivos y SQLite para una puesta en marcha simple y coherente.
   - La ruta persistente recomendada apunta a `D:\home\data\...`, apta para App Service Windows.

## 4. Prerrequisitos

- **Visual Studio 2022** o superior, o **.NET SDK 8**.
- Acceso a Internet para restaurar paquetes NuGet.
- Una suscripción Azure con un **App Service Plan Windows** y una **Web App Windows**.
- Opcional para validación adicional:
  - `nuget.exe`
  - PowerShell 7+

## 5. Cómo ejecutar localmente

### Opción Visual Studio 2022

1. Abrir `MachSoft.PrivateNuGetFeed.sln`.
2. Establecer `MachSoft.PrivateNuGetFeed.Web` como proyecto de inicio.
3. Restaurar paquetes.
4. Ejecutar el proyecto.
5. Abrir:
   - `https://localhost:7053/`
   - `https://localhost:7053/v3/index.json`

### Opción CLI

```bash
dotnet restore MachSoft.PrivateNuGetFeed.sln
dotnet build MachSoft.PrivateNuGetFeed.sln
dotnet run --project src/MachSoft.PrivateNuGetFeed.Web
```

### Configuración local por defecto

- URL portal sugerida: `https://localhost:7053`
- API key desarrollo: `dev-machsoft-private-feed-key`
- Source name: `MachSoftPrivate`
- Feed v3: `https://localhost:7053/v3/index.json`

## 6. Cómo publicar en Azure App Service Windows

1. Crear una **Web App Windows** en Azure App Service.
2. Seleccionar **.NET 8 (LTS)** como stack del sitio.
3. Publicar el proyecto `src/MachSoft.PrivateNuGetFeed.Web` desde Visual Studio o con `dotnet publish`.
4. En Azure, abrir **Settings > Environment variables**.
5. Configurar los App Settings necesarios.
6. Reiniciar la aplicación.
7. Validar portal y feed con las rutas documentadas.

### Publicación por CLI

```bash
dotnet publish src/MachSoft.PrivateNuGetFeed.Web/MachSoft.PrivateNuGetFeed.Web.csproj -c Release -o .\artifacts\publish
```

El contenido publicado en `artifacts\publish` puede desplegarse en el App Service mediante Zip Deploy o el flujo de publicación de Visual Studio.

## 7. Cómo configurar App Settings

Configura estos valores en **Azure App Service > Environment variables / App Settings**.

### Portal

- `Portal__CompanyName`
  - Ejemplo: `MachSoft`
- `Portal__PortalTitle`
  - Ejemplo: `MachSoft Private Feed`
- `Portal__PortalSubtitle`
  - Ejemplo: `Repositorio interno de paquetes NuGet`
- `Portal__InternalUseBadgeText`
  - Ejemplo: `Uso interno exclusivo`
- `Portal__PortalVersion`
  - Ejemplo: `v1.0.0`
- `Portal__FooterUsageText`
  - Ejemplo: `Herramienta interna de ingeniería para consumo y publicación controlada de paquetes.`
- `Portal__FeedOwnerContact`
  - Ejemplo: `platform@machsoft.local`
- `Portal__PublicBaseUrl`
  - Ejemplo: `https://machsoft-private-feed.azurewebsites.net`
  - Si se omite, el portal intenta construir la URL desde la request actual.

### Feed

- `Feed__SourceName`
  - Ejemplo: `MachSoftPrivate`
- `Feed__ApiKey`
  - Ejemplo: `__REAL_SECRET__`
  - **No** dejar un valor real dentro del repositorio.
  - Puede sustituirse por una **Key Vault reference** de Azure App Service.
- `Feed__PackageStoragePath`
  - Desarrollo local: `App_Data/Packages`
  - Azure App Service Windows: `D:\home\data\MachSoft.PrivateNuGetFeed\Packages`
- `Feed__DatabasePath`
  - Desarrollo local: `App_Data/Data/baget.db`
  - Azure App Service Windows: `D:\home\data\MachSoft.PrivateNuGetFeed\baget.db`

## 8. Cómo configurar el feed

La configuración funcional del feed se deriva desde la sección `Feed` y se traduce al arranque a la configuración efectiva de BaGet:

- `BaGet:ApiKey`
- `BaGet:Database:Type = Sqlite`
- `BaGet:Database:ConnectionString = Data Source=<ruta_db>`
- `BaGet:Search:Type = Database`
- `BaGet:Storage:Type = FileSystem`
- `BaGet:Storage:Path = <ruta_paquetes>`
- `BaGet:RunMigrationsAtStartup = true`

### Qué hace esto en la práctica

- crea y migra la base SQLite al arrancar,
- guarda los paquetes en una carpeta configurable,
- expone el service index v3 real,
- protege la publicación de paquetes mediante API key.

## 9. Cómo subir paquetes

### Dotnet CLI

```bash
dotnet nuget push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg --source "https://__APP_SERVICE_URL__/v3/index.json" --api-key __API_KEY__
```

### NuGet.exe

```powershell
nuget.exe push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg __API_KEY__ -Source "https://__APP_SERVICE_URL__/v3/index.json"
```

> El service index v3 referencia internamente el endpoint de push real `/api/v2/package`, por lo que `dotnet nuget push` puede seguir usando la URL del source v3.

## 10. Cómo consumir paquetes

### Registrar el source

```bash
dotnet nuget add source "https://__APP_SERVICE_URL__/v3/index.json" --name MachSoftPrivate
```

### Instalar un paquete

```bash
dotnet add package MachSoft.Template.Core --source "https://__APP_SERVICE_URL__/v3/index.json"
```

> Aunque registres un alias con `dotnet nuget add source`, el flujo más determinista para `dotnet add package --source` es usar directamente la URL del feed.

### Restaurar usando el feed

```bash
dotnet restore --source "https://__APP_SERVICE_URL__/v3/index.json"
```

### Visual Studio

Configurar el mismo source en:

- **Tools**
- **NuGet Package Manager**
- **Package Sources**

## 11. Rutas disponibles

- `/` → portal corporativo.
- `/v3/index.json` → service index del feed.
- `/api/v2/package` → publicación de paquetes.
- `/v3/search` → búsqueda.
- `/v3/registration` → registro/metadatos.
- `/v3/package` → descarga de contenido.

## 12. Notas de seguridad básicas

- No guardar API keys reales en `appsettings.json` versionado.
- Configurar `Feed__ApiKey` en App Service como secreto de entorno.
- Considerar **Key Vault references** para el secreto del push si la organización ya usa Azure Key Vault.
- El push queda protegido por API key; no se deja abierto por defecto.
- Esta base no incorpora aún autenticación de usuarios finales para lectura del feed. El hardening posterior debe resolverse a nivel de App Service, red o reverse proxy corporativo.

## 13. Cómo restringir acceso en Azure App Service como hardening posterior

Opciones recomendadas, según el nivel de madurez interna requerido:

1. **Authentication / Easy Auth con Microsoft Entra ID**
   - útil para proteger el portal humano,
   - puede requerir pruebas cuidadosas si se desea mantener clientes automatizados de NuGet.

2. **Access Restrictions por IP o red corporativa**
   - apropiado para entornos internos conectados por VPN, ExpressRoute o rangos fijos.

3. **Private Endpoint o integración privada**
   - recomendable cuando el feed debe quedar totalmente fuera de Internet pública.

4. **Separar consumo y publicación**
   - mantener lectura abierta solo a red corporativa y endurecer push con IP restrictions adicionales o automatización dedicada.

## 14. Limitaciones conocidas de la solución

- **BaGet no es nuget.org**: no incluye por sí solo workflows avanzados de moderación, aprobación o multi-tenancy.
- **SQLite** es adecuada para un escenario interno simple o inicial, pero no es la elección ideal para cargas empresariales altas o múltiples instancias concurrentes.
- **Almacenamiento en disco local de App Service** funciona para un escenario sencillo, pero una evolución futura razonable puede mover paquetes a Azure Blob Storage y metadatos a una base gestionada si crece la criticidad.
- **Autenticación de lectura** no se implementa en esta base para no interferir con clientes NuGet sin definir antes una estrategia corporativa clara.

## 15. Pasos exactos para publicar

1. Ejecutar localmente:
   ```bash
   dotnet restore MachSoft.PrivateNuGetFeed.sln
   dotnet build MachSoft.PrivateNuGetFeed.sln
   dotnet run --project src/MachSoft.PrivateNuGetFeed.Web
   ```
2. Validar `GET /` y `GET /v3/index.json` localmente.
3. Publicar el proyecto:
   ```bash
   dotnet publish src/MachSoft.PrivateNuGetFeed.Web/MachSoft.PrivateNuGetFeed.Web.csproj -c Release -o .\artifacts\publish
   ```
4. Crear o reutilizar un **Azure App Service Windows** con stack **.NET 8**.
5. Desplegar el contenido de `artifacts\publish`.
6. Configurar App Settings mínimos:
   - `Portal__PublicBaseUrl=https://__APP_SERVICE_URL__`
   - `Feed__ApiKey=__REAL_SECRET__`
   - `Feed__PackageStoragePath=D:\home\data\MachSoft.PrivateNuGetFeed\Packages`
   - `Feed__DatabasePath=D:\home\data\MachSoft.PrivateNuGetFeed\baget.db`
7. Reiniciar la aplicación.
8. Validar portal y feed:
   - `https://__APP_SERVICE_URL__/`
   - `https://__APP_SERVICE_URL__/v3/index.json`
9. Registrar el source:
   ```bash
   dotnet nuget add source "https://__APP_SERVICE_URL__/v3/index.json" --name MachSoftPrivate
   ```
10. Publicar un paquete de prueba:
   ```bash
   dotnet nuget push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg --source "https://__APP_SERVICE_URL__/v3/index.json" --api-key __API_KEY__
   ```
11. Instalar el paquete desde otro proyecto:
   ```bash
   dotnet add package MachSoft.Template.Core --source "https://__APP_SERVICE_URL__/v3/index.json"
   ```

## 16. Comandos de prueba

### Build y ejecución

```bash
dotnet build MachSoft.PrivateNuGetFeed.sln
dotnet run --project src/MachSoft.PrivateNuGetFeed.Web
```

### Validación del portal

```bash
curl -I https://localhost:7053/
curl https://localhost:7053/
```

### Validación del feed

```bash
curl https://localhost:7053/v3/index.json
```

### Registrar source

```bash
dotnet nuget add source "https://__APP_SERVICE_URL__/v3/index.json" --name MachSoftPrivate
```

### Publicar paquete

```bash
dotnet nuget push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg --source "https://__APP_SERVICE_URL__/v3/index.json" --api-key __API_KEY__
```

### Consumir paquete

```bash
dotnet add package MachSoft.Template.Core --source "https://__APP_SERVICE_URL__/v3/index.json"
```

## 17. Rutas esperadas

- `https://__APP_SERVICE_URL__/` → portal corporativo MachSoft.
- `https://__APP_SERVICE_URL__/v3/index.json` → service index del feed.
- `https://__APP_SERVICE_URL__/api/v2/package` → push de paquetes.
- `https://__APP_SERVICE_URL__/v3/search` → búsqueda de paquetes.
- `https://__APP_SERVICE_URL__/v3/registration` → registro/metadatos de paquetes.
- `https://__APP_SERVICE_URL__/v3/package` → descarga de contenido.
