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

1. The shared package version starts at `1.0.1-internal`.
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

## Registro 2026-03-25 — DataGrid enterprise controlado (fase inicial)
- `MxDataGrid` incorpora sorting básico, selección de filas, toolbar base, row actions y summary template sin inflar la API pública.
- `MxDataGridColumn` agrega metadatos mínimos para sort; se incorpora `MxDataGridSelectionMode` para mantener semántica clara de selección.
- Showcase `MachSoft.Template.Core.Control.Showcase` consolida `/families/data` como host runtime de validación funcional/visual de la nueva iteración.


## 2026-03-25 — Consolidación de Scheduling

Se incorpora `MxScheduler` en `MachSoft.Template.Core.Control` con contrato público inicial estable y validación funcional en `Core.Control.Showcase` (`/families/scheduling`).

Impacto de migración:
- no rompe componentes existentes,
- no introduce dependencias externas,
- mantiene compatibilidad arquitectónica con Blazor Server y WebAssembly al apoyarse en Razor + CSS tokenizado.

## Registro 2026-03-25 — ronda quirúrgica de saneamiento final
- Se eliminó deuda de contratos Mx* ambiguos entre Core y Core.Control mediante estrategia explícita de tipos compartidos vs exclusivos.
- Se corrigió integración documental del theming del shell Core (`theme.js` obligatorio para interop de `AppShell`) y se agregó fallback seguro a light mode si el script no está disponible.
- Se añadió malla E2E smoke transversal mínima por familias implementadas para detectar regresiones de render, interacción primaria, light/dark y errores runtime.



## Registro 2026-03-26 — cierre arquitectónico definitivo Core/Core.Control
- Se eliminó la superficie pública de controles `Mx*` en `MachSoft.Template.Core` (componentes y modelos de catálogo).
- Se consolidaron modelos/variantes `Mx*` en `MachSoft.Template.Core.Control.Models` como contrato único de catálogo.
- Se actualizaron templates oficiales para referenciar explícitamente `MachSoft.Template.Core.Control` además de `MachSoft.Template.Core`.
- Se actualizó documentación para dejar explícita la separación: Core=baseline técnico, Core.Control=catálogo oficial de controles.

- Se alineó `template-content` de Server/WASM al shell común de Core (`AppShell`) para corregir navegación cruda y garantizar comportamiento responsive/theming consistente.


## 2026-03-26 — Shell corporativo (AppShell)
- Se estandarizó `AppShell.razor` con `AppHeader.razor` fijo de 48px, `AppNavigation.razor` tipo drawer/offcanvas oculta por defecto y cierre por overlay/escape/hamburguesa/navegación.
- `@Body` se renderiza en `ms-shell__main` inmediatamente bajo el header (sin franja vacía artificial).
- `AppFooter.razor` permanece activo y ahora puede ocultarse mediante `ShowFooter` en los `MainLayout.razor` que consumen `AppShell`.
- Se explicitó el wiring de layout en Showcase, Official.Server y Official.Wasm para evitar resolver un layout distinto al esperado.

## Registro 2026-03-30 — Corrección de composición vertical en patrón grid
- Se eliminó la dependencia de `block-size: calc(100vh - 12rem)` en templates oficiales para la vista `/workspace/grid`.
- Se introdujeron layouts dedicados `GridWorkspaceLayout` (Server/Wasm) con `ShowFooter=false` para evitar conflicto visual entre footer global y barra inferior del workspace.
- Se ajustó el patrón CSS de la vista grid para usar altura útil completa del `main` y delegar el scroll al contenedor del datagrid.
- Showcase y templates quedaron alineados en estructura vertical: header shell + workspace full-height + barra inferior integrada en la propia vista.
