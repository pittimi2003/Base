# Template Guide

## Estado de versión del template
- Baseline actual: **`v1.0.0-internal`**.
- Objetivo: primera versión interna lista para adopción en proyectos reales.
- Convención recomendada: semver con sufijo `-internal` mientras no se publique externamente.

## Arranque desde variante Server
1. Abrir `MachSoft.Template.sln`.
2. Ejecutar `template/MachSoft.Template.Starter`.
3. Validar rutas: `/`, `/showcase`, `/demo`.

## Arranque desde variante WASM
1. Abrir `MachSoft.Template.sln`.
2. Ejecutar `template/MachSoft.Template.Starter.Wasm`.
3. Validar rutas: `/`, `/showcase`, `/wasm-demo`.

## Contratos Foundation (API estable)
- `PageContainer`
  - `Title`, `Description`, `IsCompact`.
  - Usar como wrapper de primer nivel por página.
- `BaseCard`
  - `Title`, `BadgeText`, `Variant: SurfaceVariant`, `IsCompact`.
  - Usar `Variant` para intención visual; evitar combinar estilos ad-hoc.
- `AppMenuTile`
  - `Title`, `Description`, `Href`, `Icon`, `Variant: TileVariant`.
  - Usar para accesos de navegación/resumen, no para formularios.

## Base mínima de formularios
- `FormSection`: contenedor de bloque de formulario.
- `SectionTitle`: título + descripción de sección.
- `FieldGroup`: etiqueta, control y hint.

## Reglas de composición
- `PageContainer + BaseCard` es la combinación por defecto para páginas de negocio.
- Usar `IsCompact=true` solo en subsecciones densas o anidadas.
- `SurfaceVariant.Outlined`: estructura/base neutral.
- `SurfaceVariant.Elevated`: destacar bloque prioritario.
- `SurfaceVariant.Muted`: contenido secundario o contexto.
- Promover a Foundation solo si el patrón se repite en Server y WASM y no contiene lógica de dominio.
- Mantener local al host/app si es específico del flujo de negocio.

## Navegación lateral colapsable
- Patrón adoptado: **Opción A**.
  - Desktop: sidebar visible por defecto y sin overlay.
  - Tablet/mobile: sidebar flotante + overlay.
- `AppShell` controla estado de menú (`IsMenuOpen`) sin JavaScript.
- `AppHeader` expone botón hamburguesa para abrir/cerrar navegación (solo visible en tablet/mobile).
- `AppNavigation` muestra sidebar flotante en tablet/mobile.
- Overlay gris (`.ms-shell__overlay`) aparece únicamente con menú abierto en tablet/mobile y cubre toda la pantalla.

### Reglas de cierre automático del menú
1. Clic en overlay.
2. Clic fuera del sidebar (área de contenido principal).
3. Selección de opción en el menú (`SideNav` notifica `OnItemSelected`).
4. Clic nuevamente en hamburguesa.
5. Tecla `Escape`.

## Accesibilidad mínima obligatoria del shell
- Hamburguesa con `aria-label`, `aria-controls`, `aria-expanded` y `aria-haspopup`.
- Sidebar con `id` estable (`ms-app-navigation`), `role="navigation"`, `aria-label` y `aria-hidden` sincronizado.
- Overlay con `id` estable (`ms-shell-overlay`) y `aria-label` para cierre.
- Foco visible con `:focus-visible` en hamburguesa, overlay y links laterales.
- En apertura mobile/tablet, el foco se mueve al panel de navegación para navegación por teclado.

## Pruebas E2E del shell (Playwright)
- Ubicación: `tests/e2e`.
- Ejecución:
  1. `cd tests/e2e`
  2. `npm install`
  3. `npm run install:browsers`
  4. `npm test`
- Scripts DX disponibles:
  - `npm run test:mobile`
  - `npm run test:desktop`
  - `npm run test:headed`
  - `npm run test:ui`
  - `npm run test:ci`
  - `npm run test:ci:prepared` (instala browsers + ejecuta CI)
- Cobertura mínima:
  - Mobile/Tablet: visibilidad de hamburguesa, apertura menú, overlay visible, cierre por overlay/item/Escape.
  - Desktop: sidebar visible por defecto, overlay oculto, hamburguesa oculta y navegación funcional entre rutas base (`/`, `/showcase`, `/demo`).

### Prerrequisitos y restricciones de red
- Node.js 18+.
- La descarga de browsers depende de CDN de Playwright (o mirror corporativo).
- Si hay restricciones de red, usar `PLAYWRIGHT_DOWNLOAD_HOST` y/o `PLAYWRIGHT_BROWSERS_PATH`.
- Ver detalle operativo en `tests/e2e/README.md`.

### Endurecimiento para runner/contenedor
- Playwright configurado en headless con flags de contenedor (`--no-sandbox`, `--disable-dev-shm-usage`).
- `webServer.timeout` ampliado para evitar falsos negativos por arranque lento del host.
- `reuseExistingServer: false` para evitar conectar contra procesos viejos en puerto compartido.
- Scripts de test con puertos dedicados (`test:mobile`/`test:desktop`/`test:ci`) para reducir colisiones de puerto en runner.
- Espera explícita de handshake Blazor Server (`/_blazor/negotiate` + websocket `/_blazor?id=...`) antes de interacciones E2E para estabilizar eventos `@onclick`.
- Readiness del shell reforzada con marcador `data-ms-shell-interactive="true"` + validación de hamburguesa visible/habilitada antes de click en mobile/tablet.
- Arranque del host E2E con `dotnet build` + `dotnet run --no-build` para mayor estabilidad en contenedor/CI.
- Projects separados por spec para evitar ejecución cruzada de escenarios desktop/mobile.

### Recomendación CI mínima
1. `cd tests/e2e`
2. `npm ci`
3. `npm run install:browsers`
4. `npm run test:ci`

Cache recomendada: `~/.cache/ms-playwright` (o el path configurado en `PLAYWRIGHT_BROWSERS_PATH`).

## Governance Rules
- **Qué entra en Core**:
  - layout, componentes y estilos reutilizables cross-host,
  - primitivas visuales sin lógica de negocio,
  - contratos estables que reduzcan duplicación entre Server/WASM.
- **Qué no entra en Core**:
  - lógica de negocio,
  - integraciones de infraestructura,
  - UI específica de un solo flujo/módulo de producto.
- **Cuándo promover algo a Foundation**:
  1. hay uso repetido real en más de un contexto,
  2. el contrato es mínimo y explícito,
  3. existe demo en `/showcase`,
  4. se actualiza documentación técnica.
- **Cuándo exigir actualización de `/showcase`**:
  - cuando cambia API/contrato de foundation,
  - cuando se agrega variante visual reusable,
  - cuando se modifica comportamiento esperado del layout común.
- **Cuándo exigir actualización de E2E**:
  - cambios en comportamiento del shell responsive,
  - cambios de accesibilidad/navegación del menú lateral,
  - cambios de sincronización de interactividad que afecten timings.
- **Cuándo exigir actualización de docs**:
  - cambio arquitectónico,
  - cambio en reglas de composición/gobernanza,
  - cambio de scripts, prerrequisitos o flujo de adopción.

## Adopción operativa
- Referencia principal de adopción y checklist: `docs/ADOPTION_GUIDE.md`.
- Usar esta guía al iniciar nuevos proyectos sobre `Starter` o `Starter.Wasm`.


## Dark mode (light/dark)
- Activo por defecto con arquitectura de tokens semánticos en `design-system/themes`.
- Toggle de modo en header (`🌙/☀️`) para alternar entre `light` y `dark`.
- Persistencia en `localStorage` (`mx-theme`) y aplicación por `data-mx-theme` en root.
- El modo oscuro afecta shell, navigation, cards, formularios base y showcase sin hardcodes por vista.

## MachSoft Design System (base formal)
- Documento de referencia: `docs/MACHSOFT_DESIGN_SYSTEM_FOUNDATION.md`.
- Tokens oficiales del sistema: `src/MachSoft.Template.Core/wwwroot/css/template/design-system/`.
- `tokens.css` centraliza imports de primitives + semantic + themes y mantiene compatibilidad con tokens `--ms-*` para no romper componentes actuales.
- Objetivo de API pública de componentes: prefijo `Mx*` (MachSoft-first).

## Dónde tocar estilos globales
- Variables y escala: `tokens.css`.
- Tipografía/base: `base.css`.
- Shell y layout: `layout.css`.
- Componentes: `components.css`.
- Helpers: `utilities.css`.

## Catálogo de componentes Mx* · Grupo 1
La baseline incluye un primer lote de componentes públicos del Design System con contratos estables y enfoque cross-host:

- `MxButton`: CTA principal/secundaria/terciaria/destructiva con tamaños `Small|Medium|Large`.
- `MxIconButton`: acción compacta con icono y `AriaLabel` obligatorio.
- `MxCard`: superficie de contenido con header/body/footer opcionales y metadata.
- `MxBadge`: etiqueta de estado ligera (`Neutral|Brand|Success|Warning|Danger`).
- `MxPageHeader`: cabecera enterprise con `Title`, `Description`, `Metadata` y `Actions`.
- `MxPanel`: contenedor de bloque para filtros/contexto con header opcional.

### Reglas de uso rápidas
1. Priorizar `MxButton.Primary` para una sola acción principal por bloque.
2. `MxIconButton` siempre con `AriaLabel` descriptivo; no usar solo iconografía decorativa.
3. Usar `MxCard` para contenido principal y `MxPanel` para contexto secundario o utilitario.
4. `MxBadge` solo para señales breves de estado/metadata (evitar párrafos o labels extensos).
5. Validar cualquier cambio reusable en `/showcase` y mantener contraste en light/dark.
