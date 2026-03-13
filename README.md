# MachSoft Template

Starter corporativo para proyectos Blazor bajo convención MachSoft, con variantes **Server** y **WebAssembly** sobre una base visual común.

## Versión interna
- Versión actual del template: **`v1.0.0-internal`**.
- Convención: versión semántica + sufijo `-internal` para consumo interno controlado.

## Estructura
- `MachSoft.Template.sln`
- `docs/`: arquitectura, migración y guía de uso.
- `src/MachSoft.Template.Core`: base reusable (layout, foundation components, estilos, páginas base).
- `template/MachSoft.Template.Starter`: starter principal en Blazor Server.
- `template/MachSoft.Template.Starter.Wasm`: starter equivalente en Blazor WebAssembly.
- `samples/MachSoft.Template.SampleApp`: demo funcional de referencia.
- `samples/MachSoft.Template.AdoptionValidationApp`: app de validación de adopción (simula proyecto nuevo).

## Proyectos
- **MachSoft.Template.Core**: Razor Class Library reusable compartida por Server/WASM.
- **MachSoft.Template.Starter**: starter productivo mínimo (Server).
- **MachSoft.Template.Starter.Wasm**: starter productivo mínimo (WASM standalone).
- **MachSoft.Template.SampleApp**: showcase funcional de referencia (Server).
- **MachSoft.Template.AdoptionValidationApp**: validación de adopción real con branding y páginas propias (Server).

## Qué comparten Server y WASM
- `MainLayout` corporativo.
- Componentes foundation (`PageContainer`, `BaseCard`, `AppMenuTile`).
- Páginas base (`/`, `/showcase`).
- Sistema de estilos (`tokens.css`, `base.css`, `layout.css`, `components.css`, `utilities.css`).

## Ejecutar
> Requiere .NET SDK 8+

```bash
dotnet build MachSoft.Template.sln

# Starter Server
dotnet run --project template/MachSoft.Template.Starter

# Starter WASM
dotnet run --project template/MachSoft.Template.Starter.Wasm

# Sample Server
dotnet run --project samples/MachSoft.Template.SampleApp

# Adoption validation app
dotnet run --project samples/MachSoft.Template.AdoptionValidationApp
```

## Uso como base corporativa
1. Clonar la solución.
2. Elegir `Starter` (Server) o `Starter.Wasm` según tipo de aplicación.
3. Mantener componentes y estilo compartido en `MachSoft.Template.Core`.
4. Usar `SampleApp` para validar cambios de foundation antes de adopción.

## Guía de adopción
- Flujo operativo completo y checklist de arranque: `docs/ADOPTION_GUIDE.md`.


## Validación de adopción real
- Referencia implementada: `samples/MachSoft.Template.AdoptionValidationApp`.
- Simula un equipo que adopta `Starter` y personaliza branding, navegación y páginas (`/operations`, `/settings`) usando Foundation del Core.
