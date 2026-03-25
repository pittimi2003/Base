# Migration Report

## Status

The repository now includes a dedicated .NET 8 productization layout for MachSoft corporate templates.

## Delivered changes

- Added a dedicated solution file, `MachSoft.Templates.sln`, for the active template productization artifacts.
- Kept `MachSoft.Template.Core` as the reusable baseline package.
- Added two separate official `dotnet new` template packages:
  - `MachSoft.Template.Official.Server`
  - `MachSoft.Template.Official.Wasm`
- Added placeholder-only private feed configuration with no secrets.
- Added packaging scripts and documentation for build, pack, install, and internal feed consumption.

## Conservative assumptions made

1. The shared package version starts at `1.0.0-internal`.
2. Generated applications restore `MachSoft.Template.Core` from a NuGet feed rather than a project reference.
3. Root namespace override is treated as an optional template parameter, while project name remains the primary generated identifier.
4. Template content is intentionally minimal, production-oriented, and free of business logic.


## Incremento: separación Core / Core.Control / Showcase

- Added `MachSoft.Template.Core.Control` as a NuGet-ready Razor Class Library as the distributable base for the official `Mx*` catalog roadmap (incremental, not complete).
- Added `MachSoft.Template.Core.Control.Showcase` as an isolated host to validate catalog rendering and interactions.
- Preserved `MachSoft.Template.Core` as base design system layer (tokens, theme, shared primitives).
- Registered both projects in `MachSoft.Templates.sln` and wired references: `Core.Control -> Core`, `Showcase -> Core.Control`.
- Established visible light/dark validation path in Showcase without coupling demo-only assets into the package payload.


## Consolidation fixes (post-initial iteration)

- Renamed Showcase route/page from `/fundations` to `/foundations` for consistent naming.
- Moved roadmap model/service/component out of `MachSoft.Template.Core.Control` into `MachSoft.Template.Core.Control.Showcase` to keep NuGet payload focused on distributable assets/contracts.
- Kept package and showcase separation explicit before starting new control-family implementations.


## Registro 2026-03-24 — adopción Core.Control lote 1
- Se introduce primera implementación oficial de controles públicos en `MachSoft.Template.Core.Control`.
- Se mantiene separación entre paquete distribuible (RCL) y host de demostración (Showcase).
- No se añadieron dependencias externas; la implementación se apoya en Blazor + CSS tokenizado.

## Registro 2026-03-25 — hardening lote 1
- Se corrigieron debilidades de accesibilidad/estado en Actions, Feedback y Overlays.
- Se documentaron límites reales de overlays para evitar sobreventa funcional antes de avanzar a nuevas familias.

## Registro 2026-03-25 — familia List / ListBox / Avatar / Chip
- Se implementó en `MachSoft.Template.Core.Control` la familia inicial de listas e identidad compacta: `MxList`, `MxListBox`, `MxAvatar`, `MxChip`.
- Se añadieron modelos de apoyo (`MxListItem`, `MxListBoxOption`) y variantes (`MxAvatarSize`, `MxAvatarShape`, `MxChipVariant`) manteniendo API pública mínima.
- `MachSoft.Template.Core.Control.Showcase` incorpora la ruta `/families/listing` con ejemplos funcionales (default, selected, disabled, invalid, interactive, removable) para validación runtime/light-dark.
