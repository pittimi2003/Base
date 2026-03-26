# Architecture

## Overview

The repository is structured as a .NET 8 productization workspace for five active deliverables and one distribution concern:

- `MachSoft.Template.Core`: reusable Razor Class Library and NuGet package.
- `MachSoft.Template.Official.Server`: official `dotnet new` template package for Blazor Web App with Razor Components + Interactive Server rendering.
- `MachSoft.Template.Official.Wasm`: official `dotnet new` template package for Blazor WebAssembly.
- `MachSoft.Template.Core.Control`: official Mx* control catalog package (RCL) prepared for internal NuGet distribution.
- `MachSoft.Template.Core.Control.Showcase`: isolated validation host for catalog visual and functional checks.
- Private feed onboarding: placeholder configuration and operational documentation for internal distribution.

## Solution boundaries

### 1. Reusable baseline package

`src/MachSoft.Template.Core` is the shared UI/runtime dependency for generated applications.

Responsibilities:

- options and service registration
- lightweight reusable UI infrastructure (layout shell, navigation primitives and shared assets)
- shared corporate theme assets distributed as static web assets
- host-agnostic baseline with no business logic
- no embedded showcase/demo pages or legacy UI catalog surface

### 2. Official server template package

`src/MachSoft.Template.Official.Server` is a packaging project only.

Responsibilities:

- embed a complete `dotnet new` template in `template-content`
- expose metadata for internal template discovery
- produce a NuGet template package installable with `dotnet new install`

The generated app is a .NET 8 Blazor Web App configured for Razor Components + Interactive Server rendering and references `MachSoft.Template.Core` from NuGet.

### 3. Official WebAssembly template package

`src/MachSoft.Template.Official.Wasm` is a packaging project only.

Responsibilities:

- embed a standalone WebAssembly template in `template-content`
- expose separate template metadata for internal use
- produce a NuGet template package installable with `dotnet new install`

The generated app is a .NET 8 Blazor WebAssembly host that references `MachSoft.Template.Core` from NuGet.


### 4. Official control catalog package

`src/MachSoft.Template.Core.Control` is a distributable Razor Class Library.

Responsibilities:

- expose the official control catalog surface (`Mx*`) as it is implemented incrementally
- depend on `MachSoft.Template.Core` for design tokens and shared foundation
- publish static web assets for control-specific styling
- stay host-agnostic (compatible with Server and WebAssembly)
- keep showcase-only roadmap/navigation artifacts out of the distributable package

### 5. Showcase host (non-distributable)

`src/MachSoft.Template.Core.Control.Showcase` is an independent host used only to validate the catalog.

Responsibilities:

- visual/functional validation for light and dark themes
- category-based navigation to grow the catalog by families
- host roadmap metadata/presentation used only for validation
- avoid adding package payload into `MachSoft.Template.Core.Control`

## Packaging strategy

### Core packages

- `MachSoft.Template.Core` is packed directly from its SDK-style `.csproj` and can be published to any internal NuGet v3 source.
- `MachSoft.Template.Core.Control` is packed as a Razor Class Library with symbols/readme and static web assets for catalog styling.

### Template packages

Each official template is packed as a `PackageType=Template` package. Build output is excluded and only template content plus package metadata are included.

## Private feed support

The repository intentionally uses placeholder-only URLs:

- `https://your-private-feed/v3/index.json`

No credentials are stored in source control. Teams are expected to inject credentials using standard NuGet authentication mechanisms outside the repository.

## Design choices preserved

- Server and Wasm remain separate official templates.
- The shared reusable package remains `MachSoft.Template.Core`.
- No Docker, CI/CD workflow, authentication, database, or business features are added to generated apps.


## Actualización 2026-03-24 — Core.Control catálogo público (lote 1)
- `MachSoft.Template.Core.Control` consolida los primeros controles públicos en las familias Actions, Feedback y Overlays.
- Los estilos distribuibles viven en `src/MachSoft.Template.Core.Control/wwwroot/css/machsoft-template-core-control.css` y consumen tokens de `MachSoft.Template.Core`.
- `MachSoft.Template.Core.Control.Showcase` valida los componentes de forma cross-hosting sin lógica de negocio.

## Actualización 2026-03-25 — hardening lote 1 Core.Control
- Se consolidó la primera familia pública (`MxButton`, `MxIconButton`, `MxAlert`, `MxProgress`, `MxTooltip`, `MxDialog`, `MxToast`, `MxPopup`) corrigiendo estados, semántica ARIA y consistencia visual.
- El hardening se mantuvo dentro de `MachSoft.Template.Core.Control` y `Core.Control.Showcase`, preservando la separación con `MachSoft.Template.Core`.

## Actualización 2026-03-25 — familia List / ListBox / Avatar / Chip
- `MachSoft.Template.Core.Control` extiende su superficie pública con `MxList`, `MxListBox`, `MxAvatar` y `MxChip` bajo una API mínima y evolutiva.
- La familia reutiliza tokens/theming de `MachSoft.Template.Core` sin introducir dependencias externas ni acoplamiento de host.
- `MachSoft.Template.Core.Control.Showcase` incorpora `/families/listing` para validación visual/funcional en light y dark con estados interactivos reales.

## Actualización 2026-03-25 — DataGrid enterprise controlado

- `MachSoft.Template.Core.Control` mantiene a `MxDataGrid` como control data base reusable cross-host (Server/WASM) y agrega capacidades enterprise mínimas sin bifurcar hosting.
- `MxDataGridColumn` evoluciona con metadatos de sort (`Sortable`, `SortValueSelector`, `Key`) y se incorpora `MxDataGridSelectionMode` para selección controlada.
- La capa Showcase valida la iteración en `/families/data` sin mezclar assets de demo dentro del paquete distribuible.


## Actualización 2026-03-25 — Familia Scheduling en Core.Control

- `MachSoft.Template.Core.Control` incorpora `MxScheduler` como control público de agenda/calendario en fase base funcional.
- La estructura de datos se define en `MxSchedulerEvent` para desacoplar el contrato UI de cualquier dominio de negocio.
- La validación funcional se centraliza en `MachSoft.Template.Core.Control.Showcase` bajo la ruta `/families/scheduling`, manteniendo separación limpia entre paquete distribuible y host de demo.

## Actualización 2026-03-25 — saneamiento final de contratos Core/Core.Control
- Se delimitó la gobernanza de tipos Mx* para eliminar colisiones semánticas entre paquetes.
- Los contratos `Mx*` de catálogo se movieron a `MachSoft.Template.Core.Control.Models` para eliminar ambigüedad pública entre paquetes.
- `MachSoft.Template.Core.Control` conserva tipos exclusivos renombrados (`MxControlButtonVariant`, `MxControlDataGridColumn<TItem>`) para evitar ambigüedad pública con tipos homónimos de Core.
- Se mantiene compatibilidad arquitectónica Server/WASM y separación limpia paquete/showcase.



## Decisión arquitectónica definitiva (2026-03-26)

- `MachSoft.Template.Core` **no expone controles públicos de catálogo (`Mx*`)**.
- `MachSoft.Template.Core.Control` concentra el catálogo público `Mx*` y sus modelos/variantes asociados.
- Los hosts template (Server/WASM) referencian `Core` + `Core.Control`; no deben consumir controles UI desde `Core`.
- `Core.Control.Showcase` valida visual y funcionalmente el catálogo sin introducir payload de demo en el paquete distribuible.

## Actualización 2026-03-26 — limpieza final legacy en Core

- Se eliminaron de `MachSoft.Template.Core` las páginas legacy (`/`, `/showcase`) y componentes obsoletos (`PageContainer`, `BaseCard`, `FormSection`, `FieldGroup`, `SectionTitle`, `AppMenuTile`).
- `Core` queda alineado como base técnica/visual/infrastructural; las experiencias de demostración quedan fuera del paquete.

- El `template-content` de ambos templates oficiales usa `AppShell` (Core) como contrato visual único de layout/navigation, evitando duplicación de shell por host.

## Actualización 2026-03-26 — shell corporativo unificado

- `AppShell` de `MachSoft.Template.Core` pasa a patrón único cross-host: header superior fijo + drawer lateral overlay (estado inicial cerrado).
- El workspace principal queda desacoplado del estado del menú lateral (sin sidebar persistente que empuje contenido).
- Se mantiene `AppFooter` como componente de contrato y se habilita control de render por parámetro (`ShowFooter`).
- Los hosts `Core.Control.Showcase`, `Official.Server` y `Official.Wasm` preservan un único comportamiento visual/estructural al consumir el shell de Core.
