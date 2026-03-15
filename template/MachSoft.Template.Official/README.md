# MachSoft.Template.Official

Template corporativo oficial para generar aplicaciones Blazor Server con shell/layout MachSoft y consumo de `MachSoft.Template.Core`.

## Estado de release interna
- Versión baseline: **`v1.0.0-internal`**.
- Short name: **`machsoft-app`**.
- Propósito: bootstrap repetible de app nueva bajo estándar MachSoft.

## Instalación y actualización del template

### Instalar
```bash
dotnet new install ./template/MachSoft.Template.Official
```

### Reinstalar/actualizar
```bash
dotnet new uninstall ./template/MachSoft.Template.Official
dotnet new install ./template/MachSoft.Template.Official
```

## Crear app nueva
```bash
dotnet new machsoft-app -n MyCompany.App -o ./MyCompany.App --CorePackageVersion 1.0.0-internal
```

## Parámetros
- `--CorePackageVersion`: versión del paquete `MachSoft.Template.Core` que quedará referenciada en la app generada.

## Qué genera exactamente
- App Blazor Server mínima para adopción corporativa.
- Referencia a `MachSoft.Template.Core` vía `PackageReference`.
- Shell corporativo y theming base (light/dark) ya cableados.
- Páginas iniciales de operación: `/`, `/operations`, `/settings`.

## Wiring que deja resuelto
- Registro de servicios/render mode base de Blazor Server.
- Estructura de layout y navegación inicial.
- Inclusión de assets `_content/MachSoft.Template.Core/*`.
- Composición inicial con componentes `Mx*` para extender funcionalidad.

## Qué debe hacer el equipo luego de generar
1. Configurar source NuGet interno (o local temporal) para resolver `MachSoft.Template.Core`.
2. Ejecutar `dotnet restore`, `dotnet build -c Release`, `dotnet run`.
3. Personalizar branding y navegación del host sin mover lógica de negocio al Core.
4. Mantener contratos `Mx*` para desarrollo nuevo.

## Qué no debe esperar del template
- No incluye `/showcase`, `/demo`, `/wasm-demo`.
- No incluye lógica de dominio ni integraciones corporativas específicas.
- No reemplaza la guía de release/checklist operativa del repositorio.
