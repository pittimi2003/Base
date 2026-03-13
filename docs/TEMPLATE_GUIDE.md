# Template Guide

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
- Todo cambio reusable pasa por `/showcase` antes de adopción.
- No aceptar componentes foundation sin:
  - API clara y mínima,
  - uso en showcase,
  - documentación en guía/arquitectura.
- Evitar duplicación entre Server y WASM: si se repite, mover a `Core`.

## Dónde tocar estilos globales
- Variables y escala: `tokens.css`.
- Tipografía/base: `base.css`.
- Shell y layout: `layout.css`.
- Componentes: `components.css`.
- Helpers: `utilities.css`.
