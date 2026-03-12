# MachSoft Template - Architecture

## Visión
Solución de plantilla corporativa Blazor con dos hosts (Server y WASM) sobre una base reusable única para maximizar consistencia y minimizar duplicación.

## Capas y responsabilidad
- **Capa común (`MachSoft.Template.Core`)**
  - Layout corporativo desacoplado (`MainLayout`, `AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`).
  - Foundation components (`PageContainer`, `BaseCard`, `AppMenuTile`) y base mínima de formularios (`FormSection`, `FieldGroup`, `SectionTitle`).
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
   - `BaseCard` usa `SurfaceVariant`.
   - `AppMenuTile` usa `TileVariant`.
3. **Compact mode explícito**: `IsCompact` en `PageContainer` y `BaseCard`.
4. **Token-first CSS**: spacing/radius/shadows/typography/z-index definidos por tokens.
5. **Sidebar responsive**: visible en desktop y colapsable en tablet/mobile con overlay gestionado en Blazor.

## Patrón de navegación lateral
- Estado de menú centralizado en `AppShell`.
- `AppHeader` dispara toggle de hamburguesa.
- `AppNavigation` renderiza panel lateral con prioridad visual (`z-index` mayor).
- Overlay gris cubre contenido cuando el menú está abierto y permite cierre por clic.
- `SideNav` notifica selección de ítem para cierre automático del menú.

## Governance Rules
- **Qué entra en Core**:
  - patrones visuales reutilizados por Server y WASM,
  - componentes sin dependencia de dominio.
- **Qué no entra en Core**:
  - lógica de negocio,
  - servicios de infraestructura host-specific,
  - UI de un único flujo local.
- **Aprobación de nuevos foundation components**:
  1. uso repetido real en al menos dos contextos,
  2. contrato mínimo y coherente,
  3. ejemplo en `/showcase`,
  4. guía/documentación actualizada.

## Separación Server vs WASM
- **Común**: UI, layout, contratos de componentes y estilos (Core).
- **Server**: renderizado interactivo en servidor + `blazor.web.js`.
- **WASM**: renderizado cliente + `blazor.webassembly.js` e `index.html` propio.
