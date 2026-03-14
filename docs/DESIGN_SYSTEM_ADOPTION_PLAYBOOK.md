# Design System Adoption Playbook — MachSoft

## Objetivo
Guía operativa para que equipos internos adopten `MachSoft.Template` usando el estándar **Mx*** sin ambigüedades.

## Flujo recomendado
1. Elegir host de inicio:
   - Server: `template/MachSoft.Template.Starter`
   - WASM: `template/MachSoft.Template.Starter.Wasm`
2. Mantener UI reusable en `src/MachSoft.Template.Core`.
3. Componer nuevas pantallas con:
   - `MxPageHeader`
   - `MxPanel`/`MxCard`
   - componentes del catálogo `Mx*` por grupo.
4. Validar cambios en `/showcase` y en la demo del host (`/demo` o `/wasm-demo`).
5. Actualizar documentación cuando cambien contratos, arquitectura o flujo de adopción.

## Reglas de adopción
- Usar `Mx*` como API pública de referencia.
- No introducir uso nuevo de componentes legacy.
- Si algo se repite entre Server/WASM, moverlo a Core.
- Mantener ejemplos de showcase alineados con estado real del código.

## Checklist mínimo por entrega
- `dotnet restore MachSoft.Template.sln`
- `dotnet build MachSoft.Template.sln -c Release`
- Arranque del host objetivo (Server y/o WASM)
- Smoke de navegación, layout, showcase y demo del host
- Confirmación de ausencia de errores visibles de runtime

## Referencias
- `docs/ADOPTION_GUIDE.md`
- `docs/TEMPLATE_GUIDE.md`
- `docs/ARCHITECTURE.md`
- `docs/MACHSOFT_DESIGN_SYSTEM_FOUNDATION.md`
