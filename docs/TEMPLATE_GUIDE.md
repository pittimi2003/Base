# Template Guide

## Fase 16 — Operacionalización interna
- Release interna vigente: **`v1.0.0-internal`**.
- Estado: plataforma **operable** para circuito paquete + template + app nueva.
- Documentos operativos: `docs/INTERNAL_RELEASE_CHECKLIST.md` y `docs/OPERATIONS_BASELINE.md`.

## Flujo operativo del template (resumen ejecutable)
1. Instalar template: `dotnet new install ./template/MachSoft.Template.Official`.
2. Crear app: `dotnet new machsoft-app -n <AppName> -o <output> --CorePackageVersion 1.0.0-internal`.
3. Si el feed no está configurado, agregar `nuget.config` con source local/interno.
4. Validar app generada: `dotnet restore`, `dotnet build -c Release`, `dotnet run --no-build -c Release`.
5. Smoke de app generada: `/`, `/operations`, `/settings`.

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
- `MxPageHeader`
  - `Title`, `Description`, `Actions`, `Metadata`.
  - Usar como encabezado de primer nivel por página.
- `MxCard` / `MxPanel`
  - `Title`, `Variant: SurfaceVariant`, `IsCompact` (según componente).
  - Usar `Variant` para intención visual; evitar estilos ad-hoc.
- `AppMenuTile`
  - `Title`, `Description`, `Href`, `Icon`, `Variant: TileVariant`.
  - Helper de navegación del template para accesos de resumen.

## Base mínima de formularios
- `MxFormSection`: contenedor de bloque de formulario con header y acciones opcionales.
- `MxFieldGroup`: etiqueta, control y helper/error para controles custom.
- Inputs base Mx: `MxTextField`, `MxTextarea`, `MxSelect`, `MxCheckbox`, `MxSwitch`.

## Reglas de composición
- `MxPageHeader + MxPanel/MxCard` es la combinación por defecto para páginas de negocio.
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

## Catálogo de componentes Mx* · Grupo 2 (Forms base)
Se incorporó la capa base de formularios del Design System:

- `MxTextField`
- `MxTextarea`
- `MxSelect`
- `MxCheckbox`
- `MxSwitch`
- `MxFieldGroup`
- `MxFormSection`

Componente auxiliar:
- `MxSelectOption` para opciones tipadas en selects.

### Criterio de implementación
- Grupo 2 se implementa como **componentes propios puros** (Blazor + HTML + CSS tokenizado).
- No se expone API de MudBlazor en contratos públicos.
- Se preserva posibilidad de wrappers internos futuros sin romper API `Mx*`.

### Reglas de uso rápidas
1. Usar `MxTextField/MxTextarea/MxSelect` para captura base con `HelperText`/`ErrorText`.
2. Usar `MxCheckbox` para flags y `MxSwitch` para toggles de configuración.
3. Usar `MxFieldGroup` para encapsular controles custom manteniendo contrato visual.
4. Agrupar formularios por contexto usando `MxFormSection`.
5. Validar siempre contraste y foco visible en `/showcase` light/dark al cambiar estilos de formularios.

## Catálogo de componentes Mx* · Grupo 3 (Navigation + Overlays)
Se incorporó una base reusable de navegación y overlays:

- `MxTabs`
- `MxDialog`
- `MxDrawer`
- `MxToast`
- `MxBreadcrumb`

Modelos auxiliares:
- `MxTabItem`
- `MxBreadcrumbItem`

### Criterio de implementación
- Grupo 3 implementado como componentes propios puros (Blazor + HTML + CSS tokenizado).
- API pública estable `Mx*` sin contratos vendor expuestos.

### Reglas de uso rápidas
1. Usar `MxTabs` para secciones hermanas con contenido alternable en contexto de página.
2. Usar `MxDialog` para confirmaciones o flujos cortos bloqueantes.
3. Usar `MxDrawer` para filtros/contexto lateral no destructivo.
4. Usar `MxToast` para feedback efímero no bloqueante.
5. Usar `MxBreadcrumb` para jerarquía de navegación de páginas enterprise.

## Catálogo de componentes Mx* · Grupo 4 (Data display + feedback)
Se incorporó la base de visualización informativa para dashboards y backoffice:

- `MxTag`
- `MxStatusIndicator`
- `MxEmptyState`
- `MxStatCard`
- `MxProgress`

### Reglas de uso rápidas
1. `MxTag` para etiquetar entidades operativas (lote, canal, prioridad).
2. `MxStatusIndicator` para estado vivo de procesos/servicios con lectura compacta.
3. `MxEmptyState` para módulos/listas sin datos con próxima acción clara.
4. `MxStatCard` para KPIs principales con contexto y tendencia.
5. `MxProgress` para progreso de tareas/lotes/importaciones con semántica accesible.

### Diferencias clave
- `MxBadge` = metadata UI.
- `MxTag` = etiqueta de entidad operativa.
- `MxStatusIndicator` = estado operativo compacto.

## Catálogo de componentes Mx* · Grupo 5 (Enterprise inputs)
Se incorporó la capa base de inputs enterprise:

- `MxDatePicker`
- `MxDateRangePicker`
- `MxAutocomplete`
- `MxMultiSelect`
- `MxFileUpload`

Modelo auxiliar:
- `MxInputOption`.

### Reglas de uso rápidas
1. `MxDatePicker` para fecha operativa única.
2. `MxDateRangePicker` para filtros por rango temporal.
3. `MxAutocomplete` para catálogos con búsqueda textual rápida.
4. `MxMultiSelect` para selección múltiple de estados/regiones/tags.
5. `MxFileUpload` para adjuntos de evidencia/lotes con validación en backend.

### Límites del alcance actual
- Baseline enfocada en contratos mínimos y consistentes.
- Comportamientos avanzados (virtualización, async remote search, drag-drop upload) quedan para iteraciones posteriores.

## Catálogo de componentes Mx* · Grupo 6 (Enterprise data)
Se incorporó una base de visualización de datos enterprise:

- `MxDataGrid`
- `MxTreeGrid`
- `MxChart`

### Reglas de uso rápidas
1. `MxDataGrid` para tablas operativas con columnas definidas por contrato.
2. `MxTreeGrid` para estructuras jerárquicas con drill-down básico.
3. `MxChart` para métricas de tendencia/capacidad con tipos `Bar` y `Line`.

### Límites del alcance actual
- Grid sin sorting/filtering/paging avanzados.
- Tree con estructura jerárquica simple y expand/collapse.
- Chart base sin capacidades analíticas avanzadas.

---

## Consolidación del Design System (iteración de adopción)

### Design System Layers
1. **Foundations**: tokens, tipografía, color, spacing y componentes base (`MxButton`, `MxCard`, `MxFormSection`, etc.).
2. **Components**: controles de entrada enterprise reutilizables (`MxDatePicker`, `MxAutocomplete`, `MxMultiSelect`, `MxFileUpload`).
3. **Data Components**: visualización enterprise de datos (`MxDataGrid`, `MxTreeGrid`, `MxChart`).
4. **Patterns**: composiciones recomendadas para pantallas reales (`MxSearchPanel`, `MxFilterBar`, `MxDashboardSection`, `MxMasterDetail`, `MxSettingsPage`).

### Legacy Components
Los siguientes componentes se mantienen solo para compatibilidad y deben evitarse en nuevas pantallas:
- `BaseCard` (usar `MxCard`)
- `PageContainer` (usar `MxPageHeader` + composición con `MxCard`/`MxPanel`)
- `FormSection` (usar `MxFormSection`)
- `FieldGroup` (usar `MxFieldGroup`)
- `SectionTitle` (usar header integrado de `MxFormSection`)

Todos están marcados como `LEGACY` y `Obsolete` en código fuente.

### Adoption Guide (screen blueprint)
Para construir una pantalla enterprise estándar:
1. Encabezado con `MxPageHeader`.
2. Búsqueda con `MxSearchPanel`.
3. Filtros horizontales con `MxFilterBar`.
4. KPIs con `MxDashboardSection` + `MxStatCard`.
5. Datos operativos con `MxDataGrid`.
6. Si aplica, usar `MxMasterDetail` para lista/detalle.

Referencia de inventario y clasificación: `docs/COMPONENT_INVENTORY.md`.


## Consumo de paquete NuGet local (pre-template corporativo)
1. Generar paquete local:
   - `dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o artifacts/nuget`
2. En el proyecto consumidor agregar fuente local `artifacts/nuget`.
3. Instalar paquete `MachSoft.Template.Core`.
4. Cargar assets `_content/MachSoft.Template.Core/css/template/*` y `_content/MachSoft.Template.Core/js/theme.js`.
5. Usar componentes `Mx*` desde los namespaces de `MachSoft.Template.Core`.

> Referencia operativa mínima dentro del paquete: `src/MachSoft.Template.Core/NUGET_README.md`.


## Fase 15 — Template corporativo oficial

### Base oficial definida
- Plantilla oficial: `template/MachSoft.Template.Official`.
- Tipo: `dotnet new` template para Blazor Server.
- Identidad: `MachSoft.Template.Official.Server`.
- Short name: `machsoft-app`.

### Qué incluye
- Shell/layout corporativo MachSoft (`AppShell`) con sidebar responsive y toggle de tema.
- Wiring de assets del runtime reusable (`_content/MachSoft.Template.Core/css/template/*` + `js/theme.js`).
- Navegación mínima (`Inicio`, `Operaciones`, `Configuracion`).
- Páginas iniciales útiles para bootstrap real (`/`, `/operations`, `/settings`).
- Referencia a `MachSoft.Template.Core` como paquete NuGet.

### Qué no incluye
- Rutas y páginas de validación interna (`/showcase`, `/demo`, `/wasm-demo`).
- Aplicaciones sample (`samples/*`).
- Artefactos de benchmark y pruebas E2E.
- Configuraciones no necesarias para un arranque productivo mínimo.

### Instalación y uso rápido
1. Empaquetar `MachSoft.Template.Core` para feed local:
   - `dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o ./.artifacts/local-nuget`
2. Instalar template local:
   - `dotnet new install ./template/MachSoft.Template.Official`
3. Crear aplicación nueva:
   - `dotnet new machsoft-app -n Contoso.Operations`
4. Restaurar con feed local + NuGet público:
   - `dotnet restore --source ./.artifacts/local-nuget --source https://api.nuget.org/v3/index.json`
5. Ejecutar:
   - `dotnet run`

### Relación template vs paquete NuGet
- `MachSoft.Template.Core` es el runtime reusable versionable y distribuible.
- `MachSoft.Template.Official` es el bootstrap corporativo para instanciar apps nuevas que consumen ese runtime.
- Evolución de UI reusable: se publica en `MachSoft.Template.Core`; adopción en apps nuevas: vía actualización de paquete.

### Limitaciones iniciales conocidas
- El template oficial se entrega en variante Server únicamente (WASM permanece como host de referencia dentro del repo).
- La restauración de una app generada requiere acceso al feed que publique `MachSoft.Template.Core` (local o corporativo).
