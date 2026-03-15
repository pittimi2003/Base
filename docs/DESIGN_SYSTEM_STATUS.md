# Design System Status — MachSoft (Fase 16)

## Release interna definida
- Release vigente: **`v1.0.0-internal`**.
- Estado: **operable como plataforma interna** para adopción controlada.
- Artefactos soportados en esta release:
  1. paquete NuGet `MachSoft.Template.Core`,
  2. template oficial `machsoft-app`,
  3. hosts de validación interna (`Starter` y `Starter.Wasm`).

## Convención de versionado inmediata
- Formato: `MAJOR.MINOR.PATCH-internal`.
- Criterio:
  - `PATCH`: fixes compatibles,
  - `MINOR`: ampliaciones compatibles,
  - `MAJOR`: cambios incompatibles de contrato.

## Qué significa “estable” en el contexto actual
Se considera estable si:
1. restore/build Release pasan en la solución,
2. pack de Core genera `.nupkg` y `.snupkg`,
3. template instala y genera app nueva,
4. app nueva restaura/build/run,
5. smoke de rutas y theming pasa en Server y WASM.

## Qué entra en release interna soportada
- Runtime reusable `Mx*` + shell/layout + theming dentro de `MachSoft.Template.Core`.
- Flujo documentado de publicación/consumo NuGet interno.
- Flujo documentado de instalación/uso del template oficial.
- Checklist go/no-go y baseline mínima repetible.

## Qué queda como evolución futura (fuera de esta release)
- Publicación pública externa del paquete/template.
- Matriz cross-browser/cross-device enterprise ampliada.
- Evolución premium de controles avanzados más allá del baseline actual.

## Riesgos residuales reales
1. Dependencia de feed interno (o fallback local) para resolver `MachSoft.Template.Core` en apps nuevas.
2. Variaciones visuales menores de controles nativos por navegador/SO.
