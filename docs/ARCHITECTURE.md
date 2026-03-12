# MachSoft Template - Architecture

## Visión
Solución de plantilla corporativa Blazor con dos hosts (Server y WASM) sobre una base reusable única para maximizar consistencia y minimizar duplicación.

## Capas y responsabilidad
- **Capa común (`MachSoft.Template.Core`)**
  - Layout corporativo (`MainLayout`).
  - Componentes foundation (`PageContainer`, `BaseCard`, `AppMenuTile`, navegación base).
  - Páginas base (`Home`, `Showcase`).
  - Static web assets compartidos (`wwwroot/css/template/*`).
- **Capa host Server (`MachSoft.Template.Starter`)**
  - Bootstrap de Blazor Server.
  - Rutas de host + página demo de starter.
- **Capa host WASM (`MachSoft.Template.Starter.Wasm`)**
  - Bootstrap de Blazor WebAssembly.
  - `index.html` de cliente, rutas de host y página demo WASM.
- **Capa de ejemplo (`MachSoft.Template.SampleApp`)**
  - App de validación funcional consumiendo el Core.

## Decisiones de diseño
1. **RCL como base compartida**: permite reutilizar componentes, layout y CSS en Server y WASM sin copias.
2. **Hosts delgados**: cada starter contiene solo bootstrap/runtime y páginas mínimas específicas.
3. **CSS por capas**: `tokens`, `base`, `layout`, `components`, `utilities` para crecimiento mantenible.
4. **Navegación genérica**: sin acoplamiento a servicios ni negocio legacy.

## Convenciones
- Prefijo obligatorio `MachSoft.Template.*`.
- Foundation en `src/MachSoft.Template.Core/Components/Foundation`.
- Estilos globales en `src/MachSoft.Template.Core/wwwroot/css/template`.
- Hosts en `template/` (Server y WASM), muestra en `samples/`.

## Separación Server vs WASM
- **Común**: UI, layout y estilos (Core).
- **Server**: renderizado interactivo en servidor + `blazor.web.js`.
- **WASM**: renderizado cliente + `blazor.webassembly.js` e `index.html` propio.
