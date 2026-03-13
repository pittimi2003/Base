# MachSoft Design System Foundation

## 1) Resumen ejecutivo
MachSoft Design System (MDS) se define como un sistema propio, orientado a aplicaciones enterprise de operación, backoffice y dashboards. El benchmark externo en `design/benchmark/external-system` se usa solo como referencia de madurez (tokens, capas y estructura), sin adoptar su identidad o API.

Esta base inicial establece:
- identidad formal del sistema,
- foundations visuales,
- arquitectura de tokens `--mx-*`,
- estrategia de componentes MachSoft-first,
- patrones enterprise iniciales,
- lineamientos de governance,
- integración no destructiva con `MachSoft.Template` (Server y WASM).

---

## 2) Principios del MachSoft Design System (Fase 0)

### Principios
1. **Precisión operativa**: UI enfocada en decisiones rápidas y errores mínimos.
2. **Claridad jerárquica**: información crítica visible primero.
3. **Consistencia transversal**: mismos contratos visuales en Server/WASM.
4. **Densidad equilibrada**: alta productividad sin saturación visual.
5. **Neutralidad profesional**: estilo sobrio, técnico, no consumer.
6. **Evolución gobernada**: cambios via showcase, docs y validación técnica.

### Perfil de usuarios objetivo
- Operadores de procesos.
- Supervisores de turno/área.
- Analistas de datos operativos.
- Administradores funcionales de plataforma.
- Equipos de backoffice enterprise.

### Tono visual
- Profesional, técnico, claro, moderno, sobrio y preciso.
- Alto contraste funcional para lectura en jornadas largas.
- Componentes con señal semántica explícita (éxito, alerta, error, info).

### Relación marca MachSoft ↔ UI
- La identidad parte del logo MachSoft (base cromática azul corporativa + neutrales técnicos).
- Marca en UI como **sistema de señales** (acciones primarias, foco, navegación activa), no como decoración excesiva.
- El branding se traduce en tokens semánticos y contratos reutilizables, no en estilos ad-hoc por página.

---

## 3) Foundations definidas (Fase 1)

### Color system
- **Brand**: escala azul (`brand-50..900`) para acciones primarias y estados activos.
- **Neutrals**: escala gris-azulada (`neutral-0..900`) para superficies, texto y bordes.
- **Semantic states**: success/warning/danger/info para feedback operativo.
- **Data colors**: paleta de 6 colores para dashboards/charts con contraste entre series.

### Typography
Jerarquía base:
- Display: 2rem / 700
- H1: 1.5rem / 600
- H2: 1.25rem / 600
- H3: 1.125rem / 600
- Subtitle: 1rem / 500
- Body: 0.9375rem / 400
- Caption: 0.8125rem / 400
- Mono: 0.8125rem / 500

Familias:
- Sans: `Segoe UI`, `Inter`, Roboto, Arial.
- Mono: `Cascadia Mono`, Consolas, monospace.

### Spacing scale
Escala tokenizada de `0` a `9` (`0`, `0.25rem`, `0.5rem`, `0.75rem`, `1rem`, `1.5rem`, `2rem`, `2.5rem`, `3rem`, `4rem`).

### Border radius
Sistema sobrio: `none`, `sm (6px)`, `md (10px)`, `lg (14px)`, `pill`.

### Shadows / elevation
- `shadow-0`: none
- `shadow-1`: bajo (cards base)
- `shadow-2`: medio (superficies elevadas)
- `shadow-3`: alto (overlays/paneles prioritarios)

### Border / stroke
- `border-width-1` como default estructural.
- `border-width-2` para énfasis puntual (focus/active states).

### Breakpoints
- `sm: 480`, `md: 768`, `lg: 1024`, `xl: 1280`, `2xl: 1440`.
- Estrategia shell oficial: desktop fijo sin overlay; tablet/mobile flotante con overlay.

### Density
- **Comfortable**: control height 40px, spacing estándar.
- **Compact**: control height 32px, spacing reducida.

---

## 4) Arquitectura de tokens propuesta (Fase 2)

### Nomenclatura
- Prefijo oficial: `--mx-*`.
- Tipos principales: `--mx-primitive-*`, `--mx-color-*`, `--mx-space-*`, `--mx-radius-*`, `--mx-shadow-*`, `--mx-font-*`, `--mx-motion-*`, `--mx-density-*`.

### Primitive vs Semantic
- **Primitive**: valores puros de escala (colores, spacing, radio, borders, breakpoints).
- **Semantic**: intención UI (`bg-canvas`, `text-primary`, `border-default`, `brand-primary`, etc.).

### Estructura de archivos
- `tokens.primitives.css`
- `tokens.semantic.css`
- `typography.css`
- `motion.css`
- `themes/light.css`
- `themes/dark.css`
- `tokens.css` (agregador + puente de compatibilidad `--ms-*`)

### Preparación para dark mode
- `themes/dark.css` con overrides bajo `[data-mx-theme="dark"]`.
- Sin migración completa aún; solo habilitación estructural inicial.

---

## 5) Estrategia de componentes (Fase 3 y Fase 4)

### A) Componentes propios MachSoft (API pública objetivo)
- `MxButton`, `MxCard`, `MxBadge`, `MxPageHeader`, `MxSidebarNav`, `MxPanel`, `MxToolbar`.
- Deben exponer contratos estables, semánticos y agnósticos del vendor.

### B) Wrappers sobre MudBlazor
- `MxTextField`, `MxSelect`, `MxDatePicker`, `MxDialog`.
- Uso de MudBlazor como motor interno permitido, ocultando API vendor.

### C) Vendor-direct (excepciones controladas)
Solo en casos de alto costo de envoltura o funcionalidad compleja no madura en capa MachSoft (documentando deuda técnica y plan de encapsulación posterior).

### Estrategia enterprise components
- **DataGrid/TreeGrid/Scheduler/Charts**: wrapper recomendado cuando el contrato se repite en 2+ productos o requiere reglas corporativas de accesibilidad/estilo.
- **FileUpload/Autocomplete/Toast/Tooltip**: wrapper si se requiere API uniforme de validación, estados y telemetría UI.
- Evitar acoplamiento:
  1. contratos `Mx*` estables,
  2. adapter interno por vendor,
  3. tests/Showcase sobre API MachSoft, no API Mud.

---

## 6) Patterns iniciales (Fase 5)
1. Dashboard shell (sidebar + topbar + content zones).
2. Page header + primary/secondary actions.
3. Card grid para resumen operativo.
4. Search/filter panel con criterios persistentes.
5. List + details (master/detail).
6. Form sections jerárquicas con validación contextual.
7. Settings pages por categorías.
8. Workspace layout (filtros laterales + área de trabajo principal).

Cada pattern debe tener demostración en `/showcase` y guía de composición.

---

## 7) Showcase (Fase 6)
El showcase debe incluir secciones dedicadas a:
- foundations (color, typography, spacing, radius, elevation, borders, density),
- tokens (`primitive` y `semantic`),
- componentes Foundation y futuros `Mx*`,
- patterns enterprise,
- evidencia de compatibilidad Server/WASM.

Regla: ningún componente reusable se declara “Foundation” sin ejemplo funcional en showcase.

---

## 8) Governance (Fase 7)

### Qué entra al Design System
- Contratos UI reusables cross-host.
- Foundations y patterns de uso recurrente.
- Elementos agnósticos de dominio.

### Qué no entra
- Flujos de negocio específicos.
- Integraciones de infraestructura.
- Variantes locales de un solo producto.

### Criterios para pasar a Foundation
1. Repetición real en al menos dos contextos.
2. Contrato claro y mínimo.
3. Ejemplo en showcase.
4. Documentación técnica actualizada.

### Reglas de actualización obligatoria
- **Docs**: cambios de arquitectura, contratos o flujo de adopción.
- **Showcase**: nuevos componentes/variantes o cambios de comportamiento.
- **Tests**: cambios que impacten shell, accesibilidad o interacción responsive.

### Naming rules
- Prefijo API pública: `Mx*`.
- Prefijo CSS/tokens: `mx-` / `--mx-*`.
- Mantener `ms-` temporalmente solo como compatibilidad en el template actual.

### Breaking change policy
- Cambios de contratos `Mx*` o tokens semánticos requieren:
  - nota de ruptura,
  - guía de migración,
  - actualización de showcase y tests.

### Versionado
- Mientras sea interno: `MAJOR.MINOR.PATCH-internal`.
- Recomendación inicial:
  - `MAJOR`: ruptura de API/token semántico,
  - `MINOR`: nuevos componentes/tokens compatibles,
  - `PATCH`: fixes visuales/técnicos sin cambio de contrato.

---

## 9) Estructura de carpetas (propuesta)

```text
src/MachSoft.Template.Core/
  Components/
    Foundation/
    Forms/
    Enterprise/              # fase posterior
    VendorAdapters/          # wrappers/bridges
  Layout/
  Pages/
  wwwroot/css/template/
    tokens.css               # agregador + compatibilidad ms
    design-system/
      tokens.primitives.css
      tokens.semantic.css
      typography.css
      motion.css
      themes/
        light.css
        dark.css
docs/
  MACHSOFT_DESIGN_SYSTEM_FOUNDATION.md
```

---

## 10) Integración inicial en MachSoft.Template
- Se incorpora arquitectura de tokens `--mx-*` en Core sin romper estilos existentes.
- `tokens.css` mantiene puente de compatibilidad `--ms-*` para componentes actuales.
- La misma base CSS continúa siendo consumida por Server, WASM y Sample.

---

## 11) Hoja de ruta recomendada

### Iteración 1 (actual)
- Identidad + foundations + tokens + governance base.
- Documento formal MDS.
- Integración no destructiva en template.

### Iteración 2
- Crear primeros contratos `MxButton`, `MxCard`, `MxBadge`, `MxPageHeader`.
- Añadir demos y tests de contrato visual en showcase.

### Iteración 3
- Wrappers críticos (`MxTextField`, `MxSelect`, `MxDialog`) desacoplados de Mud API.
- Definir adapter layer para vendor swap futuro.

### Iteración 4
- Enterprise components priorizados (DataGrid, Charts, FileUpload) bajo criterios de adopción real.
- Consolidar telemetry hooks y accesibilidad avanzada.

### Iteración 5
- Dark mode completo y políticas de theming por producto.
- Paquete distribuible interno del Design System (si aplica).
