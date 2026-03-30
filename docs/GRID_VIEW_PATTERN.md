# Grid Workspace — Patrón Normativo Cross-Host (v2)

## 1) Definición del patrón Grid Workspace

El **Grid Workspace** es el patrón oficial para pantallas operativas de datos basadas en grid (listado + selección + acciones + detalle contextual) dentro del shell corporativo MachSoft.

Se usa cuando una vista requiere:
- operar registros en volumen,
- mantener acciones laterales,
- sostener un footer operativo fijo del workspace,
- mostrar detalle en panel derecho solo con selección activa.

### Hosts obligados a respetar este patrón

Este contrato es **obligatorio** y **sin excepciones** para:
- `MachSoft.Template.Core.Control.Showcase`,
- `MachSoft.Template.Official.Server` (template-content),
- `MachSoft.Template.Official.Wasm` (template-content).

No se permite comportamiento divergente entre hosts.

---

## 2) Contrato estructural obligatorio

### 2.1 Shell

- El shell se renderiza con `AppShell`.
- La vista grid debe usar `AppShellWorkspaceMode.Grid`.
- En modo grid, el shell aplica clases estructurales explícitas:
  - `.ms-shell--grid-workspace`
  - `.ms-shell__workspace--grid-workspace`
  - `.ms-shell__main--grid-workspace`

Estas clases son la base normativa para resolver altura útil y composición vertical sin heurísticas por host.

### 2.2 Workspace

La página grid debe usar:
- contenedor raíz: `.ms-grid-workspace-page`
- contenedor `MainContainer`: `.ms-grid-workspace-layout`
- área central: `.ms-grid-workspace`

### 2.3 Layout interno (middle)

`MiddleContent` se divide en dos zonas **obligatorias**:
1. zona de filas: `.ms-grid-workspace-rows-zone`
2. barra inferior del workspace: `.ms-grid-workspace-footer`

La composición es por `grid-template-rows: minmax(0, 1fr) auto`, por lo que el footer queda anclado al final del área útil visible del workspace.

### 2.4 Viewport scrollable

El viewport scrollable del grid debe ser explícito:
- `.ms-grid-workspace-viewport .mx-data-grid-scroll`

Ese es el único contenedor de scroll vertical del patrón grid.

### 2.5 Barra inferior del workspace

- El cierre visual de la pantalla grid es `.ms-grid-workspace-footer`.
- El footer global del `AppShell` no participa en esta composición (`ShowFooter=false` en layout grid).

### 2.6 Panel derecho (`RightContent`)

- `RightContent` solo se renderiza con selección activa.
- Sin selección activa:
  - `ShowRight=false`,
  - no se renderiza panel derecho,
  - no se usa empty-state para “simular” panel.

### 2.7 Header del grid

- El header del grid es sólido.
- Se resuelve desde base compartida (`layout.css` + `MxDataGrid`) con `--mx-data-grid-header-bg`.
- No se permite depender de parche CSS local por host.

---

## 3) Reglas obligatorias

1. **Mismo comportamiento en los 3 hosts** para layout, scroll, footer, panel derecho y header.
2. La vista tipo grid debe ocupar el alto útil del workspace.
3. **Prohibido** usar `calc(100vh - X)` para resolver altura útil del grid.
4. El scroll vertical debe ocurrir en `.mx-data-grid-scroll` dentro de `.ms-grid-workspace-viewport`.
5. **No** debe hacer scroll la página completa/documento en este patrón.
6. **No** usar footer global del `AppShell` como cierre visual de una vista grid.
7. `RightContent` no se renderiza sin selección.
8. Header del grid sólido desde base compartida.

---

## 4) Guía obligatoria para nuevas vistas tipo grid

### Paso a paso

1. Declarar la página con layout de grid:
   - Showcase: `Components/Layout/GridWorkspaceLayout.razor`
   - Server template: `Components/Layout/GridWorkspaceLayout.razor`
   - Wasm template: `Layout/GridWorkspaceLayout.razor`
2. Componer estructura con `MainContainer` y clases oficiales:
   - raíz `.ms-grid-workspace-page`
   - contenedor `.ms-grid-workspace-layout`
   - acciones `.ms-grid-workspace-actions`
   - workspace `.ms-grid-workspace`
   - rows `.ms-grid-workspace-rows-zone`
   - viewport `.ms-grid-workspace-viewport`
   - footer `.ms-grid-workspace-footer`
   - detalle `.ms-grid-workspace-detail`
3. Renderizar `RightContent` únicamente cuando `HasSelection == true` y `ShowRight == true`.
4. Mantener `MxDataGrid` dentro de `.ms-grid-workspace-viewport`.
5. No agregar estilos host-locales para resolver alto/scroll/footer del patrón.

### Qué no hacer

- No usar `:has(...)` para activar comportamiento de shell grid.
- No usar cálculos tipo `calc(100vh - X)` para altura crítica del workspace.
- No delegar el scroll al `body`, al documento o a contenedores ambiguos superiores.
- No renderizar panel derecho vacío sin selección.

### Checklist mínima de validación

- [ ] `GridWorkspaceLayout` usa `ShowFooter=false`.
- [ ] `GridWorkspaceLayout` usa `WorkspaceMode="AppShellWorkspaceMode.Grid"`.
- [ ] `.ms-grid-workspace-footer` queda visible al fondo del workspace.
- [ ] Scroll vertical ocurre en `.mx-data-grid-scroll`.
- [ ] `RightContent` no se renderiza cuando no hay selección.
- [ ] Header de `MxDataGrid` sólido y sticky.
- [ ] Mismo comportamiento en Showcase, Server y Wasm.

---

## 5) Diferencias prohibidas entre hosts

Queda explícitamente prohibido que una vista Grid Workspace se comporte de forma distinta entre:
- Showcase,
- Template Server,
- Template Wasm.

No se aceptan divergencias en:
- distribución vertical,
- contenedor scrollable,
- visibilidad/anclaje del footer de workspace,
- renderizado del panel derecho,
- fondo del header del grid.
