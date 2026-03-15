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
- Estructura Home/Menu: convertida a composición oficial `MxPageHeader`, `MxPanel/MxCard` y `AppMenuTile` como helper de navegación.

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
- Se incorpora dark mode funcional cross-host (Server/WASM) con toggle en layout y persistencia en `localStorage` (`mx-theme`).



## Fase 14 - Preparación de NuGet
- Se formaliza `src/MachSoft.Template.Core` como artefacto empaquetable.
- Se define metadata de paquete (`MachSoft.Template.Core`) y README embebido de consumo.
- Se valida empaquetado `dotnet pack` en `Release` con generación de `.nupkg` y `.snupkg`.
- Se valida consumo desde proyecto limpio externo referenciando paquete local.


## Fase 15 - Template corporativo oficial
- Se define `template/MachSoft.Template.Official` como base oficial para `dotnet new`.
- Se separa explícitamente el runtime reusable (`MachSoft.Template.Core`) del bootstrap de apps nuevas.
- El template oficial excluye material de showcase/demo/samples para reducir ruido de arranque.
- Se valida flujo E2E real: instalación de template, creación de app nueva, restore/build/run con shell/theming activos.

## Fase 16 - Operacionalización y release interna
- Se formaliza release interna operable `v1.0.0-internal`.
- Se documenta flujo operativo real de NuGet en `src/MachSoft.Template.Core/NUGET_README.md`.
- Se documenta flujo operativo real del template oficial en `template/MachSoft.Template.Official/README.md` y `docs/TEMPLATE_GUIDE.md`.
- Se incorpora checklist ejecutable de release interna (`docs/INTERNAL_RELEASE_CHECKLIST.md`).
- Se incorpora baseline operativa mínima repetible (`docs/OPERATIONS_BASELINE.md`).
- Se refuerza guía de adopción por equipos con enfoque práctico y límites reales (`docs/ADOPTION_GUIDE.md`).
