# MachSoft Templates

Repositorio de productización en .NET 8 para el ecosistema corporativo de templates MachSoft.

## Componentes


## Cierre arquitectónico definitivo (2026-03-26)

- `MachSoft.Template.Core` queda restringido a base técnica/visual/infrastructural (layout/shell, theming, tokens, utilidades y contratos no-catálogo).
- `MachSoft.Template.Core.Control` queda como **única** superficie oficial de controles públicos `Mx*`.
- Los templates oficiales Server/WASM consumen ambos paquetes, usando `Core` para baseline y `Core.Control` para UI catalogada.
- `MachSoft.Template.Core.Control.Showcase` se mantiene como host de validación visual/funcional del catálogo.


- `MachSoft.Template.Core`: paquete NuGet reusable (Razor Class Library).
- `MachSoft.Template.Official.Server`: template oficial `dotnet new` para **Blazor Web App** con **Razor Components + Interactive Server rendering**.
- `MachSoft.Template.Official.Wasm`: template oficial `dotnet new` para **Blazor WebAssembly**.
- `MachSoft.Template.Core.Control`: catálogo oficial `Mx*` empaquetable como NuGet (RCL).
- `MachSoft.Template.Core.Control.Showcase`: host separado para validación visual/funcional del catálogo.

## Estructura del repositorio

```text
.
├── build/
│   └── scripts/
├── docs/
├── src/
│   ├── MachSoft.Template.Core/
│   ├── MachSoft.Template.Core.Control/
│   ├── MachSoft.Template.Core.Control.Showcase/
│   ├── MachSoft.Template.Official.Server/
│   │   └── template-content/
│   └── MachSoft.Template.Official.Wasm/
│       └── template-content/
├── Directory.Build.props
├── Directory.Packages.props
├── MachSoft.Templates.sln
├── NuGet.config
└── README.md
```

## Requisitos

- .NET SDK 8.0.x
- PowerShell 7+ (para scripts en `build/scripts`)
- Acceso a feed interno para restaurar `MachSoft.Template.Core` y `MachSoft.Template.Core.Control`

## Restore

```powershell
dotnet restore MachSoft.Templates.sln
```

## Build

```powershell
dotnet build MachSoft.Templates.sln -c Release --no-restore
```

## Pack

### Pack Core

```powershell
dotnet pack ./src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o ./artifacts/packages
```

### Pack Server Template

```powershell
dotnet pack ./src/MachSoft.Template.Official.Server/MachSoft.Template.Official.Server.csproj -c Release -o ./artifacts/packages
```

### Pack Wasm Template

```powershell
dotnet pack ./src/MachSoft.Template.Official.Wasm/MachSoft.Template.Official.Wasm.csproj -c Release -o ./artifacts/packages
```

### Pack All (script)

```powershell
pwsh ./build/scripts/Pack-All.ps1
```

## Install templates

```powershell
dotnet new install ./artifacts/packages/MachSoft.Template.Official.Server.1.0.0-internal.nupkg
dotnet new install ./artifacts/packages/MachSoft.Template.Official.Wasm.1.0.0-internal.nupkg
```

## Generate

### Generate Server app

```powershell
dotnet new machsoft-server -n MyCompany.MyApp --CompanyName MyCompany --RootNamespace MyCompany.MyApp --CorePackageVersion 1.0.0-internal --CoreControlPackageVersion 1.0.0-internal
```

### Generate Wasm app

```powershell
dotnet new machsoft-wasm -n MyCompany.MyApp --CompanyName MyCompany --RootNamespace MyCompany.MyApp --CorePackageVersion 1.0.0-internal --CoreControlPackageVersion 1.0.0-internal
```

## Restore generated app

Configura primero el `NuGet.config` generado (URL del feed interno y habilitación de `MachSoftPrivate`) y luego ejecuta:

```powershell
dotnet restore
```

## Uninstall templates

```powershell
dotnet new uninstall MachSoft.Template.Official.Server
dotnet new uninstall MachSoft.Template.Official.Wasm
```

## Feed privado

Placeholder estándar usado en configuración:

```text
https://your-private-feed/v3/index.json
```

No incluir credenciales ni secretos en el repositorio.


## Control Catalog (nuevo)

- `MachSoft.Template.Core.Control` referencia `MachSoft.Template.Core` y publica static web assets del catálogo.
- `MachSoft.Template.Core.Control.Showcase` referencia explícitamente `MachSoft.Template.Core` + `MachSoft.Template.Core.Control` y sirve como entorno de validación visual y funcional (light/dark, navegación por familias, fundamentos).
- Integración requerida para theming del shell Core: incluir `_content/MachSoft.Template.Core/js/theme.js` además del CSS cuando se use `AppShell`.

### Pack Core.Control

```powershell
dotnet pack ./src/MachSoft.Template.Core.Control/MachSoft.Template.Core.Control.csproj -c Release -o ./artifacts/packages
```


### Estado actual del catálogo `Core.Control`

- Existe la **base arquitectónica y de empaquetado** (`RCL` + `NuGet`) para `MachSoft.Template.Core.Control`.
- Existe un **Showcase desacoplado** para validación visual/funcional.
- La implementación completa de todas las familias premium sigue pendiente para iteraciones posteriores (no está cerrada en esta etapa).


## Actualización 2026-03-24 — Core.Control lote 1
- `MachSoft.Template.Core.Control` incluye primera familia pública (`MxButton`, `MxIconButton`, `MxAlert`, `MxProgress`, `MxTooltip`, `MxDialog`, `MxToast`, `MxPopup`) con ejemplos en `Core.Control.Showcase`.
- El Showcase ahora expone validación por familias `Actions`, `Feedback` y `Overlays` con estados base (default, disabled, loading e interacción).

## Actualización 2026-03-25 — hardening lote 1 Core.Control
- Se consolidó la primera familia pública (`Actions`, `Feedback`, `Overlays`) con mejoras de accesibilidad, estados y consistencia visual.
- Se documentaron límites reales actuales de overlays (`dialog`, `toast`, `tooltip`, `popup`) antes de avanzar a nuevas familias.


## Actualización 2026-03-25 — familia List / ListBox / Avatar / Chip
- `MachSoft.Template.Core.Control` incorpora `MxList`, `MxListBox`, `MxAvatar` y `MxChip` como primera familia funcional de listados/identidad compacta.
- `Core.Control.Showcase` agrega la ruta `/families/listing` con ejemplos reales (básico, selected, disabled, invalid, interactive/removable) y validación light/dark.
- La iteración mantiene API mínima y extensible, sin dependencias externas ni acoplamiento por host.


## Actualización 2026-03-25 — MxDataGrid enterprise controlado (fase inicial)

- `MxDataGrid` evoluciona con sorting por columna, selección de filas (single/multiple), toolbar base, acciones por fila y summary template ligero.
- `MxDataGridColumn` agrega `Sortable`, `SortValueSelector` y `Key` para habilitar ordenamiento explícito sin romper el contrato previo.
- Showcase `/families/data` se consolida con ejemplos runtime de sorting/selección/toolbar/actions + estados empty/loading.
- Se mantiene alcance controlado: sin filtros avanzados, edición inline completa, export ni virtualización en esta fase.

## Actualización 2026-03-25 — MxDataGrid enterprise (consolidación runtime interactiva)

- `MxDataGrid` corrige consistencia de estado interno/externo de selección: ya no pierde selección en modo no controlado tras re-render y normaliza IDs inválidos en cambios de datos.
- Sorting enterprise mejora robustez y accesibilidad: headers con etiqueta ARIA de intención de orden, `aria-sort` consistente y fallback al `ValueSelector` cuando `Sortable=true` sin `SortValueSelector`.
- Se refuerza semántica de filas seleccionadas (`aria-selected`) y se evita summary en empty/loading para no mezclar estados.
- Showcase `/families/data` añade validación explícita de selección simple + múltiple y se incorpora prueba Playwright dedicada de runtime interactivo (sorting, selección, toolbar, row actions, summary y light/dark).


### Actualización catálogo (2026-03-25)
- `MachSoft.Template.Core.Control` incluye `MxScheduler` base funcional y su validación en `MachSoft.Template.Core.Control.Showcase` (`/families/scheduling`).

- Templates oficiales Server/WASM ahora componen el shell común `AppShell` de Core (sidebar desktop + hamburguesa responsive + theming por `theme.js`) para evitar navegación cruda por host.


## Actualización 2026-03-26 — AppShell corporativo offcanvas
- `AppShell` adopta navegación lateral tipo drawer/offcanvas oculta por defecto en desktop/mobile/tablet, con cierre por overlay, navegación, hamburguesa y tecla Escape.
- `AppHeader` queda fijo (48px) y estandariza composición: hamburguesa + home a la izquierda; alertas + usuario + pantalla completa a la derecha.
- Showcase, Official.Server y Official.Wasm quedan cableados explícitamente al `MainLayout` que usa `AppShell` para evitar derivaciones a layouts legacy.
- `AppFooter` se mantiene como parte del shell y ahora puede activarse/ocultarse por parámetro (`ShowFooter`).
