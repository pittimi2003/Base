# AGENTS.md — Guía operativa para agentes en MachSoft.Template

## 1) Propósito del repositorio
Este repositorio contiene una plantilla corporativa Blazor bajo convención **MachSoft.Template.*** para acelerar nuevos proyectos con una base visual y estructural reutilizable.

Objetivo principal:
- versión base interna vigente: `v1.0.0-internal`,
- centralizar UI foundation y estilos en una capa común,
- ofrecer hosts listos para **Server** y **WebAssembly**,
- mantener un **sample** para validación funcional y visual.

---

## 2) Arquitectura general de la solución
Estructura esperada:
- `src/MachSoft.Template.Core` → capa reusable común (RCL).
- `template/MachSoft.Template.Starter` → starter Blazor Server.
- `template/MachSoft.Template.Starter.Wasm` → starter Blazor WebAssembly.
- `samples/MachSoft.Template.SampleApp` → aplicación demo de referencia.
- `docs/` → arquitectura, guía de uso y migración.

### Responsabilidades por capa
- **Core (común)**: layout base desacoplado (MainLayout + AppShell/AppHeader/AppNavigation/AppFooter), foundation components, base mínima de formularios, páginas base, CSS y tokens.
- **Starter Server**: bootstrap server y páginas específicas de host server.
- **Starter WASM**: bootstrap cliente WASM y páginas específicas de host WASM.
- **Sample**: validar patrones de uso reales sin lógica de negocio legacy.

---

## 3) Reglas para Foundation Components
Ubicación: `src/MachSoft.Template.Core/Components/Foundation`.

Reglas:
1. Deben ser **genéricos** y sin dependencias de negocio.
2. API de parámetros simple y explícita.
3. Evitar side effects, acceso directo a servicios de dominio o persistencia.
4. Priorizar composición (ChildContent) sobre especialización rígida.
5. Si un componente deja de ser reusable, moverlo a host específico.

Contratos de referencia:
- `PageContainer` (`Title`, `Description`, `IsCompact`)
- `BaseCard` (`Title`, `BadgeText`, `Variant: SurfaceVariant`, `IsCompact`)
- `AppMenuTile` (`Title`, `Description`, `Href`, `Icon`, `Variant: TileVariant`)

---

## 4) Base mínima de formularios
Ubicación: `src/MachSoft.Template.Core/Components/Forms`.

Componentes:
- `FormSection`
- `SectionTitle`
- `FieldGroup`

Regla: mantenerlos como **patrones visuales ligeros**. No convertir esta capa en framework de formularios.

---

## 5) Reglas de Layout y navegación
Ubicación: `src/MachSoft.Template.Core/Layout`.

- `MainLayout` es el contrato visual común y debe permanecer liviano.
- Delegar estructura visual en subcomponentes (`AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`).
- `AppShell` gestiona estado de sidebar colapsable (`IsMenuOpen`) y overlay.
- Patrón oficial de shell: **desktop con sidebar fijo y sin overlay**; **mobile/tablet con sidebar flotante + overlay**.
- Botón hamburguesa visible solo en mobile/tablet.
- Mantener accesibilidad mínima del shell:
  - hamburguesa con `aria-label`, `aria-expanded`, `aria-controls`,
  - sidebar con `role="navigation"`, `aria-label`, `aria-hidden` sincronizado,
  - foco visible en controles interactivos (`:focus-visible`).
- Cierre automático del menú cuando:
  1. clic en overlay,
  2. clic en contenido fuera del sidebar,
  3. clic en opción de navegación,
  4. clic nuevamente en hamburguesa,
  5. tecla Escape.
- No inyectar servicios de negocio en layout común.

---

## 6) Sistema de estilos y design tokens
Ubicación: `src/MachSoft.Template.Core/wwwroot/css/template/`

Archivos y propósito:
- `tokens.css` → variables y design tokens.
- `base.css` → tipografía, resets mínimos y defaults.
- `layout.css` → shell/layout principal + sidebar responsive + overlay.
- `components.css` → estilos de componentes.
- `utilities.css` → utilidades de spacing/grid/helpers.

Reglas CSS:
1. Usar prefijo `ms-` en clases corporativas.
2. Evitar estilos inline salvo casos justificados.
3. Nuevos colores/espaciados/z-index primero como token.
4. No duplicar estilos entre Server y WASM.

---

## 7) Reglas de composición
- Combinación base por pantalla: `PageContainer` + `BaseCard`.
- `IsCompact=true` solo para secciones densas o anidadas.
- `SurfaceVariant.Outlined`: estructura neutral.
- `SurfaceVariant.Elevated`: bloque prioritario.
- `SurfaceVariant.Muted`: contenido secundario/contextual.
- Promover a Foundation solo si el patrón se repite cross-host y no contiene dominio.

---

## 8) Reglas de reutilización Server/WASM
- Toda UI compartida debe vivir en `MachSoft.Template.Core`.
- Server/WASM solo contienen bootstrap, runtime y necesidades específicas de host.
- Si algo se repite en ambos hosts, mover al Core.
- No copiar componentes/estilos entre hosts.

---

## 9) Convenciones de nombres
- Prefijo obligatorio: `MachSoft.Template.*`.
- Nombres claros por responsabilidad (`Core`, `Starter`, `Starter.Wasm`, `SampleApp`).
- Evitar nombres legacy o ambiguos.

---

## 10) Governance Rules
- **Qué entra en Core**:
  - layout, estilos y componentes reutilizables por Server y WASM,
  - contratos UI estables y agnósticos de dominio.
- **Qué no entra en Core**:
  - lógica de negocio,
  - integraciones de infraestructura,
  - componentes de un único flujo local.
- Todo cambio reusable debe pasar por `/showcase` antes de adoptarse.
- No incorporar nuevos components en Core sin:
  1. uso repetido,
  2. contrato claro,
  3. ejemplo en showcase,
  4. docs actualizadas.
- Exigir actualización de E2E cuando cambie comportamiento/accesibilidad del shell responsive.
- Exigir actualización de docs cuando cambien arquitectura, contratos o flujo de adopción.
- Evitar duplicación: preferir extender Foundation antes que crear variantes locales paralelas.

---

## 11) Reglas de documentación
Actualizar siempre cuando cambie arquitectura o flujo de uso:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/TEMPLATE_GUIDE.md`
- `docs/MIGRATION_REPORT.md`

La documentación debe reflejar estado real del código (no intenciones futuras).

---

## 12) Flujo de trabajo esperado para agentes
1. Validar entorno (`dotnet --info`).
2. Restaurar y compilar (`dotnet restore`, `dotnet build`).
3. Hacer cambios mínimos y coherentes con la arquitectura.
4. Verificar que Server y WASM sigan reutilizando Core.
5. Ejecutar validaciones de arranque básicas cuando sea posible.
6. Validar visualmente `/showcase` y navegación lateral al cambiar layout/styles.
7. Ejecutar cobertura E2E mínima del shell (`tests/e2e`) cuando haya cambios en layout/navigation.
   - Revisar/actualizar `tests/e2e/README.md` si cambian scripts o prerrequisitos.
   - Mantener separación por comportamiento (`shell-mobile-tablet.spec.ts` y `shell-desktop.spec.ts`).
   - Para runner/contenedor, mantener flags de Chromium `--no-sandbox` y `--disable-dev-shm-usage` en Playwright.
   - Mantener `reuseExistingServer: false` en E2E para evitar interferencia de procesos previos en CI compartido.
   - Mantener arranque de host E2E con `dotnet build` + `dotnet run --no-build` cuando se ajuste `webServer.command`.
   - Si falla por binarios ausentes, ejecutar `npm run install:browsers` antes de diagnosticar el shell.
   - En mobile/tablet, sincronizar acciones con readiness real del shell (`data-ms-shell-interactive="true"` + hamburguesa operativa).
8. Actualizar docs.
9. Commit atómico con mensaje claro y PR con resumen técnico.

Comandos base sugeridos:
- `dotnet restore MachSoft.Template.sln`
- `dotnet build MachSoft.Template.sln`
- `dotnet run --project template/MachSoft.Template.Starter`
- `dotnet run --project template/MachSoft.Template.Starter.Wasm`

---

## 13) Catálogo MachSoft Components — Grupo 1
Ubicación recomendada en Core:
- `Components/Foundation/Actions`: `MxButton`, `MxIconButton`
- `Components/Foundation/Feedback`: `MxBadge`
- `Components/Foundation/Surfaces`: `MxCard`, `MxPanel`
- `Components/Foundation/Layout`: `MxPageHeader`

Contratos públicos mínimos del Grupo 1:
- `MxButton`: `Variant`, `Size`, `Disabled`, `LeadingIcon`, `TrailingIcon`, `ChildContent`.
- `MxIconButton`: `Icon`, `AriaLabel`, `Variant`, `Size`, `Disabled`.
- `MxCard`: `Variant`, `IsCompact`, `HeaderContent`, `ChildContent`, `FooterContent`, `Metadata`.
- `MxBadge`: `Variant`, `Size`, `Text|ChildContent`.
- `MxPageHeader`: `Title`, `Description`, `Actions`, `Metadata`.
- `MxPanel`: `Title`, `HeaderActions`, `Variant`, `IsCompact`, `ChildContent`.

Reglas adicionales:
1. API pública siempre `Mx*`, sin exponer contratos vendor en parámetros.
2. Limitar variantes a las mínimas útiles; evitar explosión combinatoria.
3. Cubrir `hover`, `focus-visible`, `disabled` y contraste razonable en light/dark.
4. Todo componente nuevo del catálogo debe tener ejemplo en `/showcase` + docs actualizadas.

---

## 14) Catálogo MachSoft Components — Grupo 2 (Forms)
Ubicación recomendada en Core:
- `Components/Foundation/Forms`:
  - `MxTextField`
  - `MxTextarea`
  - `MxSelect`
  - `MxCheckbox`
  - `MxSwitch`
  - `MxFieldGroup`
  - `MxFormSection`
- `Models/MxSelectOption` para opciones tipadas de select.

Contratos públicos mínimos del Grupo 2:
- `MxTextField`: `Label`, `Placeholder`, `Value`, `ValueChanged`, `Disabled`, `ReadOnly`, `Required`, `HelperText`, `ErrorText`, `IsCompact`.
- `MxTextarea`: `Label`, `Placeholder`, `Value`, `ValueChanged`, `Disabled`, `ReadOnly`, `Required`, `Rows`, `HelperText`, `ErrorText`.
- `MxSelect`: `Label`, `Value`, `ValueChanged`, `Options`, `Placeholder`, `Disabled`, `Required`, `HelperText`, `ErrorText`.
- `MxCheckbox`: `Label`, `Checked`, `CheckedChanged`, `Disabled`, `Description`.
- `MxSwitch`: `Label`, `Checked`, `CheckedChanged`, `Disabled`, `HelperText`.
- `MxFieldGroup`: `Label`, `FieldId`, `HelperText`, `ErrorText`, `ChildContent`.
- `MxFormSection`: `Title`, `Description`, `Actions`, `ChildContent`.

Reglas adicionales:
1. Implementación preferente en Blazor/HTML puro y tokenizado; wrappers vendor solo si hay necesidad técnica clara.
2. Mantener estados base: default, hover, focus-visible, disabled, invalid/error.
3. Asegurar asociación label/control (`for` + `id`) y mensajes enlazados (`aria-describedby`) cuando aplique.
4. Todo cambio en Grupo 2 debe reflejarse en `/showcase` y en docs de arquitectura/guía/foundation.

---

## 15) Catálogo MachSoft Components — Grupo 3 (Navigation + Overlays)
Ubicación recomendada en Core:
- `Components/Foundation/Navigation`:
  - `MxTabs`
  - `MxBreadcrumb`
- `Components/Foundation/Overlays`:
  - `MxDialog`
  - `MxDrawer`
- `Components/Foundation/Feedback`:
  - `MxToast`
- `Models`: `MxTabItem`, `MxBreadcrumbItem`.

Contratos públicos mínimos del Grupo 3:
- `MxTabs`: `Items`, `ActiveValue`, `ActiveValueChanged`, `Variant`, `AriaLabel`, `ActiveContent`.
- `MxDialog`: `Open`, `OpenChanged`, `Title`, `ChildContent`, `Actions`, `Size`, `CloseOnOverlayClick`, `CloseOnEscape`.
- `MxDrawer`: `Open`, `OpenChanged`, `Title`, `ChildContent`, `Side`, `Width`, `CloseOnOverlayClick`, `CloseOnEscape`.
- `MxToast`: `Visible`, `VisibleChanged`, `Variant`, `Title`, `Message`, `Dismissible`, `DurationMs`.
- `MxBreadcrumb`: `Items`.

Reglas adicionales:
1. Mantener API pública `Mx*` y contratos de interacción simples.
2. Asegurar base accesible: tabs con roles y teclado; dialog/drawer con `role="dialog"` + `aria-modal`; breadcrumb con `aria-current`.
3. Usar tokens semánticos para overlays, foco y estados visuales en light/dark.
4. Toda evolución del Grupo 3 debe reflejarse en `/showcase` y documentación técnica.

---

## 16) Catálogo MachSoft Components — Grupo 4 (Data display + feedback)
Ubicación recomendada en Core:
- `Components/Foundation/DataDisplay`:
  - `MxTag`
  - `MxStatusIndicator`
  - `MxEmptyState`
  - `MxStatCard`
  - `MxProgress`

Contratos públicos mínimos del Grupo 4:
- `MxTag`: `Text|ChildContent`, `Variant`, `Dismissible`, `OnDismiss`.
- `MxStatusIndicator`: `Status`, `Label`.
- `MxEmptyState`: `Title`, `Description`, `Icon`, `Actions`.
- `MxStatCard`: `Title`, `Value`, `SupportingText`, `TrendText`, `TrendStatus`, `Status`.
- `MxProgress`: `Value`, `Max`, `Variant`, `ShowLabel`, `IsInline`, `AriaLabel`.

Reglas adicionales:
1. Grupo 4 debe priorizar utilidad operativa real (KPIs, estados de proceso, vacíos de datos, progreso).
2. Mantener diferencias semánticas claras entre `MxBadge` (metadata), `MxTag` (etiqueta de entidad) y `MxStatusIndicator` (estado operativo).
3. `MxProgress` debe mantener atributos accesibles (`role="progressbar"` + `aria-valuenow/max`).
4. Todo cambio del Grupo 4 debe verse en `/showcase` y documentación técnica.

---

## 17) Catálogo MachSoft Components — Grupo 5 (Enterprise inputs)
Ubicación recomendada en Core:
- `Components/Foundation/Inputs`:
  - `MxDatePicker`
  - `MxDateRangePicker`
  - `MxAutocomplete`
  - `MxMultiSelect`
  - `MxFileUpload`
- `Models/MxInputOption` para opciones de autocomplete/multiselect.

Contratos públicos mínimos del Grupo 5:
- `MxDatePicker`: `Label`, `Value`, `ValueChanged`, `Placeholder`, `Disabled`, `Required`, `HelperText`, `ErrorText`, `Id`.
- `MxDateRangePicker`: `Label`, `StartValue`, `EndValue`, `StartValueChanged`, `EndValueChanged`, `Disabled`, `Required`, `HelperText`, `ErrorText`.
- `MxAutocomplete`: `Label`, `Value`, `ValueChanged`, `SearchText`, `SearchTextChanged`, `Items`, `Placeholder`, `Disabled`, `Required`, `HelperText`, `ErrorText`.
- `MxMultiSelect`: `Label`, `SelectedValues`, `SelectedValuesChanged`, `Options`, `Placeholder`, `Disabled`, `Required`, `HelperText`, `ErrorText`.
- `MxFileUpload`: `Label`, `FilesChanged`, `Disabled`, `Accept`, `Multiple`, `HelperText`, `ErrorText`.

Reglas adicionales:
1. Mantener alcance base y evitar APIs infladas.
2. Reusar `MxFieldGroup` para consistencia de accesibilidad y mensajes.
3. Evitar exponer API vendor; si se encapsula framework-level, mantener contrato Mx estable.
4. Reflejar siempre cambios del Grupo 5 en `/showcase` y documentación técnica.
