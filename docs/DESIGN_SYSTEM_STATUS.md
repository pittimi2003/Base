# Design System Status — MachSoft (Fase 17)

## Cierre formal del programa principal
- Programa principal **cerrado formalmente** sobre baseline `v1.0.0-internal`.
- El objetivo original (runtime reusable + paquete NuGet + template corporativo + operación interna repetible) se considera **cumplido**.
- A partir de este punto, el trabajo pasa a modalidad de **evolución de producto**, no de construcción base.

## Resumen ejecutivo final
1. **Propósito original**: establecer un Design System corporativo reusable para Server/WASM, empaquetable y adoptable por equipos internos.
2. **Qué se construyó**: foundation tokens/themes, shell/layout, catálogo `Mx*` (grupos 1–7), patterns, enterprise data, showcase/demo/wasm-demo, paquete `MachSoft.Template.Core`, template `machsoft-app`, baseline operativa y checklist de release.
3. **Qué quedó operativo**: circuito técnico completo restore/build/pack + instalación de template + creación de app nueva + restore/build/run con feed local/interno.
4. **Impacto práctico actual**: los equipos pueden iniciar apps nuevas con contrato visual y técnico común, sin copiar assets ni redefinir layout/theming por proyecto.
5. **Capacidad nueva habilitada**: bootstrap corporativo repetible (`dotnet new machsoft-app`) conectado al runtime reusable versionado.

## Entregables consolidados (cerrados)
### 1) Base Design System
- Foundations, tokens, themes light/dark y shell/layout responsive accesible.
- Catálogo oficial `Mx*` consolidado en Core (grupos 1–7) con patrones y componentes de enterprise data.

### 2) Superficies de validación
- Hosts de validación con rutas de comprobación funcional/visual:
  - Server: `/showcase`, `/demo`.
  - WASM: `/showcase`, `/demo`, `/wasm-demo`.

### 3) Activos de plataforma
- Paquete NuGet interno: `MachSoft.Template.Core`.
- Template corporativo oficial: `template/MachSoft.Template.Official` (`machsoft-app`).
- Documentación operativa, checklist y baseline de release interna.

### 4) Estado de adopción interna
- **Listo para uso**: arranque de nuevas apps Server corporativas con contrato base compartido.
- **Soportado**: consumo desde feed interno o source local de paquetes.
- **Con limitaciones conocidas**: diferencias menores de controles nativos por navegador/SO y roadmap premium fuera del baseline actual.

## Operación actual (estado vigente)
Se considera estado operativo válido si se mantiene este circuito mínimo:
1. `dotnet restore MachSoft.Template.sln`
2. `dotnet build MachSoft.Template.sln -c Release`
3. `dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release`
4. Arranque de `template/MachSoft.Template.Starter` y `template/MachSoft.Template.Starter.Wasm`
5. Smoke de rutas: `/showcase` (light/dark), `/demo`, `/wasm-demo` (en host WASM)
6. `dotnet new install ./template/MachSoft.Template.Official`
7. `dotnet new machsoft-app ...` + restore/build/run de app nueva usando feed interno o source local

## Limitaciones conocidas (no bloqueantes)
1. **Feed de paquetes**: la app generada por template requiere que `MachSoft.Template.Core` esté disponible en feed interno o source local; con solo `nuget.org` el restore falla.
2. **Controles nativos**: pueden existir variaciones visuales menores por navegador/SO (select, date, file, etc.).
3. **Roadmap premium**: controles avanzados enterprise no incluidos en el baseline obligatorio de `v1.0.0-internal`.

## Backlog de evolución priorizado

### Prioridad P1 — Workstreams inmediatos de plataforma
1. **Automatizar validación de template con feed interno en CI** (go/no-go automático del circuito pack → template → app nueva).
2. **Versionado y release cadence** para `MachSoft.Template.Core` y `machsoft-app` con criterios explícitos de compatibilidad.
3. **Hardening de smoke checks** para hosts Server/WASM y rutas críticas (`/showcase`, `/demo`, `/wasm-demo`).

### Prioridad P2 — Mejora de producto
1. **Línea premium de componentes** (solo por valor real de adopción; sin romper contratos `Mx*`).
2. **Mejoras de baseline/regresión visual y accesibilidad** sobre componentes críticos.
3. **DX de adopción**: plantillas de `nuget.config`, guías de bootstrap para equipos y diagnóstico rápido de restore/feed.

### Prioridad P3 — Madurez opcional/futura
1. **Matriz cross-browser/cross-device ampliada** (más combinaciones y evidencia persistida).
2. **Automatización más profunda de quality gates** (visual diffs no bloqueantes y trazabilidad histórica).
3. **Refinamientos no críticos de documentación y samples** según feedback de adopción real.

## Criterio de mantenimiento inmediato
1. **Ya no entra como “base”**: creación de nuevos grupos de componentes o rediseños estructurales del core baseline.
2. **Sí entra como evolución normal**: fixes compatibles, mejoras incrementales, hardening operativo y ampliaciones controladas de catálogo ya existente.
3. **Bloqueantes para release interna futura**:
   - restore/build/pack fallando,
   - template que no instala o no genera app válida,
   - app generada que no restaura/build/run,
   - regresión visible de shell/theming/rutas base.
4. **Validación obligatoria por cambio**:
   - restore/build/pack,
   - arranque Server/WASM,
   - smoke de rutas base,
   - circuito template → app nueva.
5. **Protección de paquete/template ante regresiones**: mantener checklist (`docs/INTERNAL_RELEASE_CHECKLIST.md`) y baseline (`docs/OPERATIONS_BASELINE.md`) como gates obligatorios de publicación interna.
