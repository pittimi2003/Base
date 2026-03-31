# CONTROL_CATALOG_STATUS.md — Estado inicial gobernado del catálogo `Mx*`

## 1) Propósito
Este documento registra el estado real inicial del catálogo `Mx*` con criterio conservador.
No define contratos individuales por control.
No reemplaza `docs/CONTROL_SYSTEM_CONTRACT.md`.

## 2) Alcance de inspección aplicada en esta ejecución
Superficies inspeccionadas:
- `src/MachSoft.Template.Core.Control/Components`
- `src/MachSoft.Template.Core.Control.Showcase`
- `src/MachSoft.Template.Official.Server/template-content`
- `src/MachSoft.Template.Official.Wasm/template-content`

Regla de lectura aplicada:
- presencia en código ≠ contrato maduro,
- presencia en Showcase ≠ validación cross-host,
- ausencia de evidencia explícita en hosts => `No verificado` o `No`.

## 3) Criterio de madurez usado (conservador y unificado)
Niveles enteros válidos: `Nivel 0`, `Nivel 1`, `Nivel 2`, `Nivel 3`, `Nivel 4`, `Nivel 5`.
**No existe `Nivel 0.5`.**

- **Nivel 0**: existe en código, sin evidencia mínima ejecutable en Showcase.
- **Nivel 1**: usable con evidencia mínima en Showcase, sin evidencia bilateral en templates y con deuda contractual.
- **Nivel 2**: evidencia en Showcase + evidencia en Template Server y Template Wasm, aún con deuda contractual abierta.
- **Nivel 3**: contrato transversal aplicado + checklist contractual parcial evidenciado + validación técnica básica.
- **Nivel 4**: validación cross-host sostenida + accesibilidad y regresión con evidencia recurrente.
- **Nivel 5**: contrato completo por control, validación sostenida y gobernanza estable sin divergencias abiertas críticas.

Regla de ejecución en esta etapa: mantener clasificación conservadora y no promover niveles sin evidencia verificable.

## 3.1) Umbral normativo para habilitar contrato individual (`docs/components/Mx*.md`)
Un control puede salir de este inventario y pasar a contrato individual solo si cumple simultáneamente:
1. Madurez mínima `Nivel 3`.
2. Evidencia en Showcase (estado base + estado excepcional + interacción/evento).
3. Evidencia bilateral en Template Server y Template Wasm o excepción explícita `No verificado` con causa.
4. API pública alineada con convenciones obligatorias (`Value`, `ValueChanged`, `@bind-Value`, `Disabled`, `ReadOnly`, `Class`, `Style`, `AdditionalAttributes`, `ChildContent`, `Items`, `Variant`, `Size`) cuando aplique.
5. Sin `Divergencia detectada` crítica abierta.

Si no cumple el umbral, permanece en este inventario.

## 3.2) Taxonomía oficial de families
Families oficiales vigentes en el inventario:
- `Infrastructure`
- `Actions`
- `Inputs`
- `Collections`
- `Data`
- `Overlays`
- `Feedback`
- `Display`
- `Scheduling`

## 3.3) Semántica formal de decisión
- **Keep**: mantener arquitectura y API principal; solo correcciones menores o deuda acotada.
- **Refactor**: reestructurar implementación interna sin romper contrato público declarado.
- **Redesign**: rediseñar comportamiento/UX y reglas del control manteniendo, cuando sea viable, compatibilidad progresiva.
- **Rebuild**: reemplazo estructural mayor (potencialmente breaking) por inviabilidad técnica/contractual del diseño actual.

## 4) Inventario inicial por control

| Control | Family oficial | Ubicación | Showcase | Template Server | Template Wasm | Estado actual | Madurez | ¿Documentable ahora? | Decisión inicial | Riesgo / bloqueo |
|---|---|---|---|---|---|---|---|---|---|---|
| MxControlAssets | Infrastructure | `Components/MxControlAssets.razor` | Parcial | Sí | Sí | Con deuda contractual | Nivel 2 | Requiere revisión | Keep | Activo de infraestructura; propósito contractual exacto pendiente de formalizar. |
| MxButton | Actions | `Components/Actions/MxButton.razor` | Sí | Sí | Sí | Usable pero no gobernado | Nivel 2 | Requiere revisión | Keep | API visible en hosts, pero sin contrato individual formal. |
| MxIconButton | Actions | `Components/Actions/MxIconButton.razor` | Sí | Sí | Sí | Usable pero no gobernado | Nivel 2 | Requiere revisión | Keep | Riesgo de divergencia de a11y (aria/foco) sin validación formal registrada. |
| MxAlert | Feedback | `Components/Feedback/MxAlert.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Sin evidencia de adopción en templates. |
| MxProgress | Feedback | `Components/Feedback/MxProgress.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Semántica accesible pendiente de confirmar cross-host. |
| MxToast | Feedback | `Components/Feedback/MxToast.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Comportamiento temporal y cierre no verificado fuera de Showcase. |
| MxTooltip | Overlays | `Components/Overlays/MxTooltip.razor` | Sí | Sí | Sí | Usable pero no gobernado | Nivel 2 | Requiere revisión | Keep | Overlay y posicionamiento con riesgo de diferencias por host/render mode. |
| MxDialog | Overlays | `Components/Overlays/MxDialog.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Política de foco/escape/overlay pendiente de confirmación formal. |
| MxPopup | Overlays | `Components/Overlays/MxPopup.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Solapamiento funcional con MxDialog requiere revisión arquitectónica. |
| MxTextField | Inputs | `Components/Inputs/MxTextField.razor` | Sí | No | No | Usable pero no gobernado | Nivel 1 | No | Refactor | Binding/validación no evidenciados en templates. |
| MxTextArea | Inputs | `Components/Inputs/MxTextArea.razor` | Sí | No | No | Usable pero no gobernado | Nivel 1 | No | Refactor | Estados invalid/readonly sin validación cross-host. |
| MxSelect | Inputs | `Components/Inputs/MxSelect.razor` | Sí | No | No | Usable pero no gobernado | Nivel 1 | No | Refactor | Semántica readonly/disabled pendiente de confirmar fuera de Showcase. |
| MxCheckbox | Inputs | `Components/Inputs/MxCheckbox.razor` | Sí | No | No | Usable pero no gobernado | Nivel 1 | No | Refactor | Asociación label/control no verificada en hosts oficiales. |
| MxRadio | Inputs | `Components/Inputs/MxRadio.razor` | Sí | No | No | Usable pero no gobernado | Nivel 1 | No | Refactor | Navegación por teclado/grupo no validada en templates. |
| MxSwitch | Inputs | `Components/Inputs/MxSwitch.razor` | Sí | No | No | Usable pero no gobernado | Nivel 1 | No | Refactor | Diferencia potencial semántica switch/checkbox requiere revisión contractual. |
| MxAutocomplete | Inputs | `Components/Inputs/MxAutocomplete.razor` | Sí | No | No | Inconsistente | Nivel 1 | Requiere revisión | Redesign | Reglas de búsqueda/selección no formalizadas transversalmente. |
| MxMultiSelect | Inputs | `Components/Inputs/MxMultiSelect.razor` | Sí | No | No | Inconsistente | Nivel 1 | Requiere revisión | Redesign | Riesgo alto de complejidad de estados (vacío, filtrado, selección múltiple). |
| MxComboBox | Inputs | `Components/Inputs/MxComboBox.razor` | Sí | No | No | Inconsistente | Nivel 1 | Requiere revisión | Redesign | Solapamiento potencial con Autocomplete/MultiSelect. |
| MxDatePicker | Inputs | `Components/Inputs/MxDatePicker.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Formato/localización/validación de fecha no verificados cross-host. |
| MxDateRangePicker | Inputs | `Components/Inputs/MxDateRangePicker.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Reglas de consistencia inicio-fin pendientes de contrato. |
| MxTimePicker | Inputs | `Components/Inputs/MxTimePicker.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Semántica de formato/step no documentada todavía. |
| MxUpload | Inputs | `Components/Inputs/MxUpload.razor` | Sí | No | No | Pendiente de revisión | Nivel 1 | Requiere revisión | Redesign | Flujo de archivos, seguridad y límites de tamaño no verificados. |
| MxList | Collections | `Components/Collections/MxList.razor` | Sí | No | No | Usable pero no gobernado | Nivel 1 | No | Keep | Base simple, sin evidencia de uso host. |
| MxListBox | Collections | `Components/Collections/MxListBox.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Contrato de selección simple/múltiple pendiente de confirmar. |
| MxAvatar | Display | `Components/Display/MxAvatar.razor` | Sí | No | No | Usable pero no gobernado | Nivel 1 | No | Keep | Comportamiento de fallback de imagen no validado en hosts. |
| MxChip | Display | `Components/Display/MxChip.razor` | Sí | No | No | Con deuda contractual | Nivel 1 | No | Refactor | Interacción dismissible y semántica de estado no formalizadas. |
| MxDataGrid | Data | `Components/Data/MxDataGrid.razor` | Sí | Sí | Sí | Usable pero no gobernado | Nivel 2 | Requiere revisión | Keep | Alto impacto; requiere contrato fuerte antes de ampliar API. |
| MxScheduler | Scheduling | `Components/Scheduling/MxScheduler.razor` | Sí | No | No | Pendiente de revisión | Nivel 1 | Requiere revisión | Redesign | Componente enterprise sin evidencia en templates; riesgo de feature creep. |

## 5) Lectura ejecutiva del estado actual
1. El catálogo es funcional, pero sin gobernanza contractual suficiente.
2. La mayoría de controles están en **Nivel 1** (evidencia en Showcase, sin validación host).
3. Solo un subconjunto presenta evidencia en ambos templates (`MxButton`, `MxIconButton`, `MxTooltip`, `MxDataGrid`, `MxControlAssets`).
4. No hay base objetiva para asignar Nivel 3 o superior en esta ejecución.

## 5.1) Etapa 1 — Evaluación estructurada del lote de alta rentabilidad (`MxButton`, `MxIconButton`, `MxTooltip`)

### MxButton (Actions)
- **Evidencia real encontrada (Etapa 2A)**
  - Core: `MxButton` mantiene render condicional `button`/`a` y ahora expone `Style`, `AdditionalAttributes` y `Pressed` (nullable) para cerrar extensibilidad y estado toggle sin romper API existente.
  - Showcase: escenarios actualizados para estados (`disabled`, `loading`, `pressed`), modo link (`Href`) y link deshabilitado (`aria-disabled` + `tabindex=-1` + `preventDefault`).
  - Templates: Server/Wasm incorporan uso explícito de `Style`, `AdditionalAttributes`, link habilitado y link deshabilitado en `Packages`.
- **API pública observable**
  - Parámetros observables: `Variant`, `Size`, `Disabled`, `Loading`, `Pressed`, `Type`, `Href`, `Target`, `Rel`, `LeadingIcon`, `TrailingIcon`, `AriaLabel`, `LoadingText`, `Class`, `Style`, `AdditionalAttributes`, `OnClick`, `ChildContent`.
  - `Value`/`ValueChanged` no aplica por naturaleza de control de acción sin dato editable.
  - Se cierra divergencia previa de convención 7.1 para `Style` y `AdditionalAttributes`.
- **Estados observables**
  - Implementados y evidenciables: `default`, `hover`, `focus-visible`, `disabled`, `loading`, variantes visuales, tamaños (`small/medium/large`) y `pressed` (mediante `aria-pressed` cuando `Pressed` tiene valor).
  - `active` transitorio (pointer down) no se declara como contrato estable en esta etapa; contrato explícito de toggle se centra en `pressed`.
- **Accesibilidad mínima (evidencia trazable)**
  - Nombre accesible: se mantiene por texto visible (`ChildContent`) y puede reforzarse por `AriaLabel` en escenarios de link de templates.
  - Foco visible: `:focus-visible` sigue presente en `.mx-btn` del stylesheet común.
  - `Disabled` en botón nativo: se refleja con atributo `disabled` y bloqueo de `OnClick` por guard clause interna.
  - `Disabled` en modo link: se refleja con `aria-disabled="true"`, `tabindex=-1` y `@onclick:preventDefault`.
- **Divergencias entre hosts**
  - Server/Wasm muestran adopción equivalente en templates para API extendida y modo link.
  - No hay prueba automatizada de lector de pantalla ni registro instrumental de teclado end-to-end; se mantiene `No verificado` para esa capa.
- **Nivel de madurez actual justificado**
  - Se mantiene **Nivel 2** en esta ejecución: se cerró brecha contractual principal (`Style`/`AdditionalAttributes`) y se amplió evidencia funcional, pero persiste deuda de validación accesible runtime cross-host (teclado/AT) para umbral de `Nivel 3`.
- **¿Puede pasar a Nivel 3 ahora?**
  - **No todavía**. Queda pendiente evidencia runtime verificable de accesibilidad en ambos hosts (interacción teclado + lectura asistiva).
- **¿Listo para `docs/components/MxButton.md`?**
  - **No**. Aún no se cumple el umbral normativo completo de salida.
- **Qué falta exactamente para habilitar contrato individual**
  1. Evidencia de ejecución cross-host (Server/Wasm) para navegación por teclado y anuncio de estado pressed/disabled en tecnologías asistivas.
  2. Registro de validación manual o automatizada que convierta los puntos de accesibilidad hoy `No verificado` en evidencia trazable.

### MxIconButton (Actions)
- **Evidencia real encontrada**
  - Core: botón icon-only con `AriaLabel` requerido, `Pressed` opcional, `Disabled`/`Loading`, variantes y tamaños.
  - Showcase: ejemplos base, outlined, disabled, pressed y loading.
  - Templates: adopción real en panel de acciones de `GridWorkspace` (Server/Wasm) encapsulado con `MxTooltip`.
- **API pública observable**
  - Parámetros observables: `Icon`, `AriaLabel`, `Variant`, `Size`, `Type`, `Pressed`, `Disabled`, `Loading`, `LoadingText`, `Class`, `OnClick`.
  - **Divergencia detectada** frente a convención 7.1: faltan `Style` y `AdditionalAttributes`.
- **Estados observables**
  - Implementados: `default`, `hover`, `focus-visible`, `disabled`, `loading`, `pressed` (via `aria-pressed`), tamaños y variantes.
  - Estado `invalid`/`readonly`: no aplica por naturaleza del control.
- **Riesgos de accesibilidad**
  - `aria-pressed` se renderiza siempre (puede quedar vacío/null), requiere validación semántica en tecnologías asistivas (**Pendiente de confirmar**).
  - No hay evidencia automatizada/manual registrada de navegación por teclado y anuncio de estado pressed en hosts (**No verificado**).
- **Riesgos de layout/scroll**
  - Tamaños fijos (`width/height`) estabilizan layout; riesgo bajo de shift en icon-only.
  - Sin evidencia de comportamiento en contenedores con overflow/zoom alto en templates (**No verificado**).
- **Divergencias entre hosts**
  - Uso equivalente entre Server y Wasm en templates revisados.
  - Sin evidencia de divergencia visual declarable; paridad runtime de a11y sigue **No verificado**.
- **Nivel de madurez actual justificado**
  - Se mantiene **Nivel 2** por evidencia bilateral pero con deuda contractual y de validación a11y.
- **¿Puede pasar a Nivel 3 ahora?**
  - **No**. Falta validación contractual/a11y trazable y cierre de brechas de API transversal.
- **¿Listo para `docs/components/MxIconButton.md`?**
  - **No**.
- **Qué falta exactamente para habilitar contrato individual**
  1. Resolver contrato de extensibilidad (`Style`/`AdditionalAttributes` o excepción formal explícita).
  2. Evidencia accesible de `aria-pressed` (toggle) y foco por teclado en ambos hosts.
  3. Verificación funcional documentada de estados `disabled/loading/pressed` en templates, no solo presencia de markup.
  4. Validación técnica mínima trazable para promoción a Nivel 3.

### MxTooltip (Overlays)
- **Evidencia real encontrada**
  - Core: wrapper con `Text`, `Placement`, `Open`, `Focusable`, `Class`, `ChildContent`, `role="tooltip"` y `aria-describedby`.
  - Showcase: evidencia en `top/right/bottom`, hover/foco y modo forzado con `Open` para QA.
  - Templates: uso real alrededor de `MxIconButton` en action pane de `GridWorkspace` (Server/Wasm, placement `Right`).
- **API pública observable**
  - Parámetros observables: `Text`, `Placement`, `Open`, `Focusable`, `Class`, `ChildContent`.
  - **Divergencia detectada** frente a convención 7.1: sin `Style` ni `AdditionalAttributes`.
- **Estados observables**
  - Implementados: oculto por defecto; visible por `:hover`, `:focus-within` o `Open=true`.
  - Placements observables: `Top`, `Bottom`, `Left`, `Right`.
  - No hay motor de colisión/reposicionamiento dinámico.
- **Riesgos de accesibilidad**
  - `aria-describedby` se fija siempre; falta evidencia de que el contenido sea anunciado consistentemente en lectores en ambos hosts (**No verificado**).
  - `Focusable=false` deja el wrapper sin `tabindex`; la accesibilidad depende totalmente del hijo. Si el hijo no es focusable, tooltip por teclado puede no activarse (**Pendiente de confirmar**).
- **Riesgos de layout/scroll**
  - Burbuja `position:absolute`, `max-width:220px`, `z-index:1300`, sin estrategia de collision/viewport clipping; riesgo real en bordes, contenedores con overflow y scroll.
  - Sin evidencia de estabilidad visual cross-host en contenedores complejos (**No verificado**).
- **Divergencias entre hosts**
  - No se observan diferencias de adopción entre Server/Wasm en templates.
  - Diferencias de render mode/hidratación no validadas para timings de hover/focus/open (**No verificado**).
- **Nivel de madurez actual justificado**
  - Se mantiene **Nivel 2**: evidencia bilateral existe, pero deuda de overlay/a11y/validación impide Nivel 3.
- **¿Puede pasar a Nivel 3 ahora?**
  - **No**.
- **¿Listo para `docs/components/MxTooltip.md`?**
  - **No**.
- **Qué falta exactamente para habilitar contrato individual**
  1. Definir alcance contractual explícito de overlay (sin collision engine vs roadmap) y límites operativos.
  2. Evidencia de accesibilidad real (`aria-describedby`, foco teclado) en ambos hosts.
  3. Evidencia de estabilidad en escenarios con scroll/overflow y bordes de viewport.
  4. Cierre de brecha API transversal (`Style`/`AdditionalAttributes` o excepción formal).
  5. Validación técnica básica documentada para habilitar Nivel 3.

## 6) Reglas de uso de este inventario
1. Este archivo no autoriza cambios implícitos de contrato.
2. Si aparece nueva evidencia, actualizar fila correspondiente con trazabilidad.
3. Si hay duda, mantener clasificación conservadora.
4. No promover madurez sin evidencia técnica verificable.

## 7) Próximo paso recomendado (sin crear contratos individuales aún)
1. Cerrar divergencias de alto riesgo (overlays, inputs avanzados, data/scheduling).
2. Reforzar evidencia en templates para controles críticos.
3. Luego decidir qué controles pasan a contrato individual `docs/components/Mx*.md` en ejecuciones futuras.
