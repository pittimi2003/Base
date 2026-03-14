# MachSoft Design System Foundation

## 1) Resumen ejecutivo
MachSoft Design System (MDS) se consolida como un sistema visual y técnico propio para aplicaciones enterprise (dashboards, operación, gestión y backoffice) en Blazor Server/WASM.

En esta iteración se completó:
- foundations con valores concretos,
- arquitectura de tokens `--mx-*` con capas explícitas,
- dark mode funcional real con activación y persistencia,
- integración no destructiva con la base actual (`--ms-*` bridge),
- showcase actualizado como validación visual.

---

## 2) Principios del MachSoft Design System
1. Precisión operativa.
2. Claridad jerárquica.
3. Consistencia cross-host (Server/WASM).
4. Densidad equilibrada (comfort/compact).
5. Neutralidad profesional.
6. Evolución gobernada con docs + showcase + pruebas.

Usuarios objetivo: operadores, supervisores, analistas, administradores y equipos de backoffice enterprise.

---

## 3) Foundations completadas

### 3.1 Paleta concreta MachSoft
#### Brand primary scale (logo-driven blue)
- `brand-50 #edf3ff`
- `brand-100 #dbe8ff`
- `brand-200 #bcd3ff`
- `brand-300 #93b5ff`
- `brand-400 #6892f2`
- `brand-500 #3f72de`
- `brand-600 #285dc3`
- `brand-700 #1f4aa0`
- `brand-800 #1b3d80`
- `brand-900 #183466`

#### Brand secondary / accent scale (industrial teal)
- `accent-50 #e7f9f7`
- `accent-100 #cff3ef`
- `accent-200 #a6e7df`
- `accent-300 #78d6cb`
- `accent-400 #42bbaa`
- `accent-500 #219b8c`
- `accent-600 #157f72`
- `accent-700 #13685e`
- `accent-800 #14544d`
- `accent-900 #134640`

#### Neutral scale
- `neutral-0 #ffffff`
- `neutral-50 #f7f9fc`
- `neutral-100 #edf1f7`
- `neutral-200 #dce3ed`
- `neutral-300 #c3cddd`
- `neutral-400 #98a6ba`
- `neutral-500 #6f7f95`
- `neutral-600 #4f6076`
- `neutral-700 #39485d`
- `neutral-800 #243145`
- `neutral-900 #172131`

#### Semantic states
- Success: `#148a56`
- Warning: `#b86b00`
- Danger: `#c63d35`
- Info: `#0f71bc`

#### Data palette
`#3f72de`, `#219b8c`, `#a35de8`, `#dd7b2b`, `#2b8fbd`, `#6d8b2a`, `#d65185`, `#8f6bdb`.

### 3.2 Typography completa
- Font family final: `Segoe UI, Inter, Noto Sans, Roboto, Arial, sans-serif`.
- Mono: `Cascadia Mono, JetBrains Mono, SFMono-Regular, Consolas, monospace`.
- Jerarquía: display/h1/h2/h3/subtitle/body/caption/mono.
- Line-heights: `tight 1.2`, `normal 1.45`, `relaxed 1.6`.
- Weights: `400/500/600/700`.
- Letter spacing: `-0.01em / 0 / 0.01em`.

### 3.3 Spacing
Escala numérica: `0..10`.

Capa semántica:
- `xs -> space-2`
- `sm -> space-3`
- `md -> space-4`
- `lg -> space-6`
- `xl -> space-8`
- `2xl -> space-10`

### 3.4 Borders / Radius / Elevation
- Radius: `xs(4)`, `sm(6)`, `md(10)`, `lg(14)`, `xl(18)`, `pill`.
- Stroke: `1px`, `2px`, `3px`.
- Elevation:
  - `shadow-0 none`
  - `shadow-1 0 1px 2px ...`
  - `shadow-2 0 6px 16px ...`
  - `shadow-3 0 14px 32px ...`

### 3.5 Motion tokens
- `duration-fast 120ms`
- `duration-base 180ms`
- `duration-slow 260ms`
- `ease-standard cubic-bezier(0.2, 0, 0, 1)`
- `ease-emphasis cubic-bezier(0.2, 0, 0, 1.1)`

### 3.6 Z-index tokens
- `z-base 1`
- `z-sticky 20`
- `z-overlay 40`
- `z-drawer 50`
- `z-dialog 70`
- `z-toast 80`
- `z-tooltip 90`

### 3.7 Focus system
- Ring width: `3px`
- Offset: `2px`
- Color tokenizado en `--mx-focus-ring-color`.
- Regla: todos los controles interactivos usan `:focus-visible` con tokens (sin hardcodes por componente).

---

## 4) Arquitectura de tokens (implementada)
Ruta base: `src/MachSoft.Template.Core/wwwroot/css/template/design-system/`

- `tokens.primitives.css`: escalas base (color, space, radius, border, shadow, breakpoint).
- `tokens.semantic.css`: tokens de intención (tipografía, z-index, density, motion, focus base).
- `typography.css`: contratos tipográficos por rol.
- `motion.css`: composición de foco y motion helper tokens.
- `themes/light.css`: semantic mappings para tema light.
- `themes/dark.css`: semantic overrides reales para tema dark.

Agregador oficial: `tokens.css`.
Compatibilidad: alias `--ms-*` para evitar ruptura del template existente.

---

## 5) Dark mode real (implementado)
- Dark mode activo por semantic overrides en `themes/dark.css`.
- Se cubren: canvas, surface, text, border, brand, states, nav y overlay.
- No se usan hardcodes dispersos para tema; componentes consumen tokens.
- Impacta shell/header/sidebar/footer/cards/inputs/showcase.

### Activación y persistencia
- JS mínimo en `wwwroot/js/theme.js`.
- API: `machsoftTheme.init()`, `getPreferredTheme()`, `setTheme(theme)`.
- Persistencia en `localStorage` key: `mx-theme`.
- Aplicación de tema con atributo root: `data-mx-theme="light|dark"`.
- Toggle expuesto en header del layout y funcional en Server + WASM.

---

## 6) Estrategia de componentes
API pública objetivo del sistema: `Mx*` (MachSoft-first).

- Propios: `MxButton`, `MxCard`, `MxBadge`, `MxPageHeader`, `MxSidebarNav`, `MxPanel`, `MxToolbar`.
- Wrappers sobre MudBlazor: `MxTextField`, `MxSelect`, `MxDatePicker`, `MxDialog`.
- Vendor direct solo por excepción justificada y con plan de encapsulación.

---

## 7) Patterns iniciales
1. Dashboard shell.
2. Page header + actions.
3. Card grid.
4. Search/filter panel.
5. List + details.
6. Form sections.
7. Settings pages.
8. Workspace layout.

Todos deben vivir con ejemplo en `/showcase` antes de promoverse a Foundation.

---

## 8) Governance
### Entra
- Contratos UI reutilizables cross-host.
- Foundations/patterns repetidos.

### No entra
- Lógica de negocio.
- Integraciones de infraestructura.
- Componentes locales de un único flujo.

### Reglas de evolución
- Todo cambio reusable requiere showcase + docs + validación.
- Breaking changes de tokens o API `Mx*` requieren nota de migración.
- Versionado interno: `MAJOR.MINOR.PATCH-internal`.

---

## 9) Estructura de carpetas
```text
src/MachSoft.Template.Core/
  Layout/
  Components/
  wwwroot/
    css/template/
      tokens.css
      design-system/
        tokens.primitives.css
        tokens.semantic.css
        typography.css
        motion.css
        themes/
          light.css
          dark.css
    js/
      theme.js
docs/
  MACHSOFT_DESIGN_SYSTEM_FOUNDATION.md
```

---

## 10) Hoja de ruta recomendada
1. Consolidar wrappers iniciales `MxButton/MxCard/MxBadge`.
2. Estandarizar formularios wrapper (`MxTextField`, `MxSelect`, `MxDialog`).
3. Definir contratos enterprise (DataGrid/Charts/FileUpload).
4. Añadir pruebas visuales de tema (light/dark) en E2E.
5. Expandir theming (high-contrast, brand variants por producto si aplica).

---

## 11) Catálogo Mx* - Grupo 1 (implementado)
Ubicación en Core:
- `Components/Foundation/Actions`: `MxButton`, `MxIconButton`
- `Components/Foundation/Feedback`: `MxBadge`
- `Components/Foundation/Surfaces`: `MxCard`, `MxPanel`
- `Components/Foundation/Layout`: `MxPageHeader`

### 11.1 MxButton
**Propósito**: acción principal/secundaria de página o bloque.

**Contrato público**
- `Variant: MxButtonVariant` (`Primary`, `Secondary`, `Tertiary`, `Danger`)
- `Size: MxButtonSize` (`Small`, `Medium`, `Large`)
- `Disabled: bool`
- `LeadingIcon: string?`
- `TrailingIcon: string?`
- `Type: string` (`button` por defecto)
- `OnClick: EventCallback<MouseEventArgs>`
- `ChildContent: RenderFragment` (requerido)

**Uso recomendado**
- Primary: acción principal de contexto.
- Secondary: acción de soporte.
- Tertiary: acción de baja jerarquía en toolbars/footers.
- Danger: acciones destructivas o irreversibles.

### 11.2 MxIconButton
**Propósito**: acción compacta basada en icono.

**Contrato público**
- `Icon: string` (requerido)
- `AriaLabel: string` (requerido)
- `Variant: MxButtonVariant`
- `Size: MxButtonSize`
- `Disabled: bool`
- `OnClick: EventCallback<MouseEventArgs>`

**Regla de accesibilidad**
- Siempre incluir `AriaLabel` descriptivo.

### 11.3 MxCard
**Propósito**: superficie de contenido reusable para bloques de negocio.

**Contrato público**
- `Title: string?`
- `Variant: SurfaceVariant` (`Default`, `Elevated`, `Outlined`, `Muted`)
- `IsCompact: bool`
- `HeaderContent: RenderFragment?`
- `Metadata: RenderFragment?`
- `ChildContent: RenderFragment` (requerido)
- `FooterContent: RenderFragment?`

### 11.4 MxBadge
**Propósito**: estado/etiqueta contextual de baja densidad.

**Contrato público**
- `Variant: MxBadgeVariant` (`Neutral`, `Brand`, `Success`, `Warning`, `Danger`)
- `Size: MxBadgeSize` (`Small`, `Medium`)
- `Text: string?`
- `ChildContent: RenderFragment?`

### 11.5 MxPageHeader
**Propósito**: encabezado enterprise para páginas y módulos.

**Contrato público**
- `Title: string` (requerido)
- `Description: string?`
- `Metadata: RenderFragment?`
- `Actions: RenderFragment?`

### 11.6 MxPanel
**Propósito**: contenedor de contexto/filtros con encabezado opcional.

**Contrato público**
- `Title: string?`
- `HeaderActions: RenderFragment?`
- `ChildContent: RenderFragment` (requerido)
- `Variant: SurfaceVariant`
- `IsCompact: bool`

### 11.7 Estados y theming
- El Grupo 1 soporta light/dark con tokens semánticos (`--mx-color-*`) sin hardcodes por tema.
- Estados aplicados: `hover`, `focus-visible`, `disabled` (donde aplica).
- Se mantiene compatibilidad no destructiva con aliases `--ms-*`.

### 11.8 Showcase
`/showcase` incorpora sección dedicada del Grupo 1 con:
- variantes mínimas,
- tamaños clave,
- estados disabled,
- ejemplos de composición con `MxPageHeader`, `MxCard` y `MxPanel`.

---

## 12) Catálogo Mx* - Grupo 2 (Forms base)
Ubicación en Core:
- `Components/Foundation/Forms`: `MxTextField`, `MxTextarea`, `MxSelect`, `MxCheckbox`, `MxSwitch`, `MxFieldGroup`, `MxFormSection`.
- `Models`: `MxSelectOption`.

### 12.1 Decisión de implementación (propio vs wrapper)
- `MxTextField`: **propio puro** (HTML input + tokens). Motivo: contrato mínimo estable y control total de accesibilidad/estados.
- `MxTextarea`: **propio puro**. Motivo: mismo criterio que `MxTextField`, sin necesidad de dependencia vendor.
- `MxSelect`: **propio puro**. Motivo: API clara por `MxSelectOption` y comportamiento suficientemente simple en baseline.
- `MxCheckbox`: **propio puro**. Motivo: control nativo robusto con `accent-color` tokenizado.
- `MxSwitch`: **propio puro**. Motivo: patrón visual corporativo con `role="switch"` y estados tokenizados.
- `MxFieldGroup`: **propio puro**. Motivo: unidad visual reusable para label/control/helper/error.
- `MxFormSection`: **propio puro**. Motivo: agrupador enterprise con header y acciones opcionales.

### 12.2 Contratos públicos
- `MxTextField`: `Label`, `Placeholder`, `Value`, `ValueChanged`, `Disabled`, `ReadOnly`, `Required`, `HelperText`, `ErrorText`, `IsCompact`, `InputType`, `Id`.
- `MxTextarea`: `Label`, `Placeholder`, `Value`, `ValueChanged`, `Disabled`, `ReadOnly`, `Required`, `Rows`, `HelperText`, `ErrorText`, `IsCompact`, `Id`.
- `MxSelect`: `Label`, `Value`, `ValueChanged`, `Options: IEnumerable<MxSelectOption>`, `Placeholder`, `Disabled`, `Required`, `HelperText`, `ErrorText`, `IsCompact`, `Id`.
- `MxCheckbox`: `Label`, `Description`, `Checked`, `CheckedChanged`, `Disabled`, `Id`.
- `MxSwitch`: `Label`, `HelperText`, `Checked`, `CheckedChanged`, `Disabled`, `Id`.
- `MxFieldGroup`: `Label`, `FieldId`, `Required`, `HelperText`, `ErrorText`, `IsCompact`, `ChildContent`.
- `MxFormSection`: `Title`, `Description`, `Actions`, `IsCompact`, `ChildContent`.

### 12.3 Estados y accesibilidad
- Estados cubiertos: default, hover, focus-visible, disabled e invalid/error.
- Soporte light/dark vía tokens semánticos (`--mx-*` + bridge `--ms-*`).
- Asociación label-control mediante `for`/`id`.
- Mensajes de ayuda/error enlazados por `aria-describedby` en text/select/textarea.
- `MxSwitch` usa `role="switch"` para semántica explícita.

### 12.4 Reglas de uso
- Usar `MxTextField/MxTextarea/MxSelect` para captura estructurada de datos.
- Usar `MxCheckbox` para flags no críticos binarios y `MxSwitch` para toggles de estado de configuración.
- Usar `MxFieldGroup` cuando se necesite envolver controles custom manteniendo espaciado y mensaje consistente.
- Usar `MxFormSection` para agrupar bloques de formulario por contexto funcional.
- Evitar usar Grupo 2 para validaciones de dominio complejas sin una capa de formularios superior.

---

## 13) Catálogo Mx* - Grupo 3 (Navigation + Overlays)
Ubicación en Core:
- `Components/Foundation/Navigation`: `MxTabs`, `MxBreadcrumb`
- `Components/Foundation/Overlays`: `MxDialog`, `MxDrawer`
- `Components/Foundation/Feedback`: `MxToast`
- `Models`: `MxTabItem`, `MxBreadcrumbItem`

### 13.1 Decisión de implementación (propio vs wrapper)
- `MxTabs`: **propio puro**. Motivo: contrato acotado y navegación teclado básica implementable sin vendor.
- `MxDialog`: **propio puro**. Motivo: control claro de `Open/OpenChanged`, overlay y cierre por escape.
- `MxDrawer`: **propio puro**. Motivo: comportamiento de panel lateral y overlay simple, consistente y tokenizado.
- `MxToast`: **propio puro**. Motivo: feedback efímero con contrato mínimo (`Visible`, `Variant`, `DurationMs`).
- `MxBreadcrumb`: **propio puro**. Motivo: navegación jerárquica estática de baja complejidad.

### 13.2 Contratos públicos
- `MxTabs`: `Items: IEnumerable<MxTabItem>`, `ActiveValue`, `ActiveValueChanged`, `Variant`, `AriaLabel`, `ActiveContent`.
- `MxDialog`: `Open`, `OpenChanged`, `Title`, `ChildContent`, `Actions`, `Size`, `CloseOnOverlayClick`, `CloseOnEscape`, `ShowCloseButton`.
- `MxDrawer`: `Open`, `OpenChanged`, `Title`, `ChildContent`, `Side`, `Width`, `CloseOnOverlayClick`, `CloseOnEscape`, `ShowCloseButton`.
- `MxToast`: `Visible`, `VisibleChanged`, `Variant`, `Title`, `Message`, `Dismissible`, `DurationMs`.
- `MxBreadcrumb`: `Items: IEnumerable<MxBreadcrumbItem>`.

### 13.3 Estados, interacción y accesibilidad
- Estados cubiertos: default, hover, focus-visible y disabled donde aplica.
- Light/dark soportado por tokens semánticos del sistema.
- `MxTabs`: `role=tablist/tab/tabpanel`, selección activa y navegación teclado (`ArrowLeft/ArrowRight/Home/End`).
- `MxDialog`: `role=dialog`, `aria-modal`, cierre por overlay/escape configurable.
- `MxDrawer`: `role=dialog`, overlay + cierre por escape/overlay configurable.
- `MxToast`: `role=status`, dismiss manual opcional y autocierre por duración.
- `MxBreadcrumb`: `nav[aria-label="Breadcrumb"]` + `aria-current="page"` para item activo.
