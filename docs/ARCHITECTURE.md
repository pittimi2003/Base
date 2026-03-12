# MachSoft Template - Architecture

## Visión
Solución de plantilla corporativa Blazor con dos hosts (Server y WASM) sobre una base reusable única para maximizar consistencia y minimizar duplicación.

## Capas y responsabilidad
- **Capa común (`MachSoft.Template.Core`)**
  - Layout corporativo desacoplado (`MainLayout`, `AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`).
  - Componentes foundation (`PageContainer`, `BaseCard`, `AppMenuTile`, navegación base).
  - Páginas base (`Home`, `Showcase`).
  - Static web assets compartidos (`wwwroot/css/template/*`).
- **Capa host Server (`MachSoft.Template.Starter`)**
  - Bootstrap de Blazor Server.
  - Registro del root component + `AddAdditionalAssemblies(...)` para páginas enrutable del Core.
  - Páginas específicas de host (ej. `/demo`).
- **Capa host WASM (`MachSoft.Template.Starter.Wasm`)**
  - Bootstrap de Blazor WebAssembly.
  - `index.html` de cliente y páginas específicas de host (ej. `/wasm-demo`).
- **Capa de ejemplo (`MachSoft.Template.SampleApp`)**
  - App de validación funcional consumiendo el Core.

## Decisiones de diseño
1. **RCL como base compartida**: componentes/layout/CSS únicos para Server y WASM.
2. **Layout en subcomponentes**: `MainLayout` liviano que delega shell/header/nav/footer.
3. **Foundation con variantes mínimas**: `BaseCard` (`default|elevated|outlined|muted`), `AppMenuTile` (`default|elevated|muted`) y `PageContainer` con modo `Compact`.
4. **CSS por capas**: `tokens`, `base`, `layout`, `components`, `utilities` con escala y tokens comunes.
5. **Hosts delgados**: Server/WASM solo resuelven runtime/bootstrap.

## Convenciones
- Prefijo obligatorio `MachSoft.Template.*`.
- Foundation en `src/MachSoft.Template.Core/Components/Foundation`.
- Layout en `src/MachSoft.Template.Core/Layout`.
- Estilos globales en `src/MachSoft.Template.Core/wwwroot/css/template`.
- Hosts en `template/` (Server y WASM), muestra en `samples/`.

## Separación Server vs WASM
- **Común**: UI, layout y estilos (Core).
- **Server**: renderizado interactivo en servidor + `blazor.web.js`.
- **WASM**: renderizado cliente + `blazor.webassembly.js` e `index.html` propio.
