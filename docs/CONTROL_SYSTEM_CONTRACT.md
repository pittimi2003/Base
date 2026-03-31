# CONTROL_SYSTEM_CONTRACT.md — Contrato transversal obligatorio del sistema Mx*

## 1) Propósito y ámbito
Este documento define el contrato transversal obligatorio para el sistema de controles `Mx*`.
Su función es prevenir cuatro fallas recurrentes:
1. convertir implementación accidental en contrato oficial,
2. introducir regresiones sin trazabilidad,
3. divergir entre Core, Showcase y hosts,
4. mantener documentación no verificable.

Aplica a todo cambio que impacte alguno de estos artefactos:
- `src/MachSoft.Template.Core.Control`
- `src/MachSoft.Template.Core.Control.Showcase`
- `src/MachSoft.Template.Official.Server/template-content`
- `src/MachSoft.Template.Official.Wasm/template-content`
- `docs/`

## 2) Artefactos gobernados
1. Componentes `Mx*` (`.razor` y modelos asociados).
2. Estilos y tokens del catálogo.
3. Showcase como evidencia ejecutable.
4. Templates Server/Wasm como evidencia de adopción host.
5. Documentación contractual y de estado.

## 3) Definiciones normativas
- **Contrato**: comportamiento y API que consumidores pueden asumir como estables.
- **Evidencia**: prueba observable en código, showcase, template o validación ejecutada.
- **No verificado**: afirmación sin evidencia suficiente.
- **Divergencia detectada**: diferencia explícita entre norma y código o entre hosts.
- **Control usable pero no gobernado**: control funcional sin contrato completo ni validación suficiente.

## 4) Objetivos obligatorios del sistema
1. Estabilidad de API pública de controles `Mx*`.
2. Trazabilidad de cambios funcionales, visuales y de accesibilidad.
3. No divergencia entre Core, Showcase y templates.
4. Documentación alineada con evidencia real.
5. Gestión explícita de deuda técnica y aspectos no verificados.

## 5) Arquitectura contractual del catálogo
Arquitectura normativa mínima:
- **Núcleo contractual transversal**: este archivo (`CONTROL_SYSTEM_CONTRACT.md`).
- **Contratos individuales**: `docs/components/Mx*.md` (cuando existan por decisión explícita).
- **Estado operativo del catálogo**: `docs/CONTROL_CATALOG_STATUS.md`.
- **Plantilla oficial de control**: `docs/components/_CONTROL_TEMPLATE.md`.

## 5.1) Taxonomía oficial de families del catálogo `Mx*`
Las families oficiales permitidas para clasificación del inventario son:
- `Infrastructure`
- `Actions`
- `Inputs`
- `Collections`
- `Data`
- `Overlays`
- `Feedback`
- `Display`
- `Scheduling`

No usar etiquetas alternativas en el inventario sin actualizar previamente este contrato transversal.

## 5.2) Semántica formal de decisión (`Keep`, `Refactor`, `Redesign`, `Rebuild`)
- **Keep**: mantener arquitectura y API principal; solo correcciones menores o deuda acotada.
- **Refactor**: reestructurar implementación interna sin romper contrato público declarado.
- **Redesign**: rediseñar comportamiento/UX y reglas del control manteniendo, cuando sea viable, compatibilidad progresiva.
- **Rebuild**: reemplazo estructural mayor (potencialmente breaking) por inviabilidad técnica/contractual del diseño actual.

## 6) Regla de autoridad y precedencia
Orden de autoridad obligatorio:
1. `docs/CONTROL_SYSTEM_CONTRACT.md`
2. `docs/components/Mx*.md` (si existe)
3. `AGENTS.md`
4. código existente

Regla de resolución: si el código contradice la norma documental, no se asume validez automática del código. Debe abrirse acción correctiva y registrar `Divergencia detectada`.

## 7) Contrato transversal de API pública
1. Todo control público del catálogo debe usar prefijo `Mx`.
2. API pública debe ser explícita, estable y versionable.
3. Cambios en parámetros/eventos se clasifican como `Compatible`, `Sensible` o `Breaking`.
4. No exponer APIs vendor como contrato público principal.
5. Sin evidencia de estabilidad, marcar `Pendiente de confirmar`.

### 7.1) Convenciones obligatorias de naming y binding
Las siguientes convenciones son **obligatorias** para controles que apliquen:
1. Parámetro de valor principal: `Value`.
2. Evento de cambio asociado: `ValueChanged` (`EventCallback<TValue>`), con `TValue` consistente con `Value`.
3. Soporte de binding bidireccional mediante `@bind-Value`.
4. Estados de interacción: `Disabled` y `ReadOnly` (sin abreviaciones ni nombres alternos públicos).
5. Extensión de estilo: `Class` y `Style`.
6. Atributos HTML adicionales: `AdditionalAttributes` con `[Parameter(CaptureUnmatchedValues = true)]`.
7. Contenido proyectado principal: `ChildContent`.
8. Colección de opciones/datos (cuando aplique): `Items`.
9. Variantes visuales: `Variant`.
10. Escala/tamaño visual: `Size`.

Reglas adicionales obligatorias:
- No mezclar convenciones paralelas para el mismo concepto (`IsDisabled`, `CssClass`, etc.) en API pública nueva.
- Si un control no usa alguno de estos parámetros por su naturaleza, documentar el motivo en catálogo como `No documentado todavía` o `No aplica`.
- Introducir alias por compatibilidad solo de forma temporal y con plan explícito de retirada.

## 8) Contrato transversal de comportamiento
1. Cada control debe declarar comportamiento base y comportamiento en estados excepcionales.
2. Side effects no documentados están prohibidos.
3. Si comportamiento depende del host y no está validado, marcar `No verificado`.
4. Comportamientos implícitos observados en implementación no se promocionan a contrato sin revisión.

## 9) Contrato transversal de estados visuales
Estados mínimos a considerar (cuando aplique):
- default
- hover
- focus-visible
- active/pressed
- disabled
- loading
- invalid/error
- empty/no-data

Si un estado no está implementado o no está evidenciado, debe declararse como `No documentado todavía` o `No verificado`.

## 10) Contrato transversal de accesibilidad
1. Nombre accesible en controles interactivos.
2. Semántica correcta de `disabled`, `readonly`, `invalid`.
3. Asociación label/control y mensajes auxiliares cuando aplique.
4. Navegación por teclado para interacciones críticas.
5. Si no hay validación suficiente, clasificar `Pendiente de confirmar`.

## 11) Contrato transversal de layout, dimensiones y scroll
1. Cambios no deben introducir layout shift evitable.
2. Dimensiones críticas deben ser consistentes entre estados.
3. Reglas de overflow/scroll deben ser explícitas para grid, overlays y listas.
4. En ausencia de evidencia cross-host, etiquetar `No verificado`.

## 12) Contrato transversal de theming, tokens y estilos
1. Colores, spacing, radios, sombras y z-index críticos deben derivarse de tokens.
2. No copiar identidad visual de librerías externas.
3. Cambios de tema deben conservar legibilidad y contraste operativo.
4. Excepciones temporales se registran como deuda técnica explícita.

## 13) Contrato transversal de composición y extensibilidad
1. Priorizar composición de controles sobre variantes ad hoc.
2. Evitar feature creep sin justificación de uso repetido.
3. Extensiones deben mantener estabilidad del contrato base.
4. Cuando no haya claridad de diseño, marcar `Requiere revisión arquitectónica`.

## 14) Contrato transversal de hosts
Ningún cambio en `Mx*` se considera completo sin revisar impacto en:
- Core.Control
- Showcase
- Template Server
- Template Wasm

Compatibilidad cross-host solo se declara con evidencia en ambos templates o validación equivalente.

## 15) Contrato del Showcase
1. Showcase es evidencia de comportamiento y estado, no vitrina comercial.
2. Cada control del catálogo debe tener evidencia en Showcase (total o parcial, explícita).
3. Escenarios deben exponer límites y no ocultar deuda.
4. Si falta escenario relevante, registrar `Pendiente de confirmar`.

## 16) Contrato de Templates
1. Templates son prueba de adopción real del catálogo en hosts.
2. Si un control impacta flujos usados en templates, revisar Server y Wasm.
3. Si no hay adopción, registrar `No verificado` para ese host.
4. No declarar paridad sin evidencia bilateral.

## 17) Matriz de madurez del control (unificada)
Niveles enteros válidos: `Nivel 0`, `Nivel 1`, `Nivel 2`, `Nivel 3`, `Nivel 4`, `Nivel 5`.
**No existe `Nivel 0.5`.**

- **Nivel 0**: existe en código, sin evidencia mínima ejecutable en Showcase.
- **Nivel 1**: usable con evidencia mínima en Showcase, sin evidencia bilateral en templates y con deuda contractual.
- **Nivel 2**: evidencia en Showcase + evidencia en Template Server y Template Wasm, aún con deuda contractual abierta.
- **Nivel 3**: contrato transversal aplicado + checklist contractual parcial evidenciado + validación técnica básica.
- **Nivel 4**: validación cross-host sostenida + accesibilidad y regresión con evidencia recurrente.
- **Nivel 5**: contrato completo por control, validación sostenida y gobernanza estable sin divergencias abiertas críticas.

Regla actual de base: sin evidencia fuerte, clasificar conservadoramente en `Nivel 0-2`.

## 17.1) Umbral normativo para pasar de `CONTROL_CATALOG_STATUS.md` a `docs/components/Mx*.md`
Un control **solo puede** pasar a contrato individual cuando cumple simultáneamente:
1. Madurez mínima `Nivel 3`.
2. Evidencia vigente en Showcase (estado base + estado excepcional + interacción/evento).
3. Evidencia bilateral en Template Server y Template Wasm, o justificación explícita `No verificado` aprobada como excepción temporal.
4. API pública alineada con sección 7.1 (naming/binding).
5. Sin `Divergencia detectada` crítica abierta entre contrato transversal, inventario y código.
6. Registro explícito de riesgos/deuda y condición de salida.

Si no se cumplen todos los puntos, el control permanece en `CONTROL_CATALOG_STATUS.md`.

## 18) Clasificación de cambios
- **Compatible**: mantiene API y comportamiento contractual declarado.
- **Sensible**: mantiene API pero modifica comportamiento, accesibilidad o layout perceptible.
- **Breaking**: rompe API pública o contrato declarado.

Toda clasificación debe justificarse en la salida final del agente.

## 19) Política de documentación obligatoria por cambio
Cada cambio en `Mx*` debe actualizar como mínimo:
1. `docs/CONTROL_CATALOG_STATUS.md` (estado y evidencia).
2. este contrato transversal si cambian reglas globales.
3. contrato individual `docs/components/Mx*.md` solo si existe y fue solicitado su mantenimiento.

Prohibido afirmar hechos no verificados en documentación.

## 20) Política de validación obligatoria por cambio
Validación mínima:
1. build del ámbito impactado,
2. revisión de evidencia en Showcase,
3. revisión de impacto en templates Server/Wasm,
4. reporte explícito de validaciones no ejecutadas.

Si una validación no corre, no se sustituye con suposición; se etiqueta `No verificado`.

## 21) Criterios para aceptar, rechazar o aplazar mejoras
- **Aceptar**: problema claro, alcance controlado, evidencia actualizada, sin contradicción contractual.
- **Rechazar**: cambia contrato sin justificación, introduce divergencia, o afirma capacidades no verificadas.
- **Aplazar**: requiere decisión arquitectónica, falta evidencia técnica, o depende de deuda previa.

## 22) Política de deuda técnica explícita
Toda deuda debe registrarse con:
1. descripción concreta del riesgo,
2. impacto esperado,
3. superficie afectada,
4. condición de salida,
5. estado (`Pendiente`, `En curso`, `Resuelta`).

Deuda no documentada se considera incumplimiento de contrato.

## 23) Salidas obligatorias al trabajar contra este contrato
La salida final de una tarea debe incluir:
1. resumen de cambios por archivo,
2. clasificación del cambio (`Compatible`, `Sensible`, `Breaking`),
3. validaciones ejecutadas y resultado,
4. lista de puntos `No verificado`,
5. riesgos/deuda abiertos,
6. divergencias detectadas (si existen).
