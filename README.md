# MachSoft.PrivateNuGetFeed

Solución ASP.NET MVC 5 sobre .NET Framework 4.8 para alojar un feed privado de NuGet usando **NuGet.Server** en **Azure App Service Windows** e IIS clásico, con una separación clara entre portal humano (`/`) y feed técnico (`/nuget`).

> Esta solución está pensada para un **feed privado interno sencillo**, mantenible y publicable. No pretende sustituir una galería empresarial completa con workflows avanzados de gobernanza, auditoría o multi-tenant.

## 1. Descripción del proyecto

`MachSoft.PrivateNuGetFeed` proporciona dos superficies complementarias:

- **Portal corporativo en la raíz `/`** para que los equipos consulten comandos, flujo operativo y notas internas.
- **Feed privado real en `/nuget`** respaldado por `NuGet.Server`, compatible con `dotnet CLI`, `nuget.exe` y Visual Studio.

La aplicación está preparada para ejecutarse localmente en Visual Studio y para publicarse en **Azure App Service Windows** sin Docker, sin Linux y sin contenedores.

## 2. Arquitectura funcional

- **ASP.NET MVC 5 / .NET Framework 4.8** como host principal.
- **NuGet.Server** como backend del feed; no se reimplementa el protocolo NuGet.
- **Portal visual desacoplado** de los endpoints del feed.
- **Configuración sensible por App Settings** para URL base, API key de push y ruta del repositorio de paquetes.
- **Repositorio de paquetes persistente** configurable para evitar sobrescritura durante despliegues del sitio.

### Superficies publicadas

- `https://<sitio>/` → portal corporativo.
- `https://<sitio>/nuget` → feed técnico.

## 3. Prerrequisitos

- Windows con **Visual Studio 2022** o superior con la carga de trabajo **ASP.NET and web development**.
- **.NET Framework 4.8 Developer Pack**.
- Acceso a Internet para restaurar paquetes NuGet al compilar por primera vez.
- Una suscripción de Azure con un **App Service Plan Windows** y un **Web App** Windows.
- `dotnet SDK` actual para validar consumo y publicación desde CLI.
- Opcional: `nuget.exe` si se desea validar también con el cliente clásico.

## 4. Cómo ejecutar localmente

1. Abrir `MachSoft.PrivateNuGetFeed.sln` en Visual Studio.
2. Ejecutar la restauración de paquetes NuGet.
3. Verificar que `packagesPath` apunta a `~/App_Data/Packages` para desarrollo local.
4. Ejecutar la aplicación con IIS Express o Local IIS.
5. Abrir las rutas:
   - `https://localhost:<puerto>/`
   - `https://localhost:<puerto>/nuget`

### Secuencia sugerida en consola de Visual Studio Developer Prompt

```powershell
nuget restore .\MachSoft.PrivateNuGetFeed.sln
msbuild .\MachSoft.PrivateNuGetFeed.sln /p:Configuration=Release
```

## 5. Cómo publicar en Azure App Service Windows

1. Crear un **Azure App Service Windows** con **.NET Framework 4.8**.
2. Publicar el proyecto `src/MachSoft.PrivateNuGetFeed.Web` desde Visual Studio mediante **Web Deploy** o **Zip Deploy**.
3. Confirmar que la publicación usa configuración **Release**.
4. Tras la publicación, ir a **Settings > Environment variables / App Settings** del App Service.
5. Configurar `apiKey`, `packagesPath` y, si se desea fijar la URL base, `PortalBaseUrl`.
6. Reiniciar el App Service.
7. Validar portal y feed antes de habilitarlo para otros equipos.

## 6. Cómo configurar App Settings

La solución deja estos valores listos para mantenimiento manual:

- `PortalBaseUrl`
  - Uso: URL pública que se mostrará en los comandos del portal.
  - Ejemplo: `https://machsoft-private-feed.azurewebsites.net`
  - Si no se configura, el portal intenta inferirla desde la request actual.

- `PortalVersion`
  - Uso: versión visible en footer y bloque de resumen.
  - Ejemplo: `v1.0.0`

- `apiKey`
  - Uso: API key compartida para `dotnet nuget push` y `nuget.exe push`.
  - Nunca dejar el valor real en código fuente.
  - Puede apuntar a un **Azure Key Vault reference** si la organización ya usa ese patrón.

- `packagesPath`
  - Uso: ruta física o virtual del repositorio de paquetes.
  - Desarrollo local recomendado: `~/App_Data/Packages`
  - Azure App Service Windows recomendado: `D:\home\data\MachSoft.PrivateNuGetFeed\Packages`

- `requireApiKey`
  - Uso: obliga a proteger el push.
  - Valor esperado: `true`

## 7. Cómo configurar el feed

El feed técnico se sirve en `/nuget` con `NuGet.Server`. La configuración clave está en `Web.config`:

- `requireApiKey=true`
- `apiKey=__API_KEY__`
- `packagesPath=~/App_Data/Packages` en local
- `packagesPath=D:\home\data\MachSoft.PrivateNuGetFeed\Packages` en publicación Release

### Consideraciones operativas del repositorio de paquetes

- **No** se recomienda usar una carpeta bajo `wwwroot` o una carpeta que pueda sobrescribirse con el despliegue.
- En **Azure App Service Windows**, usar `D:\home\data\MachSoft.PrivateNuGetFeed\Packages` separa el repositorio del contenido desplegado del sitio.
- Si se limpia el contenido del sitio durante una publicación, el repositorio persistente seguirá existiendo fuera de la carpeta del portal.

## 8. Cómo subir paquetes

### Dotnet CLI

```powershell
dotnet nuget push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg --source "https://__APP_SERVICE_URL__/nuget" --api-key __API_KEY__
```

### NuGet.exe

```powershell
nuget.exe push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg __API_KEY__ -Source "https://__APP_SERVICE_URL__/nuget"
```

Recomendaciones:

- Mantener `allowOverrideExistingPackageOnPush=false` salvo necesidad excepcional.
- Aplicar versionado semántico.
- Publicar primero un paquete de prueba no crítico.

## 9. Cómo consumir paquetes

### Registrar el source

```powershell
dotnet nuget add source "https://__APP_SERVICE_URL__/nuget" --name MachSoftPrivate
```

### Instalar desde el source registrado

```powershell
dotnet add package MachSoft.Template.Core --source MachSoftPrivate
```

### Restaurar explícitamente usando el feed

```powershell
dotnet restore --source "https://__APP_SERVICE_URL__/nuget"
```

Visual Studio puede usar la misma URL en **Tools > NuGet Package Manager > Package Sources**.

## 10. Rutas disponibles

- `/` → portal corporativo.
- `/Home/Index` → home MVC equivalente.
- `/nuget` → feed técnico de NuGet.Server.
- `/nuget/Packages` → listado OData del feed.

## 11. Notas de seguridad básicas

- El **push** debe permanecer protegido mediante `apiKey`.
- El **feed** no debería exponerse de forma anónima a Internet si contiene paquetes internos.
- Esta solución deja la aplicación preparada para combinarse con:
  - **Authentication / Authorization de App Service**.
  - **IP Restrictions** o acceso por red corporativa.
  - **Private endpoints** o conectividad corporativa adicional según la plataforma.
- El hardening de acceso en Azure App Service es una tarea **posterior y explícita** de operación.

## 12. Cómo restringir acceso por IP en Azure App Service como hardening manual posterior

1. Abrir el recurso App Service en Azure Portal.
2. Ir a **Networking**.
3. Abrir **Access Restrictions**.
4. Definir reglas **Allow** para rangos corporativos o direcciones de VPN.
5. Añadir una regla final **Deny** para tráfico no autorizado si el modelo de operación lo requiere.
6. Revalidar acceso al portal y al feed desde una red autorizada.

> También es válido combinar esto con la autenticación integrada del App Service para no dejar el feed accesible de forma pública.

## 13. Limitaciones conocidas de la solución

- `NuGet.Server` expone un feed simple; no ofrece por sí solo catálogo empresarial avanzado, workflow de aprobación, reporting o multi-tenant.
- La API key es compartida por el feed; no hay trazabilidad por usuario dentro de `NuGet.Server` sin capas adicionales.
- El entorno de esta entrega no compila proyectos `ASP.NET MVC 5` sobre `.NET Framework 4.8` porque carece de Visual Studio Build Tools para Web Applications, por lo que la validación de compilación debe ejecutarse en Windows.
- El feed está pensado para operación interna sencilla; si se requieren políticas complejas, retención avanzada o firma obligatoria, será necesario ampliar la plataforma.

## 14. Pasos exactos para publicar

1. Crear el App Service Windows destino.
2. Confirmar que el runtime del sitio es **.NET Framework 4.8**.
3. Abrir `MachSoft.PrivateNuGetFeed.sln` en Visual Studio.
4. Ejecutar restauración NuGet.
5. Compilar en `Release`.
6. Publicar `MachSoft.PrivateNuGetFeed.Web` al App Service Windows.
7. En Azure, configurar los App Settings:
   - `apiKey` = valor real corporativo
   - `packagesPath` = `D:\home\data\MachSoft.PrivateNuGetFeed\Packages`
   - `PortalBaseUrl` = `https://<tu-app-service>.azurewebsites.net`
   - `PortalVersion` = versión operativa deseada
8. Reiniciar el sitio.
9. Navegar a `https://<tu-app-service>.azurewebsites.net/`.
10. Navegar a `https://<tu-app-service>.azurewebsites.net/nuget`.
11. Registrar el source privado con `dotnet nuget add source`.
12. Publicar un paquete de prueba.
13. Instalar ese paquete desde un proyecto de prueba.
14. Aplicar hardening de acceso por IP o autenticación del App Service antes de abrir el feed a equipos más amplios.

## 15. Comandos de prueba

### Portal y feed

```powershell
curl -I https://__APP_SERVICE_URL__/
curl -I https://__APP_SERVICE_URL__/nuget
curl -I https://__APP_SERVICE_URL__/nuget/Packages
```

### Registrar source

```powershell
dotnet nuget add source "https://__APP_SERVICE_URL__/nuget" --name MachSoftPrivate
```

### Consumir paquete

```powershell
dotnet add package MachSoft.Template.Core --source MachSoftPrivate
```

### Publicar paquete

```powershell
dotnet nuget push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg --source "https://__APP_SERVICE_URL__/nuget" --api-key __API_KEY__
```

### Validación de no interferencia

```powershell
curl -I https://__APP_SERVICE_URL__/
curl -I https://__APP_SERVICE_URL__/nuget
dotnet add package MachSoft.Template.Core --source MachSoftPrivate
dotnet nuget push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg --source "https://__APP_SERVICE_URL__/nuget" --api-key __API_KEY__
```

## 16. Rutas esperadas

- Portal principal: `https://__APP_SERVICE_URL__/`
- Home MVC: `https://__APP_SERVICE_URL__/Home/Index`
- Feed privado: `https://__APP_SERVICE_URL__/nuget`
- Listado del feed: `https://__APP_SERVICE_URL__/nuget/Packages`

## Validación funcional obligatoria después del despliegue

### 1. Portal

- Ejecutar `GET /`.
- Confirmar render correcto del portal, secciones visibles y comandos con URL del feed.

### 2. Feed

- Abrir `/nuget`.
- Confirmar respuesta válida del feed de `NuGet.Server`.
- Abrir `/nuget/Packages` para validar el endpoint OData.

### 3. Consumo

```powershell
dotnet nuget add source "https://__APP_SERVICE_URL__/nuget" --name MachSoftPrivate
dotnet add package MachSoft.Template.Core --source MachSoftPrivate
```

### 4. Publicación

```powershell
dotnet nuget push .\artifacts\MachSoft.Template.Core.1.0.0.nupkg --source "https://__APP_SERVICE_URL__/nuget" --api-key __API_KEY__
```

### 5. Validación de no interferencia

- Abrir `https://__APP_SERVICE_URL__/` y comprobar que la home responde correctamente.
- Abrir `https://__APP_SERVICE_URL__/nuget` y comprobar que el feed sigue operativo.
- Repetir la consulta al portal tras publicar un paquete para validar convivencia sin interferencias.
