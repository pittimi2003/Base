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
