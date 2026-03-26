# MachSoft.Template.Core.Control

Catálogo oficial de controles `Mx*` para MachSoft sobre Blazor.

## Propósito
- Exponer contratos públicos de catálogo listos para consumo por aplicaciones Server y WebAssembly.
- Reutilizar la base de design system desde `MachSoft.Template.Core` sin acoplar lógica de negocio.
- Distribuirse como paquete NuGet interno con static web assets.

## Uso rápido
1. Referenciar el paquete `MachSoft.Template.Core.Control`.
2. Incluir estilos:
   - `_content/MachSoft.Template.Core/css/machsoft-template-core.css`
   - `_content/MachSoft.Template.Core.Control/css/machsoft-template-core-control.css`
3. Configurar tema con `data-mx-theme="light|dark"` en el contenedor raíz.

## Controles públicos (lote inicial consolidado)
- Actions: `MxButton`, `MxIconButton`
- Feedback: `MxAlert`, `MxProgress`, `MxToast`
- Overlays: `MxTooltip`, `MxDialog`, `MxPopup`
- Inputs: `MxTextField`, `MxTextArea`, `MxCheckbox`, `MxRadio`, `MxSwitch`, `MxSelect`
- Selection: `MxAutocomplete`, `MxMultiSelect`, `MxComboBox`
- DateTime: `MxDatePicker`, `MxDateRangePicker`, `MxTimePicker`
- Upload: `MxUpload`
- Lists: `MxList`, `MxListBox`, `MxAvatar`, `MxChip`
- Data: `MxDataGrid` (sorting/selección/toolbar/actions/summaries base)

## Alcance y límites actuales
- `MxDialog` incluye apertura/cierre controlado, cierre por overlay/escape y foco inicial en el shell del diálogo.
- `MxDialog` **aún no implementa focus trap completo ni restore de foco al elemento invocador**.
- `MxPopup` funciona como popup liviano público y también como base reusable para overlays contextuales simples.
- `MxToast` es componente reusable con autocierre opcional; no es orquestador enterprise de canales/colas.
- `MxTooltip` es base simple de texto (hover/focus/open manual), sin motor avanzado de posicionamiento dinámico.

- Inputs base (TextField/TextArea/Checkbox/Radio/Switch/Select) incluyen helper/validation text, estados `disabled`/`invalid` y foco visible tokenizado.
- `MxSelect` ofrece versión simple de selección única; `ReadOnly` se representa con comportamiento equivalente a `disabled` + `aria-readonly`, porque el `<select>` nativo no soporta readonly real.
- Selection avanzada (Autocomplete/MultiSelect/ComboBox) incluye búsqueda local básica, estado `loading`, estado `empty/no-results`, soporte de teclado base (`ArrowUp/ArrowDown`, `Enter`, `Escape`) y contratos listos para evolucionar a providers async/remotos sin romper API.
- `MxAutocomplete` y `MxComboBox` sincronizan texto visible/valor seleccionado incluso sin binding externo de `SearchText`, y exponen atributos ARIA de estado (`aria-busy`, `aria-activedescendant`).
- `MxMultiSelect` incorpora navegación activa por teclado, selección por `Enter`, limpieza de filtro tras seleccionar y eliminación del último chip con `Backspace` cuando el filtro está vacío.
- DateTime base (DatePicker/DateRangePicker/TimePicker) usa inputs HTML nativos (`date`/`time`) con contratos mínimos (`Value/ValueChanged` y variantes start/end), más estados `disabled`/`readonly`/`invalid`.
- `MxUpload` usa `InputFile` nativo con selección simple o múltiple, resumen visual de archivos seleccionados y estado `Uploading` controlado por consumidor.
- Lists: `MxList` y `MxListBox` cubren visualización/selección ligera con estados base y teclado mínimo; `MxAvatar` y `MxChip` cubren identidad compacta, tags interactivos y remoción simple.
- `MxDataGrid` ofrece fase enterprise controlada: sorting básico por columna, selección simple/múltiple, toolbar opcional, acciones por fila y summary template ligero.
- `MxDataGrid` no incorpora en esta fase filtros avanzados, edición inline completa, export ni virtualización.

Todos los controles consumen tokens del package `MachSoft.Template.Core` y son compatibles con Blazor Server/WebAssembly.


## Consolidación de Inputs base (hardening)
- `MxTextField` y `MxTextArea`: agregan estado `Required`, mensajes helper/error enlazados por `aria-describedby`, y semántica consistente para `readonly`/`disabled`/`invalid`.
- `MxCheckbox`, `MxRadio` y `MxSwitch`: incorporan `Description` opcional para contexto adicional, `required` opcional y mejoras de foco/estado inválido.
- `MxRadio` mantiene agrupación mínima por `Name` (sin `RadioGroup` dedicado en esta fase).
- `MxSelect` mantiene baseline simple: `ReadOnly` se traduce a estado no interactivo (`disabled`) y conserva `aria-readonly` para explicitar intención semántica.

## Saneamiento de contratos públicos (2026-03-25)

Para evitar ambigüedades entre `MachSoft.Template.Core` y `MachSoft.Template.Core.Control`, se aplicó una delimitación explícita:

- **Todos los contratos `Mx*` públicos del catálogo viven en `MachSoft.Template.Core.Control.Models`.**
- `MachSoft.Template.Core` no expone controles públicos `Mx*` ni modelos de catálogo.

### Breaking changes declarados

- `MxButtonVariant` (Core.Control) fue reemplazado por `MxControlButtonVariant`.
- `MxDataGridColumn<TItem>` (Core.Control) fue reemplazado por `MxControlDataGridColumn<TItem>`.
- `MxSelectOption`, `MxInputOption` y variantes Mx* se mantienen en Core.Control para evitar ambigüedad de consumo entre paquetes.

### Naming consistency

- Se mantiene `MxTextArea` en Core.Control para evitar una migración disruptiva en consumidores actuales.
- La convergencia a `MxTextarea` queda pendiente para una versión mayor con plan de deprecación explícito.



## Cierre arquitectónico definitivo (2026-03-26)

`MachSoft.Template.Core.Control` queda como única superficie oficial de controles UI públicos `Mx*`.
