# Migration Report

## Versión de referencia
- Baseline consolidado: **`v1.0.0-internal`**.

## Criterio de clasificación

### Grupo A - Migrar al template
- Patrón de shell con menú lateral + header + contenido (concepto general de `MainLayout` legacy).
- Landing de navegación por tarjetas (`Home`) como patrón reusable.
- Concepto de tokens visuales detectado en `site.css`.

### Grupo B - Adaptar
- Navegación drawer/breadcrumb legacy: simplificada a `SideNav` genérica.
- Estilos globales legacy: depurados en 5 capas CSS corporativas.
- Estructura Home/Menu: convertida en `AppMenuTile`, `BaseCard`, `PageContainer`.

### Grupo C - Descartar
- Páginas de negocio (Planning, Labor, Designer, Scenario, Alerts, etc.).
- Servicios/integraciones específicas (DataAccess, SignalR negocio, DevExpress legado).
- Dependencias a warehouse/proyectos/roles del sistema original.

## Extensión WASM (fase actual)

### Qué se creó para soportar WASM
- Proyecto real `template/MachSoft.Template.Starter.Wasm`.
- Bootstrap WebAssembly (`Program.cs` + `wwwroot/index.html`).
- Página de demostración específica `/wasm-demo`.
- Registro del proyecto WASM dentro de `MachSoft.Template.sln`.

### Qué se reutilizó
- `MainLayout`, foundation components y páginas base desde `MachSoft.Template.Core`.
- Sistema de estilos completo (`wwwroot/css/template/*`) sin duplicación.

### Qué se adaptó
- Router y enlaces de estilos en host WASM (`blazor.webassembly.js`).
- Navegación base ampliada con acceso a `WASM Demo`.

### Diferencias finales Server vs WASM
- **Server**: host con runtime interactivo de servidor.
- **WASM**: host standalone ejecutando en navegador.
- **Común**: toda la línea visual y componentes UI en Core.

## Resultado
La solución queda con base reusable común + starter Server + starter WASM + sample, sin dependencia estructural del legacy.


## Consolidación Design System MachSoft
- Se incorpora documento formal de base en `docs/MACHSOFT_DESIGN_SYSTEM_FOUNDATION.md`.
- Se introduce arquitectura de tokens `--mx-*` en `src/MachSoft.Template.Core/wwwroot/css/template/design-system/` (primitives, semantic, typography, motion, themes).
- Se mantiene compatibilidad temporal con `--ms-*` desde `tokens.css` para preservar adopción no destructiva del template actual.

