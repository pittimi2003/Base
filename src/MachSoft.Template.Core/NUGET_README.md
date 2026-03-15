# MachSoft.Template.Core

Paquete NuGet reusable del MachSoft Design System para Blazor Server y Blazor WebAssembly.

## Estado de release interna
- Versión base actual: **`1.0.0-internal`**.
- Estabilidad declarada: **estable para adopción interna controlada**.
- Alcance real: runtime reusable (`Mx*`, layout, assets tokenizados y script de tema).

## Qué incluye
- Componentes `Mx*` (Foundation, Forms, Navigation/Overlays, Data display, Inputs, Data).
- Layout reusable (`MainLayout` y shell `AppShell/AppHeader/AppNavigation/AppFooter`).
- Static assets en `_content/MachSoft.Template.Core/css/template/*`.
- Script de tema `_content/MachSoft.Template.Core/js/theme.js`.

## Qué no incluye
- Hosts de arranque (`template/MachSoft.Template.Starter*`).
- Template instalable (`template/MachSoft.Template.Official`).
- Apps de referencia (`samples/*`).
- Lógica de negocio o integraciones de infraestructura.

## Flujo operativo mínimo del paquete

### 1) Generar paquete
```bash
dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o ./.artifacts/local-nuget
```

### 2) Publicación inicial recomendada
- Publicar `MachSoft.Template.Core.<version>.nupkg` en feed interno corporativo (Azure Artifacts, Nexus, GitHub Packages, etc.).
- Mientras el feed corporativo no esté listo, usar un feed local de carpeta compartida.

### 3) Consumo desde app corporativa
1. Configurar source NuGet (feed interno o local).
2. Referenciar paquete en `.csproj`:

```xml
<ItemGroup>
  <PackageReference Include="MachSoft.Template.Core" Version="1.0.0-internal" />
</ItemGroup>
```

3. Incluir assets en host (Server o WASM):
   - `_content/MachSoft.Template.Core/css/template/tokens.css`
   - `_content/MachSoft.Template.Core/css/template/base.css`
   - `_content/MachSoft.Template.Core/css/template/layout.css`
   - `_content/MachSoft.Template.Core/css/template/components.css`
   - `_content/MachSoft.Template.Core/css/template/utilities.css`
   - `_content/MachSoft.Template.Core/js/theme.js`

### 4) Prerrequisitos mínimos
- .NET SDK 8.
- App Blazor Server o Blazor WASM.
- Source NuGet configurado con acceso al paquete.

### 5) Actualizar versión de paquete
1. Cambiar `Version` del `PackageReference`.
2. Ejecutar `dotnet restore` y `dotnet build -c Release`.
3. Validar smoke de rutas y tema (`/showcase`, `/demo` o `/wasm-demo` según host).

### 6) Si el feed no está configurado
Agregar `nuget.config` de proyecto con source local:

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
    <add key="MachSoftLocal" value="/ruta/a/nupkg" />
  </packageSources>
</configuration>
```

## Convención de versionado inmediata
- `MAJOR.MINOR.PATCH-internal`.
- `PATCH-internal`: corrección compatible sin romper contratos.
- `MINOR-internal`: ampliación compatible (nuevas capacidades no disruptivas).
- `MAJOR-internal`: cambio incompatible o de contrato público.
