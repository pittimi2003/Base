# Plantilla oficial de contrato individual `Mx*`

> **Regla anti-invención (obligatoria):**
> No afirmar comportamiento, accesibilidad, compatibilidad cross-host o madurez sin evidencia verificable.
> Si falta evidencia, usar explícitamente: `Pendiente de confirmar`, `No verificado`, `No documentado todavía`, `Divergencia detectada`, `Requiere revisión arquitectónica`.

---

## 1) Identificación del control
- Nombre: `Mx...`
- Familia tentativa:
- Ubicación en Core.Control:
- Estado en catálogo (`Usable pero no gobernado | Incompleto | Inconsistente | Con deuda contractual | Pendiente de revisión`):
- Nivel de madurez actual (`Nivel 0..5`):

## 2) Propósito exacto
- Propósito contractual:
- Evidencia usada para sustentar propósito:
- Campo obligatorio si no hay evidencia suficiente: `Pendiente de confirmar`.

## 3) Problema que resuelve
- Problema operativo concreto:
- Contextos donde aplica:
- Contextos donde **no** aplica:

## 4) Alcance funcional
- Capacidades incluidas:
- Límites explícitos de la versión actual:
- Casos no soportados:

## 5) No alcance funcional
- Lo que el control no debe hacer:
- Integraciones fuera de alcance:
- Razón de exclusión:

## 6) Dependencias y composición
- Dependencias técnicas internas:
- Dependencias visuales (tokens, clases base):
- Composición con otros controles `Mx*`:
- Dependencias externas (si existen):

## 7) API pública
- Parámetros públicos:
  - Nombre:
  - Tipo:
  - Default:
  - Requerido:
  - Contrato:
  - Evidencia:
- Eventos públicos:
  - Nombre:
  - Tipo:
  - Cuándo dispara:
  - Contrato:
  - Evidencia:

## 8) Contrato de binding y eventos
- Soporte `@bind-*`:
- Orden esperado de eventos:
- Semántica de actualización:
- Casos de concurrencia/duplicación de eventos:
- Estado si no está verificado: `No verificado`.

## 9) Estados del control
Para cada estado observado/documentado:
- Estado:
- Activador:
- Resultado esperado:
- Señales visuales:
- Señales semánticas:
- Evidencia:

Estados sugeridos (aplicar según control): default, hover, focus-visible, active, disabled, readonly, loading, invalid, empty.

## 10) Reglas de comportamiento
- Reglas determinísticas de interacción:
- Reglas de prioridad entre props:
- Reglas de fallback:
- Comportamientos no definidos todavía:

## 11) Reglas de accesibilidad
- Nombre accesible:
- Roles/atributos ARIA:
- Navegación por teclado:
- Gestión de foco:
- Mensajes de error/ayuda asociados:
- Estado de validación de a11y (`Verificado | No verificado | Pendiente de confirmar`):

## 12) Reglas de layout y sizing
- Dimensiones base:
- Variantes de tamaño:
- Comportamiento de overflow:
- Reglas de scroll:
- Estabilidad visual (evitar layout shift):
- Estado de verificación:

## 13) Reglas de theming y clases CSS
- Tokens consumidos:
- Clases públicas relevantes:
- Clases internas no contractuales:
- Reglas light/dark:
- Excepciones documentadas:

## 14) Host compatibility
- Evidencia en Showcase: `Sí | No | Parcial`
- Evidencia en Template Server: `Sí | No | No verificado`
- Evidencia en Template Wasm: `Sí | No | No verificado`
- Divergencias entre hosts:

## 15) Variantes y decisiones de diseño
- Variantes soportadas:
- Variante por defecto:
- Criterios para agregar/quitar variantes:
- Decisiones pendientes:

## 16) Escenarios de Showcase obligatorios
- Escenario mínimo 1 (estado base):
- Escenario mínimo 2 (estado excepcional):
- Escenario mínimo 3 (interacción/evento):
- Cobertura pendiente:

## 17) Escenarios de Template obligatorios
- Evidencia en Server:
- Evidencia en Wasm:
- Riesgo si no está adoptado:
- Plan de adopción (si aplica):

## 18) Riesgos y regresiones a vigilar
- Riesgo:
- Impacto:
- Señal temprana:
- Mitigación:

## 19) Casos pendientes / deuda aceptada
- Ítem de deuda:
- Motivo:
- Impacto:
- Estado:
- Criterio de salida:

## 20) Checklist de madurez
- [ ] API pública establecida y evidenciada
- [ ] Estados críticos evidenciados
- [ ] Accesibilidad mínima verificada
- [ ] Evidencia en Showcase actualizada
- [ ] Evidencia en Template Server
- [ ] Evidencia en Template Wasm
- [ ] Riesgos/deuda documentados
- [ ] Clasificación de madurez actualizada (`Nivel 0..5`)

## 21) Historial de decisiones
- Fecha:
- Decisión:
- Justificación:
- Impacto:
- Evidencia:

## 22) Backlog comparativo con MudBlazor (futuro)
> Solo referencia comparativa. No implica copia visual ni adopción automática.

- Referencia analizada:
- Gap detectado:
- ¿Aplica al contexto MachSoft?:
- Decisión (`Adoptar | Adaptar | Descartar | Pendiente`):
- Motivo:

## 23) Criterio de aceptación para modificar el control
Un cambio se acepta solo si:
1. respeta precedencia contractual,
2. clasifica el tipo de cambio (`Compatible | Sensible | Breaking`),
3. actualiza evidencia en Showcase,
4. revisa impacto en Server y Wasm,
5. declara explícitamente cualquier punto `No verificado`,
6. actualiza estado de madurez y deuda.
