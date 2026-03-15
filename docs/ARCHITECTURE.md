# MachSoft Template - Architecture

## Visión
Solución de plantilla corporativa Blazor con dos hosts (Server y WASM) sobre una base reusable única para maximizar consistencia y minimizar duplicación.

## Capas y responsabilidad
- **Capa común (`MachSoft.Template.Core`)**
  - Layout corporativo desacoplado (`MainLayout`, `AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`).
  - Foundation components y patterns oficiales (`MxPageHeader`, `MxCard`, `MxPanel`, `MxFormSection`, `MxFieldGroup`, `AppMenuTile`).
  - Páginas base (`Home`, `Showcase`).
  - Static web assets compartidos (`wwwroot/css/template/*`).
- **Capa host Server (`MachSoft.Template.Starter`)**
  - Bootstrap de Blazor Server.
  - Registro del root component + `AddAdditionalAssemblies(...)` para páginas enrutables del Core.
  - Páginas específicas de host (ej. `/demo`).
- **Capa host WASM (`MachSoft.Template.Starter.Wasm`)**
  - Bootstrap de Blazor WebAssembly.
  - `index.html` de cliente y páginas específicas de host (ej. `/wasm-demo`).
- **Capa de ejemplo (`MachSoft.Template.SampleApp`)**
  - App de validación funcional consumiendo el Core.

## Contratos de diseño
1. **MainLayout liviano**: solo composición/orquestación.
2. **Variantes tipadas**:
   - `MxCard` y `MxPanel` usan `SurfaceVariant`.
   - `AppMenuTile` usa `TileVariant`.
3. **Compact mode explícito**: `IsCompact` en componentes Mx que exponen densidad (`MxCard`, `MxFormSection`, inputs).
4. **Token-first CSS**: spacing/radius/shadows/typography/z-index definidos por tokens.
5. **Sidebar responsive (patrón único)**: visible fijo en desktop y panel flotante en tablet/mobile con overlay gestionado en Blazor.

## Patrón de navegación lateral
- **Desktop (>=1025px)**: sidebar visible por defecto y sin overlay.
- **Tablet/Mobile (<=1024px)**: sidebar oculto por defecto y abierto como panel flotante.
- Estado de menú centralizado en `AppShell` (`IsMenuOpen`).
- `AppHeader` dispara toggle de hamburguesa (visible solo en tablet/mobile).
- `AppNavigation` renderiza panel lateral con prioridad visual (`z-index` mayor que overlay y contenido).
- Overlay gris semitransparente cubre toda la pantalla (`position: fixed; inset: 0`) cuando el menú está abierto en tablet/mobile.
- `SideNav` notifica selección de ítem para cierre automático del menú.
- Cierre por `Escape` soportado desde `AppShell`.

## Accesibilidad del shell
- Botón hamburguesa con `aria-label`, `aria-expanded`, `aria-controls` y `aria-haspopup`.
- Navegación lateral con `role="navigation"`, `aria-label` y `aria-hidden` sincronizado con el estado abierto/cerrado.
- Overlay cerrable con botón accesible (`aria-label`) y foco visible.
- Estilos `:focus-visible` obligatorios para hamburguesa y links de navegación lateral.
- Al abrir menú en mobile/tablet, foco programático en el panel de navegación para asegurar continuidad por teclado.

## Cobertura E2E mínima del shell
- Suite Playwright ubicada en `tests/e2e`.
- Estructura de specs separada por comportamiento para claridad de mantenimiento y reporte:
  - `tests/shell-mobile-tablet.spec.ts`
  - `tests/shell-desktop.spec.ts`
- Escenarios obligatorios en mobile/tablet: abrir menú, overlay visible, cierre por overlay, cierre por item, cierre por hamburguesa y por `Escape`.
- Escenarios obligatorios en desktop: sidebar visible, overlay oculto, hamburguesa no visible y navegación entre `/`, `/showcase` y `/demo`.
- Guía operativa E2E (prerrequisitos, scripts, restricciones de red/CDN y recomendaciones de CI) en `tests/e2e/README.md`.


## MachSoft Design System Foundation (base inicial)
- Documento rector: `docs/MACHSOFT_DESIGN_SYSTEM_FOUNDATION.md`.
- Arquitectura de tokens en Core: `wwwroot/css/template/design-system/*` con separación de primitives, semantic, typography, motion y themes (`light`/`dark`).
- `tokens.css` actúa como agregador oficial del Design System y conserva aliases `--ms-*` para transición no destructiva.
- La API pública oficial de componentes del sistema es `Mx*` (MachSoft-first); la implementación base actual es Blazor/HTML tokenizada en Core y no expone contratos vendor.


## Theming y Dark Mode
- Theming centralizado en tokens semánticos (`themes/light.css` + `themes/dark.css`).
- Activación por atributo `data-mx-theme` aplicado al root document.
- Persistencia del modo en `localStorage` (`mx-theme`) con helper JS liviano (`wwwroot/js/theme.js`).
- Toggle de tema integrado en `AppHeader` y coordinado por `AppShell` para Server/WASM sin duplicación de lógica de host.

## Governance Rules
- **Qué entra en Core**:
  - patrones visuales reutilizados por Server y WASM,
  - componentes sin dependencia de dominio,
  - contratos UI estables que funcionen como baseline corporativo.
- **Qué no entra en Core**:
  - lógica de negocio,
  - servicios de infraestructura host-specific,
  - UI de un único flujo local.
- **Aprobación de nuevos foundation components**:
  1. uso repetido real en al menos dos contextos,
  2. contrato mínimo y coherente,
  3. ejemplo en `/showcase`,
  4. guía/documentación actualizada.
- **Actualización obligatoria de `/showcase`**:
  - alta de nuevos componentes/variantes en Foundation,
  - cambios de contrato público de componentes reusables.
- **Actualización obligatoria de E2E**:
  - cambios de comportamiento del shell responsive,
  - cambios de accesibilidad o navegación lateral.
- **Actualización obligatoria de docs**:
  - cambios de arquitectura, contratos de componentes, scripts o flujo de adopción.

## Separación Server vs WASM
- **Común**: UI, layout, contratos de componentes y estilos (Core).
- **Server**: renderizado interactivo en servidor + `blazor.web.js`.
- **WASM**: renderizado cliente + `blazor.webassembly.js` e `index.html` propio.

## Adopción
- Guía práctica de onboarding y checklist: `docs/ADOPTION_GUIDE.md`.

## Catálogo MachSoft Components - Grupo 1
Implementado como contratos públicos `Mx*` en `MachSoft.Template.Core`, con organización por dominio visual:

- `Components/Foundation/Actions`
  - `MxButton`
  - `MxIconButton`
- `Components/Foundation/Feedback`
  - `MxBadge`
- `Components/Foundation/Surfaces`
  - `MxCard`
  - `MxPanel`
- `Components/Foundation/Layout`
  - `MxPageHeader`

Decisiones clave de arquitectura:
1. API pública vendor-agnostic (`Mx*`) y orientada a uso enterprise.
2. Variantes tipadas por enums en `Models/ComponentVariants.cs`.
3. Reuso de `SurfaceVariant` para evitar duplicación de contratos entre superficies.
4. Estilos token-first en `wwwroot/css/template/components.css` apoyados en `--mx-*` y bridge `--ms-*`.
5. Integración incremental: `AppMenuTile` se mantiene como helper de navegación del template y los componentes legacy quedan explícitamente relegados para compatibilidad temporal.

## Catálogo MachSoft Components - Grupo 2 (Forms)
Implementado en `MachSoft.Template.Core/Components/Foundation/Forms` con contratos públicos `Mx*` y componentes propios (sin API vendor expuesta):

- `MxTextField`
- `MxTextarea`
- `MxSelect`
- `MxCheckbox`
- `MxSwitch`
- `MxFieldGroup`
- `MxFormSection`

Modelo de soporte:
- `Models/MxSelectOption.cs` para contrato de opciones tipado en `MxSelect`.

Decisiones de arquitectura:
1. Baseline de formularios 100% token-first con HTML/Blazor nativo.
2. Contratos mínimos para mantener estabilidad API y facilitar adopción incremental.
3. `MxFieldGroup` centraliza patrón de label/control/helper/error para evitar divergencia visual.
4. `MxFormSection` estandariza agrupación enterprise con acciones de encabezado opcionales.
5. Convivencia temporal con `Components/Forms` legacy (`FieldGroup`, `FormSection`, `SectionTitle`) solo para compatibilidad de adopciones en tránsito.

## Catálogo MachSoft Components - Grupo 3 (Navigation + Overlays)
Implementado en `MachSoft.Template.Core` con componentes propios y contratos `Mx*`:

- `Components/Foundation/Navigation`
  - `MxTabs`
  - `MxBreadcrumb`
- `Components/Foundation/Overlays`
  - `MxDialog`
  - `MxDrawer`
- `Components/Foundation/Feedback`
  - `MxToast`

Modelos de soporte:
- `Models/MxTabItem.cs`
- `Models/MxBreadcrumbItem.cs`

Decisiones de arquitectura:
1. Grupo 3 se mantiene vendor-agnostic en API pública y en implementación.
2. Overlays centralizados con patrón de `Open/OpenChanged` para interoperar en Server y WASM.
3. Navegación y overlays consumen tokens semánticos y z-index del Design System.
4. Comportamientos interactivos mínimos (tabs por teclado, cierre dialog/drawer, dismiss de toast) se validan en `/showcase`.
5. Sin refactor masivo: coexistencia con navegación/layout legacy durante migración incremental.

## Catálogo MachSoft Components - Grupo 4 (Data display + feedback)
Implementado en `MachSoft.Template.Core/Components/Foundation/DataDisplay` con componentes propios:

- `MxTag`
- `MxStatusIndicator`
- `MxEmptyState`
- `MxStatCard`
- `MxProgress`

Decisiones de arquitectura:
1. Grupo 4 implementado como componentes propios para mantener contratos mínimos y estables.
2. Componentes orientados a escenarios enterprise (KPIs, estados operativos, módulos vacíos, progreso de procesos).
3. Semántica accesible integrada (`progressbar`, roles de status, estructura de empty state, foco visible cuando hay interacción).
4. Diferenciación explícita entre `MxBadge`, `MxTag` y `MxStatusIndicator` para evitar solapamiento conceptual.

## Catálogo MachSoft Components - Grupo 5 (Enterprise inputs)
Implementado en `MachSoft.Template.Core/Components/Foundation/Inputs`:

- `MxDatePicker`
- `MxDateRangePicker`
- `MxAutocomplete`
- `MxMultiSelect`
- `MxFileUpload`

Modelo de soporte:
- `Models/MxInputOption.cs`.

Decisiones de arquitectura:
1. Grupo 5 se mantiene MachSoft-first con contratos compactos y sin API vendor expuesta.
2. Implementación propia para baseline enterprise con evolución incremental.
3. Integración con `MxFieldGroup` para consistencia visual, helper/error y accesibilidad.
4. `MxFileUpload` encapsula `InputFile` de Blazor como dependencia framework-level (no vendor UI API).

## Catálogo MachSoft Components - Grupo 6 (Enterprise data)
Implementado en `MachSoft.Template.Core/Components/Foundation/Data`:

- `MxDataGrid`
- `MxTreeGrid`
- `MxChart`

Modelos de soporte:
- `MxDataGridColumn<TItem>`
- `MxTreeGridItem`
- `MxChartSeries`

Decisiones de arquitectura:
1. Implementación propia con contratos Mx mínimos y honestos.
2. Alcance inicial controlado para evitar APIs infladas y deuda de mantenibilidad.
3. Integración visual con tokens y patrones de empty state.
4. Base diseñada para evolución incremental (sorting/paging/series avanzadas en futuras iteraciones).

---

## Design System Layers (Consolidación)

La arquitectura oficial de UI queda dividida en cuatro capas:
1. **Foundations** (`Components/Foundation/*` base)
2. **Components** (`Components/Foundation/Inputs`)
3. **Data Components** (`Components/Foundation/Data`)
4. **Patterns** (`Components/Foundation/Patterns`)

### Legacy lane
Los componentes legacy siguen disponibles solo para no romper adopción incremental, pero deben considerarse ruta de salida:
- `BaseCard` (LEGACY)
- `PageContainer` (LEGACY)
- `Components/Forms/*` (`FormSection`, `FieldGroup`, `SectionTitle`) (LEGACY)

Ver detalle y clasificación actual en `docs/COMPONENT_INVENTORY.md`.


## Frontera de empaquetado NuGet (Fase 14)
- **Paquete distribuible**: `MachSoft.Template.Core` generado desde `src/MachSoft.Template.Core`.
- **Runtime reusable incluido**: componentes `Mx*`, layout común, static web assets (`css/template/*`, `js/theme.js`).
- **Fuera del paquete**: hosts `template/*` y aplicaciones `samples/*` (solo validación/adopción interna).
- **Dependencia de consumo esperada**: host Blazor (`Server` o `WASM`) que referencia el paquete y carga assets `_content/MachSoft.Template.Core/*`.


## Template corporativo oficial (Fase 15)

### Delimitación de artefactos
- **Runtime reusable**: `src/MachSoft.Template.Core` (NuGet `MachSoft.Template.Core`).
- **Template oficial de arranque**: `template/MachSoft.Template.Official` (`dotnet new machsoft-app`).
- **Hosts de validación interna**: `template/MachSoft.Template.Starter` y `template/MachSoft.Template.Starter.Wasm`.
- **Apps de referencia interna**: `samples/*`.

### Contrato del template oficial
- Genera una app Blazor Server mínima, sin rutas de showcase/demo internas.
- Integra shell/layout corporativo y theming desde `MachSoft.Template.Core`.
- Mantiene navegación inicial acotada a páginas de bootstrap (`/`, `/operations`, `/settings`).
- Se apoya en `PackageReference` a `MachSoft.Template.Core` para separar claramente bootstrap vs runtime reusable.

## Fase 16 — Operacionalización de plataforma interna
- **Versión interna activa**: `v1.0.0-internal`.
- **Artefactos operables**:
  - `MachSoft.Template.Core` (NuGet runtime reusable),
  - `template/MachSoft.Template.Official` (`dotnet new machsoft-app`),
  - `template/MachSoft.Template.Starter*` (hosts de validación).
- **Circuito soportado**: pack → publicar/servir feed → instalar template → generar app → restore/build/run.
- **Gobernanza operativa**: release go/no-go y baseline mínima documentadas en `docs/INTERNAL_RELEASE_CHECKLIST.md` y `docs/OPERATIONS_BASELINE.md`.
