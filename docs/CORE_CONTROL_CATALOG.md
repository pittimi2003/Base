# MachSoft.Template.Core.Control — enfoque técnico inicial

## Objetivo
Definir el catálogo oficial `Mx*` como paquete NuGet distribuible y host de validación desacoplado.

## Separación de responsabilidades
- `MachSoft.Template.Core`: base del design system (tokens, theming, utilidades, contratos compartidos).
- `MachSoft.Template.Core.Control`: catálogo oficial de controles con API pública y static web assets propios.
- `MachSoft.Template.Core.Control.Showcase`: aplicación host para validación visual/funcional.

## Estructura base de `Core.Control`
- `Components/`
- `Styles/`
- `Internal/`
- `Models/`
- `Services/`
- `wwwroot/css/machsoft-template-core-control.css`

## Roadmap de familias preparado
- Actions
- Inputs
- Selection
- DateTime
- Feedback
- Display
- Data
- Upload
- Scheduling

## Consolidación del Showcase (iteración actual)
- Shell estable con navegación persistente, encabezado de contexto y área de contenido uniforme.
- Toggle light/dark aplicado en `ms-control-shell` mediante `data-mx-theme` para validar tokens semánticos sin acoplarse al host.
- Patrón reusable para páginas por familia con estructura fija:
  - encabezado (título + descripción + metadata),
  - sección de ejemplo base,
  - sección de variantes,
  - sección de estados,
  - sección de notas técnicas/visuales.
- Bloques de preview estándar (`ShowcasePreviewBlock`) para evitar páginas improvisadas y sostener consistencia de spacing/surfaces.

## Endurecimiento visual y de theming
- `Core.Control` expone utilidades base reutilizables (`mx-control-host`, `mx-control-surface`, `mx-control-focusable`) para asegurar superficies y foco visibles con tokens semánticos en cualquier host.
- Showcase concentra alias CSS locales para spacing/radius/border/focus/elevation, reduciendo duplicación y sobreespecificación.
- Navegación y bloques de preview incluyen `hover`/`active`/`focus-visible` consistentes para validación real de accesibilidad visual en light/dark.

Tokens consolidados para la base visual:
- Superficies: `--mx-color-bg-canvas`, `--mx-color-bg-surface`, `--mx-color-bg-surface-muted`, `--mx-color-bg-surface-raised`.
- Texto: `--mx-color-text-primary`, `--mx-color-text-secondary`, `--mx-color-text-muted`.
- Bordes/foco: `--mx-color-border-subtle`, `--mx-color-border-default`, `--mx-color-border-focus`, `--mx-focus-ring-width`, `--mx-focus-ring-offset`.
- Espaciado y forma: `--mx-space-semantic-*`, `--mx-radius-*`.
- Elevación/movimiento: `--mx-shadow-1`, `--mx-shadow-2`, `--mx-motion-duration-fast`, `--mx-motion-ease-standard`.

## Validación en Showcase
- Home del catálogo.
- Foundations visuales (`/foundations`).
- Families (`/families`) con acceso a plantillas por categoría (`/families/{key}`).
- Toggle de tema light/dark con superficies de comparación explícitas.

## Consolidación 2026-03-25 — lote público Actions/Feedback/Overlays

Ajustes de endurecimiento aplicados:
- Accesibilidad reforzada en botones (`aria-busy`, loading text para lector, `aria-pressed` en icon button).
- `MxDialog` con foco inicial en shell al abrir, `aria-labelledby`/`aria-describedby` y comportamiento responsive mejorado.
- `MxToast` con `OnDismiss`, rol semántico por severidad y uso explícito en stack simple de Showcase.
- `MxTooltip` con `aria-describedby`, modo `Open` opcional para QA y preservación de API simple.
- `MxPopup` aclarado como popup liviano público + base reusable para overlays contextuales simples.

Límites conocidos (vigentes):
- `MxDialog` aún no implementa focus trap completo ni restore de foco al invocador.
- `MxToast` no implementa orquestador enterprise (canales/colas globales).
- `MxTooltip` no incluye motor avanzado de posicionamiento dinámico.


## Consolidación 2026-03-25 — inputs base públicos

Cobertura implementada en `MachSoft.Template.Core.Control`:
- `MxTextField` y `MxTextArea`: binding por `Value/ValueChanged`, soporte de `Label`, `Placeholder`, `HelperText`, `ValidationText`, estados `disabled`, `readonly` e `invalid`.
- `MxCheckbox` y `MxSwitch`: contrato booleano (`Checked/CheckedChanged`) con foco visible y estado `invalid` visual opcional.
- `MxRadio`: selección única simple por `Name`, `Value`, `SelectedValue/SelectedValueChanged` (sin orquestador de grupos complejo en esta iteración).
- `MxSelect`: selección simple por `Options` (`MxSelectOption`), `Value/ValueChanged`, placeholder y estado `invalid`; `ReadOnly` se mapea a deshabilitado + `aria-readonly` por limitación nativa de HTML.

Alcance deliberadamente fuera en esta iteración:
- Multiselección avanzada, búsqueda/autocompletado, providers remotos/async, plantillas complejas y composición con DataGrid.

Showcase actualizado (`/families/inputs`) con ejemplos base, variantes y estados para validar light/dark en un solo host desacoplado.


### Frontera arquitectónica aplicada (corrección)
- `MachSoft.Template.Core` mantiene foundation, tokens y utilidades; sus implementaciones históricas de forms `Mx*` quedan explícitamente como compatibilidad legacy interna.
- `MachSoft.Template.Core.Control` concentra la familia pública oficial de inputs base y su API estable de catálogo.
- `MachSoft.Template.Core.Control.Showcase` es el host oficial para validar esta familia (`/families/inputs`).


## Hardening 2026-03-25 — inputs base
- Se alinearon estados y semántica de accesibilidad en los seis controles base (`disabled`, `readonly`, `invalid`, `required`, `focus-visible`).
- `Checkbox/Radio/Switch` incorporan `Description` opcional para contexto sin inflar la API.
- `Radio` mantiene agrupación mínima por `Name`; limitación documentada para evitar pseudo-abstracciones tempranas.
- `Select` mantiene alcance baseline y documenta explícitamente que `ReadOnly` se implementa como estado no interactivo por limitación HTML nativa.

## Iteración 2026-03-25 — Selection avanzada (lote inicial usable)

Cobertura implementada en `MachSoft.Template.Core.Control`:
- `MxAutocomplete`: búsqueda local sobre `Items` (`MxInputOption`), sugerencias visibles en popup/listbox, selección simple (`Value/ValueChanged`) y texto de búsqueda (`SearchText/SearchTextChanged`), con estados `disabled`, `invalid`, `loading` y `no-results`.
- `MxMultiSelect`: selección múltiple real sobre `Options` (`MxInputOption`), chips removibles de seleccionados, filtro local por texto y popup/listbox multiselección (`SelectedValues/SelectedValuesChanged`).
- `MxComboBox`: control intermedio input + selector con apertura/cierre controlable (botón + teclado), búsqueda local y selección única.

Decisiones de diseño de esta iteración:
- API pública simple y homogénea entre los tres controles (label, helper/error text, estados base y binding explícito).
- Sin dependencias externas ni wrappers vendor; implementación en Blazor + HTML/CSS tokenizado.
- Se evita `datalist` y `select multiple` como mecanismo final de estos controles.
- Base accesible inicial: roles `combobox`/`listbox`/`option`, `aria-expanded`, `aria-controls`, `aria-selected`, `aria-invalid` y foco visible.

Límites abiertos (explícitos):
- Sin virtualización, sin provider async remoto y sin templates avanzadas en esta iteración.
- Navegación de teclado deliberadamente básica para sostener simplicidad inicial.
- Cierre por foco implementado en capa Blazor sin orquestación avanzada de focus management global.

Showcase actualizado:
- Nueva validación funcional visible en `/families/selection` con ejemplos de:
  - básico,
  - búsqueda,
  - estado vacío / sin resultados,
  - disabled / invalid,
  - loading (cuando aplica),
  - verificación light/dark en el mismo host desacoplado.

## Consolidación 2026-03-25 — hardening de Selection + Showcase

Correcciones aplicadas sobre `MxAutocomplete`, `MxComboBox` y `MxMultiSelect`:
- Se normalizó el comportamiento de texto visible y valor seleccionado para evitar desincronización cuando `SearchText` no está bindeado externamente.
- Se reforzó la navegación por teclado base (`ArrowUp`, `ArrowDown`, `Enter`, `Escape`) con salto de opciones deshabilitadas.
- Se mejoró la semántica accesible de estados dinámicos con `aria-busy` y `aria-activedescendant` en la familia avanzada.
- `MxMultiSelect` incorpora navegación activa de opciones, selección por teclado y eliminación rápida del último chip con `Backspace` cuando el filtro está vacío.

Correcciones de Showcase:
- Se mantuvo `Selection` como familia independiente y visible en `/families/selection`, separada de `Inputs` base para evitar mezclar niveles de madurez.
- Se verificó que `/families/selection` y `/families/inputs` renderizan ejemplos funcionales reales (sin bloque placeholder) para familias implementadas.

Corrección de static assets:
- El host `MachSoft.Template.Core.Control.Showcase` eliminó la referencia a `MachSoft.Template.Core.Control.Showcase.styles.css` porque el proyecto no usa CSS isolation (`*.razor.css`) y por tanto ese asset no se genera.
- Con esto se elimina el 404 real de estilos en runtime sin introducir workarounds frágiles.

## Iteración 2026-03-25 — DateTime + Upload (base funcional)

Cobertura implementada en `MachSoft.Template.Core.Control`:
- `MxDatePicker`: selección simple de fecha con `DateOnly?` (`Value/ValueChanged`), límites opcionales (`Min/Max`) y estados `disabled`, `readonly`, `invalid`, `required`.
- `MxDateRangePicker`: rango básico por `StartValue/EndValue` (`DateOnly?`) con callbacks separados (`StartValueChanged`, `EndValueChanged`) y semántica de grupo accesible.
- `MxTimePicker`: selección simple de hora con `TimeOnly?`, `Step` configurable y estados base homogéneos con inputs del catálogo.
- `MxUpload`: carga de archivos sobre `InputFile` nativo con `FilesChanged`, soporte `Multiple`, `Accept`, estado visual `Uploading` y resumen de archivos seleccionados.

Decisiones de alcance:
- Se priorizó compatibilidad cross-hosting (Server/WASM) con HTML + Blazor nativo, sin dependencias externas ni JS interop obligatorio.
- Se evita cerrar diseño con features enterprise prematuras (timezone complejo, calendarios ricos, drag & drop avanzado, validación remota de archivos).
- APIs públicas se mantienen mínimas y evolutivas, reutilizando patrones ya establecidos en inputs (`Label`, helper/error text, `invalid/disabled/readonly`).

Showcase actualizado:
- `/families/datetime` ahora contiene ejemplos funcionales reales para `MxDatePicker`, `MxDateRangePicker` y `MxTimePicker` (básico + estados).
- `/families/upload` incluye flujo funcional de `MxUpload` con estado uploading y notas explícitas de límites actuales.
- El selector de tema del shell de Showcase deja de usar botón y pasa a `MxSwitch` real del catálogo para validar light/dark usando componentes productivos.

## Iteración 2026-03-25 — Consolidación runtime DateTime + Upload

Ajustes aplicados en `MachSoft.Template.Core.Control`:
- `MxDatePicker` y `MxTimePicker`: parseo invariante explícito (`DateOnly?` / `TimeOnly?`), `aria-readonly`, y bloqueo de `ValueChanged` cuando el control está `ReadOnly` o `Disabled`.
- `MxDateRangePicker`: límites cruzados (`start.max = min(EndValue, Max)`, `end.min = max(StartValue, Min)`) para reducir estados inconsistentes en runtime; se mantiene callback independiente por extremo.
- `MxUpload`: selección robusta con `GetMultipleFiles(1)` cuando `Multiple=false`, resumen con `aria-live`, y deshabilitación automática del input cuando `Uploading=true` para evitar selecciones concurrentes.
- `MxSwitch`: normalización del parseo de `ChangeEventArgs` (`bool` o `string`) para evitar desincronización en hosts con diferencias de serialización.

Validación funcional en Showcase:
- `/families/datetime`: verificación de render y binding de `MxDatePicker`, `MxDateRangePicker` y `MxTimePicker`, incluyendo estados `disabled`, `invalid` y `readonly`.
- `/families/upload`: verificación de selección single/multiple, visualización de resumen y estado `Uploading` sin errores de host.
- Selector de tema del shell: `NavMenu` usa `MxSwitch` (`#mx-showcase-theme-switch`) y sincroniza `data-mx-theme` del shell entre `light` y `dark`.

Limitación abierta (documentada):
- `readonly` en inputs nativos `type="date"`/`type="time"` no es homogéneo entre navegadores. Se conserva `aria-readonly` y se bloquea propagación de cambio para consistencia, pero la UI nativa puede permitir abrir picker según engine.
