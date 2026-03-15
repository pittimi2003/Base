# Design System Adoption Playbook — MachSoft

## Objetivo
Definir cómo adopta un equipo el Design System **hoy** (sin ambigüedad), qué validar como baseline mínima y qué queda preparado para transición a **NuGet + template corporativo**.

## Estándar oficial de adopción interna
1. Usar exclusivamente contratos públicos `Mx*` para nuevo desarrollo.
2. Mantener toda UI reusable en `src/MachSoft.Template.Core`.
3. Mantener hosts (`Starter` Server/WASM) como bootstrap y runtime específico de host.
4. Validar siempre en rutas reales de operación:
   - Server: `/showcase` y `/demo`
   - WASM: `/showcase` y `/wasm-demo`
5. No promover componentes legacy en nuevas pantallas.

## Checklist de adopción (go/no-go por equipo)

### A. Pre-adopción
- [ ] El equipo entiende que `Mx*` es el único lenguaje oficial para nuevos componentes/patrones.
- [ ] Se eligió host inicial correcto (`Starter` Server o `Starter.Wasm`).
- [ ] Se acordó que lo compartido cross-host se implementa en Core.

### B. Baseline técnica obligatoria
- [ ] `dotnet restore MachSoft.Template.sln`
- [ ] `dotnet build MachSoft.Template.sln -c Release`
- [ ] Arranque de Server (`template/MachSoft.Template.Starter`)
- [ ] Arranque de WASM (`template/MachSoft.Template.Starter.Wasm`)

### C. Smoke funcional mínimo
- [ ] `/showcase` en **light** y **dark** sin roturas visuales evidentes.
- [ ] `/demo` operativo en host Server.
- [ ] `/wasm-demo` operativo en host WASM.
- [ ] Navegación base, shell responsive y toggle de tema funcionales.

### D. Controles críticos a comprobar
- [ ] Catálogo base (Grupo 1) renderiza y responde en acciones principales.
- [ ] Formularios (Grupo 2) mantienen asociación label/control, helper/error y estados.
- [ ] Navigation/overlays (Grupo 3) respetan apertura/cierre/interacción base.
- [ ] Data display + enterprise inputs/data (Grupos 4, 5, 6) muestran estados reales de uso.
- [ ] Patterns (Grupo 7) componen flujo operativo sin introducir dependencias de dominio.

### E. Qué se considera regresión clara
- [ ] Build Release roto o restore inestable.
- [ ] Alguna ruta smoke obligatoria deja de cargar.
- [ ] Rotura de light/dark en showcase (contraste/foco/legibilidad básicos).
- [ ] Pérdida de comportamiento del shell responsive o navegación principal.
- [ ] Introducción de uso nuevo de legacy en lugar de `Mx*`.

## Delimitación para distribución NuGet (preparación)

### Lo que debe entrar
- `MachSoft.Template.Core` como paquete reusable.
- Componentes oficiales `Mx*` (Grupos 1–7) y modelos asociados públicos.
- Sistema de estilos/tokenización/theming (`--mx-*`, temas light/dark, utilidades y assets CSS/JS mínimos).
- Contratos públicos estables y documentados para consumo por apps internas.

### Lo que NO debe entrar
- `samples/*` (apps demo/validación).
- Artefactos ilustrativos que no sean parte de API/plataforma reusable.
- Configuración o contenido específico de escenarios de ejemplo.

## Delimitación para template corporativo (preparación)

### Lo que debe entrar
- Estructura mínima de app nueva (host + wiring base).
- Shell/layout oficial compartido.
- Theming y assets esenciales.
- Páginas iniciales mínimas para smoke y extensión segura.

### Lo que NO debe entrar
- Showcase completo si añade fricción innecesaria al bootstrap productivo.
- Demos específicas de dominio/simulación que no aporten arranque mínimo.
- Ruido de sample que complique mantenimiento del template.

## Backlog posterior (fuera de esta fase)
1. Empaquetado NuGet real + versionado/publicación interna.
2. Definición final de contrato del template corporativo distribuible.
3. Expansión de matriz de compatibilidad cross-browser/cross-device para escenarios enterprise amplios.
