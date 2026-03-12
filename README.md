# MachSoft Template

Starter corporativo para proyectos Blazor bajo convención MachSoft, con variantes **Server** y **WebAssembly** sobre una base visual común.

## Estructura
- `MachSoft.Template.sln`
- `docs/`: arquitectura, migración y guía de uso.
- `src/MachSoft.Template.Core`: base reusable (layout, foundation components, estilos, páginas base).
- `template/MachSoft.Template.Starter`: starter principal en Blazor Server.
- `template/MachSoft.Template.Starter.Wasm`: starter equivalente en Blazor WebAssembly.
- `samples/MachSoft.Template.SampleApp`: demo funcional de referencia.

## Proyectos
- **MachSoft.Template.Core**: Razor Class Library reusable compartida por Server/WASM.
- **MachSoft.Template.Starter**: starter productivo mínimo (Server).
- **MachSoft.Template.Starter.Wasm**: starter productivo mínimo (WASM standalone).
- **MachSoft.Template.SampleApp**: showcase funcional de referencia (Server).

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
```

## Uso como base corporativa
1. Clonar la solución.
2. Elegir `Starter` (Server) o `Starter.Wasm` según tipo de aplicación.
3. Mantener componentes y estilo compartido en `MachSoft.Template.Core`.
4. Usar `SampleApp` para validar cambios de foundation antes de adopción.
