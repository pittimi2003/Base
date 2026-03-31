# AGENTS.md — Norma operativa obligatoria para el catálogo Mx*

## 1) Propósito normativo
Este archivo define reglas de ejecución obligatorias para cualquier agente que modifique el repositorio.
No es guía opcional ni texto descriptivo: es una norma de trabajo.
Su objetivo es evitar:
- evolución improvisada del catálogo `Mx*`,
- regresiones funcionales o visuales,
- divergencias entre Core, Showcase y templates,
- documentación falsa o no verificable.

## 2) Alcance
Aplica a todo el repositorio y a cualquier cambio en:
- `src/MachSoft.Template.Core.Control`
- `src/MachSoft.Template.Core.Control.Showcase`
- `src/MachSoft.Template.Official.Server/template-content`
- `src/MachSoft.Template.Official.Wasm/template-content`
- `docs/`

## 3) Topología real gobernada
Superficies mínimas que se deben considerar en cada cambio del catálogo:
- `src/MachSoft.Template.Core.Control`: implementación del catálogo `Mx*`.
- `src/MachSoft.Template.Core.Control.Showcase`: evidencia funcional/visual de referencia.
- `src/MachSoft.Template.Official.Server/template-content`: adopción en host Server.
- `src/MachSoft.Template.Official.Wasm/template-content`: adopción en host Wasm.
- `docs/`: contrato transversal, estado del catálogo y plantillas de documentación.

## 4) Regla de autoridad documental (precedencia)
Orden de autoridad obligatorio:
1. `docs/CONTROL_SYSTEM_CONTRACT.md`
2. `docs/components/Mx*.md` (cuando existan)
3. `AGENTS.md`
4. código existente

Regla explícita: si el código actual contradice la norma documental, **no** se asume que el código tiene razón. La contradicción se registra como `Divergencia detectada` y requiere resolución explícita.

## 5) Estado base asumido del catálogo
Estado oficial por defecto del catálogo actual: **usable pero no suficientemente gobernado**.
Prohibido declarar madurez alta sin evidencia verificable.

Etiquetas obligatorias cuando falte evidencia:
- `Pendiente de confirmar`
- `No verificado`
- `No documentado todavía`
- `Divergencia detectada`
- `Requiere revisión arquitectónica`

## 6) Principios operativos obligatorios
1. No convertir implementación accidental en contrato.
2. No afirmar capacidades no observables en código o evidencia de ejecución.
3. No cerrar cambios de `Mx*` sin revisar impacto en las 4 superficies (Core/Showcase/Server/Wasm).
4. No separar evolución visual de accesibilidad y comportamiento.
5. No aceptar cambios sin actualización documental mínima exigida.

## 7) Regla de no divergencia
Ningún cambio en un control `Mx*` se considera completo si no revisa impacto en:
- `Core.Control`
- `Showcase`
- `Template Server`
- `Template Wasm`

Si no hay adopción en templates, debe quedar explícito como `No verificado` o `Pendiente de adopción`, nunca como compatible implícito.

## 8) Protocolo obligatorio al modificar un control `Mx*`
1. Identificar contrato objetivo y alcance del cambio.
2. Clasificar cambio: `Compatible`, `Sensible` o `Breaking`.
3. Actualizar implementación en Core.Control.
4. Actualizar o crear evidencia en Showcase.
5. Verificar impacto en Template Server y Template Wasm.
6. Actualizar documentación requerida.
7. Ejecutar validación mínima.
8. Reportar resultado con evidencias y riesgos abiertos.

## 9) Protocolo obligatorio al crear un control `Mx*`
1. Justificar problema real que resuelve (no duplicar control existente).
2. Definir contrato mínimo transversal en `docs/CONTROL_SYSTEM_CONTRACT.md` (si aplica).
3. Implementar versión mínima usable en Core.Control.
4. Incluir escenario de Showcase que pruebe estados y eventos base.
5. Registrar estado inicial en `docs/CONTROL_CATALOG_STATUS.md` con madurez conservadora.
6. Integrar evidencia mínima en templates o marcar explícitamente `No verificado`.
7. No publicar contrato individual completo (`docs/components/Mx*.md`) sin solicitud explícita.

## 10) Reglas de API pública
1. Superficie pública con prefijo `Mx*`.
2. Parámetros explícitos, semántica estable y nombres consistentes.
3. No exponer contratos internos/vendor como API pública directa.
4. No eliminar/renombrar parámetros públicos sin clasificar el cambio como breaking.
5. Defaults deben documentarse o marcarse `No documentado todavía`.

## 11) Reglas de accesibilidad
1. Todo control interactivo debe tener nombre accesible verificable.
2. Estados `disabled`, `invalid`, `readonly` deben reflejar semántica real en markup.
3. `focus-visible` no se elimina sin alternativa equivalente.
4. Relación label/control y mensajes (`aria-describedby`) cuando aplique.
5. Si no está validado por prueba o evidencia, marcar `No verificado`.

## 12) Reglas de layout, sizing, scroll y estabilidad visual
1. Evitar cambios de tamaño inesperados entre estados (`default/hover/focus/invalid/loading`).
2. Definir comportamiento de overflow y scroll en contenedores de datos/overlay.
3. Evitar layout shift por loaders, iconos o mensajes de validación.
4. Cambios en spacing/dimensión deben pasar por tokens.
5. Si no hay evidencia de estabilidad cross-host, marcar `No verificado`.

## 13) Reglas de theming y tokens
1. No hardcodear colores/z-index/espaciados críticos si existe capa de tokens.
2. Cambios de tema deben mantener contraste operativo mínimo.
3. No copiar identidad visual de librerías externas.
4. Cualquier desviación temporal se registra como deuda explícita.

## 14) Reglas del Showcase
1. Showcase es evidencia ejecutable, no marketing.
2. Cada control modificado debe tener escenario de evidencia actualizado.
3. Escenarios deben cubrir al menos estado base + un estado excepcional.
4. No ocultar limitaciones; declararlas en texto técnico breve.

## 15) Reglas de Templates (Server/Wasm)
1. Templates validan adopción real del catálogo en hosts.
2. Si un control cambia y es usado en templates, ambos hosts deben revisarse.
3. Si no se adopta en templates, documentar explícitamente el motivo.
4. Prohibido afirmar paridad Server/Wasm sin evidencia verificable en ambos.

## 16) Regla para comparación futura con MudBlazor
1. MudBlazor es referencia comparativa futura, no autoridad automática.
2. No copiar identidad visual ni API por inercia.
3. Toda comparación debe registrar trade-offs y contexto de uso.
4. En esta fase, no ejecutar migraciones por “paridad visual”.

## 17) Clasificación de cambios
- **Compatible**: no rompe API pública ni comportamiento contractual declarado.
- **Sensible**: mantiene API pero cambia comportamiento, accesibilidad, estados o layout percibido.
- **Breaking**: rompe API pública, contratos documentados o comportamiento esperado por consumidores.

## 18) Entregables mínimos por cambio
1. Código actualizado en superficies impactadas.
2. Evidencia en Showcase.
3. Estado actualizado en documentación (al menos catálogo/contrato).
4. Registro de riesgos, deuda y aspectos `No verificado`.

## 19) Validación mínima obligatoria
Como mínimo en cada ejecución con cambios:
- restauración/compilación de solución o proyectos impactados,
- verificación de arranque del Showcase si hubo cambio visual/UX,
- comprobación de templates impactados.

Si alguna validación no corre por entorno, reportar como `No verificado` con causa concreta.

## 20) Prohibiciones explícitas
Prohibido:
1. Inventar semántica contractual no verificable.
2. Declarar compatibilidad cross-host sin evidencia.
3. Declarar accesibilidad garantizada sin comprobación.
4. Elevar madurez sin soporte técnico observable.
5. Cerrar tareas con divergencias no declaradas.
6. Crear contratos individuales `docs/components/Mx*.md` sin solicitud explícita.

## 21) Formato de salida obligatorio al cerrar tarea
La salida final del agente debe incluir:
1. Resumen técnico de cambios por archivo.
2. Validaciones ejecutadas con resultado.
3. Riesgos/deuda abierta.
4. Lista de puntos `No verificado`.
5. Clasificación de cambio (`Compatible`, `Sensible`, `Breaking`).
