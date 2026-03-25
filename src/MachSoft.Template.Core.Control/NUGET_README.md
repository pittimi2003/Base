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

## Alcance y límites actuales
- `MxDialog` incluye apertura/cierre controlado, cierre por overlay/escape y foco inicial en el shell del diálogo.
- `MxDialog` **aún no implementa focus trap completo ni restore de foco al elemento invocador**.
- `MxPopup` funciona como popup liviano público y también como base reusable para overlays contextuales simples.
- `MxToast` es componente reusable con autocierre opcional; no es orquestador enterprise de canales/colas.
- `MxTooltip` es base simple de texto (hover/focus/open manual), sin motor avanzado de posicionamiento dinámico.

- Inputs base (TextField/TextArea/Checkbox/Radio/Switch/Select) incluyen helper/validation text, estados `disabled`/`invalid` y foco visible tokenizado.
- `MxSelect` ofrece versión simple de selección única; `ReadOnly` se representa con comportamiento equivalente a `disabled` + `aria-readonly`, porque el `<select>` nativo no soporta readonly real.

Todos los controles consumen tokens del package `MachSoft.Template.Core` y son compatibles con Blazor Server/WebAssembly.


## Consolidación de Inputs base (hardening)
- `MxTextField` y `MxTextArea`: agregan estado `Required`, mensajes helper/error enlazados por `aria-describedby`, y semántica consistente para `readonly`/`disabled`/`invalid`.
- `MxCheckbox`, `MxRadio` y `MxSwitch`: incorporan `Description` opcional para contexto adicional, `required` opcional y mejoras de foco/estado inválido.
- `MxRadio` mantiene agrupación mínima por `Name` (sin `RadioGroup` dedicado en esta fase).
- `MxSelect` mantiene baseline simple: `ReadOnly` se traduce a estado no interactivo (`disabled`) y conserva `aria-readonly` para explicitar intención semántica.
