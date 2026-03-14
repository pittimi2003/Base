# Design System Status — MachSoft (Release interna)

## Estado general
- Estado: **READY FOR INTERNAL ADOPTION**.
- Versión base: **`v1.0.0-internal`**.
- Lenguaje oficial: **`Mx*`**.

## Implementación consolidada
- Grupos implementados en `MachSoft.Template.Core`: **1 a 7**.
- Hosts validados sobre Core compartido:
  - `template/MachSoft.Template.Starter` (Server)
  - `template/MachSoft.Template.Starter.Wasm` (WASM)
- Superficies de validación funcional/visual:
  - `/showcase`
  - `/demo`
  - `/wasm-demo`

## Legacy
- Componentes legacy mantenidos solo por compatibilidad y marcados `Obsolete`:
  - `PageContainer`
  - `BaseCard`
  - `FormSection`
  - `FieldGroup`
  - `SectionTitle`
- Criterio vigente: no promover uso nuevo de legacy en rutas principales ni en documentación de adopción.

## Criterios de hardening vigentes
1. Restore y build Release sin errores.
2. Coherencia entre código, showcase, demos y documentación.
3. Naming oficial `Mx*` en material principal y ejemplos activos.
4. Sin deuda visible evitable antes de release interna.
