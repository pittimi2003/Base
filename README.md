# MachSoft.PrivateNuGetFeed

Solución moderna basada en **ASP.NET Core 8** para alojar un **feed privado de NuGet** con **BaGet** como motor del protocolo y un **portal corporativo MachSoft** desacoplado del feed técnico. Está preparada para ejecutarse localmente, abrirse en **Visual Studio 2022** y publicarse en **Azure App Service Windows** sin Docker, sin Linux obligatorio y sin stacks legacy de ASP.NET MVC 5 o .NET Framework.

> Esta solución está pensada como **feed privado interno** para consumo y publicación controlada de paquetes. No pretende reemplazar una galería empresarial del nivel de nuget.org con workflows avanzados de moderación, multi-tenant o gobierno de paquetes.

## 1. Descripción del proyecto

`MachSoft.PrivateNuGetFeed` ofrece dos superficies claramente separadas:

- **Portal humano en `/`** con branding MachSoft, comandos listos para copiar, guía rápida y notas de operación.
- **Feed técnico NuGet en `/v3/index.json` y `/api/v2/package`** servido por **BaGet**, manteniendo compatibilidad con `dotnet CLI`, `nuget.exe` y Visual Studio.

El portal está optimizado para que cualquier desarrollador entienda en segundos:

- cuál es la URL del feed,
- cómo registrar el source,
- cómo instalar paquetes,
- cómo publicar nuevas versiones,
- y dónde endurecer seguridad en Azure App Service Windows.

## 2. Arquitectura funcional

### Superficies expuestas

- `/` → portal corporativo de operación humana.
- `/v3/index.json` → service index NuGet v3.
- `/api/v2/package` → endpoint de publicación de paquetes.
- `/v3/search` → búsquedas de paquetes.
- `/v3/registration` → metadatos de paquetes.
- `/v3/package` → descarga de contenido de paquetes.

### Separación de responsabilidades

- **Portal visual**
  - Renderizado con **ASP.NET Core MVC**.
  - Layout corporativo sobrio y responsive.
  - CSS propio, JS mínimo para copiar comandos.
  - Sin mezclar vistas o layout con los endpoints del protocolo NuGet.

- **Feed técnico**
  - Integrado con **BaGet.Web**.
  - Persistencia mediante **SQLite** para metadatos.
  - Almacenamiento en disco configurable para paquetes `.nupkg`.
  - API key configurable para publicación.

### Estrategia de almacenamiento

- **Desarrollo local recomendado**
  - Base de datos: `App_Data/Data/baget.db`
  - Paquetes: `App_Data/Packages`

- **Azure App Service Windows recomendado**
  - Base de datos: `D:\home\data\MachSoft.PrivateNuGetFeed\baget.db`
  - Paquetes: `D:\home\data\MachSoft.PrivateNuGetFeed\Packages`

Esta estrategia separa el contenido persistente del feed del contenido publicado del portal, evitando mezclar paquetes con assets estáticos del sitio.

## 3. Stack y decisiones técnicas

### Stack elegido

- **.NET 8**
- **ASP.NET Core 8 MVC**
- **BaGet.Web 0.4.0-preview2**
- **BaGet.Database.Sqlite 0.4.0-preview2**
- **SQLite** para metadatos del feed
- **File system storage** para paquetes NuGet

### Decisiones técnicas adoptadas

1. **No usar ASP.NET Framework ni MVC 5**
   - El host es un proyecto SDK-style `Microsoft.NET.Sdk.Web` sobre `net8.0`.

2. **No usar NuGet.Server**
   - El protocolo NuGet no se reimplementa y tampoco se usa el stack legacy.
   - Se integra **BaGet** como implementación existente y moderna del feed.

3. **No usar Blazor**
   - Para el portal humano se eligió **MVC** por simplicidad, mantenimiento y claridad.

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

Configura estos valores en **Azure App Service > Environment variables / App Settings**:

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

La configuración funcional del feed se deriva desde la sección `Feed` y se traduce en tiempo de arranque a la configuración real de BaGet:

- `BaGet:ApiKey`
- `BaGet:Database:Type = Sqlite`
- `BaGet:Database:ConnectionString = Data Source=<ruta_db>`
- `BaGet:Search:Type = Database`
- `BaGet:Storage:Type = FileSystem`
- `BaGet:Storage:Path = <ruta_paquetes>`
- `BaGet:RunMigrationsAtStartup = true`

### Qué hace esto en la práctica

- crea y migra la base SQLite al arrancar,
- mantiene los paquetes en una carpeta configurable,
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
dotnet add package MachSoft.Template.Core --source MachSoftPrivate
```

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

- Mantener `Feed__ApiKey` únicamente en Azure App Settings o variables de entorno seguras.
- No reutilizar la API key de desarrollo en entornos compartidos.
- No exponer el feed a Internet abierta si contiene paquetes internos sensibles.
- Separar el almacenamiento persistente del feed del contenido desplegado del sitio.
- Aplicar **HTTPS only** en App Service.
- Considerar **Azure Key Vault references** para `Feed__ApiKey` cuando la organización ya tenga ese estándar.

## 13. Cómo restringir acceso en Azure App Service como hardening posterior

Esta solución queda lista para endurecimiento posterior sin cambiar arquitectura base.

### Recomendaciones de hardening

1. **App Service Authentication / Easy Auth**
   - Activar autenticación corporativa para proteger el portal y, si corresponde, el sitio completo.

2. **Access Restrictions**
   - Permitir solo IPs corporativas, VPN o agentes de build autorizados.

3. **Private networking**
   - Si la organización lo requiere, ubicar la Web App detrás de conectividad privada o controles de perímetro corporativos.

4. **Secret management**
   - Sustituir `Feed__ApiKey` por un Key Vault reference.

5. **Separación operativa**
   - Mantener agentes de CI/CD autorizados para `push` y auditar quién puede publicar paquetes.

## 14. Limitaciones conocidas de la solución

- **BaGet no es nuget.org**: no incluye de serie un marketplace empresarial completo con aprobación humana, reportes avanzados o multi-tenant.
- **API key compartida**: el mecanismo base de publicación se apoya en una API key configurada a nivel de aplicación, no en identidades finas por usuario.
- **SQLite es una elección pragmática**: funciona bien para un feed interno pequeño o mediano, pero si el volumen y concurrencia crecen mucho podría ser razonable evolucionar a otro backend compatible.
- **El portal es operativo, no una suite de administración**: la experiencia está centrada en consumo/publicación y documentación rápida, no en backoffice complejo.

## 15. Pasos exactos para publicar

1. Abrir `MachSoft.PrivateNuGetFeed.sln` en Visual Studio 2022.
2. Restaurar dependencias.
3. Compilar en `Release`.
4. Crear o seleccionar un **Azure App Service Windows** con stack **.NET 8**.
5. Publicar `MachSoft.PrivateNuGetFeed.Web` desde Visual Studio o ejecutar:

   ```bash
   dotnet publish src/MachSoft.PrivateNuGetFeed.Web/MachSoft.PrivateNuGetFeed.Web.csproj -c Release -o .\artifacts\publish
   ```

6. Subir la salida publicada al App Service.
7. En Azure App Service, configurar:
   - `Portal__PublicBaseUrl = https://<tu-app>.azurewebsites.net`
   - `Feed__ApiKey = <api-key-real>`
   - `Feed__PackageStoragePath = D:\home\data\MachSoft.PrivateNuGetFeed\Packages`
   - `Feed__DatabasePath = D:\home\data\MachSoft.PrivateNuGetFeed\baget.db`
   - opcionalmente `Portal__PortalVersion`, `Portal__FeedOwnerContact`, etc.
8. Reiniciar la Web App.
9. Navegar a `https://<tu-app>.azurewebsites.net/`.
10. Validar `https://<tu-app>.azurewebsites.net/v3/index.json`.
11. Registrar el source con `dotnet nuget add source`.
12. Publicar un paquete de prueba con `dotnet nuget push`.
13. Consumir el paquete publicado desde un proyecto de prueba.
14. Aplicar hardening adicional si el feed va a abrirse a más equipos.

## 16. Comandos de prueba

### Portal

```bash
curl -i https://__APP_SERVICE_URL__/
```

### Feed

```bash
curl -i https://__APP_SERVICE_URL__/v3/index.json
curl -i https://__APP_SERVICE_URL__/v3/search?q=MachSoft.Template.Core
```

### Registrar source

```bash
dotnet nuget add source "https://__APP_SERVICE_URL__/v3/index.json" --name MachSoftPrivate
```

### Consumir paquete

```bash
dotnet add package MachSoft.Template.Core --source MachSoftPrivate
```

### Publicar paquete

```bash
dotnet nuget push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg --source "https://__APP_SERVICE_URL__/v3/index.json" --api-key __API_KEY__
```

### Validación de no interferencia

```bash
curl -i https://__APP_SERVICE_URL__/
curl -i https://__APP_SERVICE_URL__/v3/index.json
dotnet nuget add source "https://__APP_SERVICE_URL__/v3/index.json" --name MachSoftPrivate
dotnet add package MachSoft.Template.Core --source MachSoftPrivate
```

## 17. Rutas esperadas

- Portal principal: `https://__APP_SERVICE_URL__/`
- Feed v3: `https://__APP_SERVICE_URL__/v3/index.json`
- Publicación: `https://__APP_SERVICE_URL__/api/v2/package`
- Búsqueda: `https://__APP_SERVICE_URL__/v3/search`
- Registro de metadatos: `https://__APP_SERVICE_URL__/v3/registration`
- Descarga de contenido: `https://__APP_SERVICE_URL__/v3/package`

---

## Archivos generados / actualizados

- `MachSoft.PrivateNuGetFeed.sln`
- `README.md`
- `src/MachSoft.PrivateNuGetFeed.Web/MachSoft.PrivateNuGetFeed.Web.csproj`
- `src/MachSoft.PrivateNuGetFeed.Web/Program.cs`
- `src/MachSoft.PrivateNuGetFeed.Web/appsettings.json`
- `src/MachSoft.PrivateNuGetFeed.Web/appsettings.Development.json`
- `src/MachSoft.PrivateNuGetFeed.Web/Properties/launchSettings.json`
- `src/MachSoft.PrivateNuGetFeed.Web/Controllers/HomeController.cs`
- `src/MachSoft.PrivateNuGetFeed.Web/Options/*`
- `src/MachSoft.PrivateNuGetFeed.Web/Models/*`
- `src/MachSoft.PrivateNuGetFeed.Web/Services/*`
- `src/MachSoft.PrivateNuGetFeed.Web/Views/**/*`
- `src/MachSoft.PrivateNuGetFeed.Web/wwwroot/css/site.css`
- `src/MachSoft.PrivateNuGetFeed.Web/wwwroot/js/site.js`
- `src/MachSoft.PrivateNuGetFeed.Web/App_Data/**/*`

## Explicación breve de la estructura

- `Program.cs` integra ASP.NET Core MVC + BaGet y resuelve rutas/configuración persistente.
- `Options/` concentra configuración tipada de portal y feed.
- `Services/` construye el contenido del portal y centraliza lógica de composición.
- `Controllers/` expone la home corporativa.
- `Views/` contiene layout, home y error.
- `wwwroot/` contiene CSS y JS mínimos del portal.
- `App_Data/` deja listas las ubicaciones locales de paquetes y SQLite.

## Decisiones técnicas tomadas y por qué

- **MVC en ASP.NET Core 8** para una UI clara, sobria y fácil de mantener.
- **BaGet** para no reimplementar el protocolo NuGet ni depender de stacks legacy.
- **SQLite + file storage** para ofrecer una solución publicable y simple de operar en App Service Windows.
- **Configuración tipada + App Settings** para separar secretos y parámetros de despliegue.
- **Portal y feed desacoplados** para que la UX humana no interfiera con los clientes NuGet.

## Pasos de validación tras desplegar

1. Abrir `GET /` y comprobar render del portal.
2. Abrir `GET /v3/index.json` y verificar que responde el service index.
3. Ejecutar `dotnet nuget add source` apuntando al service index publicado.
4. Ejecutar `dotnet nuget push` con una API key válida.
5. Ejecutar `dotnet add package` desde un proyecto de prueba.
6. Confirmar que el portal sigue respondiendo mientras el feed también responde correctamente.

## Rutas finales esperadas

- `/`
- `/v3/index.json`
- `/api/v2/package`
- `/v3/search`
- `/v3/registration`
- `/v3/package`

## Limitaciones conocidas reales

- No hay autenticación granular por usuario incorporada en el push base.
- No existe panel administrativo avanzado tipo galería corporativa completa.
- La solución está optimizada para una herramienta interna seria y evolutiva, no para convertirse de inmediato en un marketplace global de paquetes.
