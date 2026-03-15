# Design System Status — MachSoft (Cierre ejecutivo release interna)

## Release evaluada
- Estado evaluado: **`v1.0.0-internal`**.
- Decisión ejecutiva: **estable para adopción interna controlada** y **lista para fase de preparación de empaquetado NuGet**.
- Lenguaje oficial vigente: **`Mx*`**.

## Validación técnica base de esta fase
- Restore de solución: `dotnet restore MachSoft.Template.sln`.
- Build Release de solución: `dotnet build MachSoft.Template.sln -c Release`.
- Hosts levantados:
  - `template/MachSoft.Template.Starter` (Server)
  - `template/MachSoft.Template.Starter.Wasm` (WASM)
- Rutas smoke validadas:
  - Server: `/showcase` (light/dark), `/demo`
  - WASM: `/showcase` (light/dark), `/wasm-demo`

## Clasificación ejecutiva del sistema

### 1) Estable y soportado
- **Foundation + tokens**: arquitectura `--mx-*` y bridge `--ms-*` operativa en Core.
- **Layout/shell compartido**: `MainLayout` + `AppShell` + navegación responsive + toggle de tema funcional.
- **Catálogo oficial Mx***:
  - Grupos 1 a 4 (base, forms, navigation/overlays, data display) estables para adopción.
  - Grupo 5 (enterprise inputs), Grupo 6 (enterprise data), Grupo 7 (patterns) funcionales y consolidados para uso interno.
- **Cross-host reuse**: Server y WASM consumen el mismo Core sin duplicación de componentes.
- **Showcase y demos**: vigentes como superficie de validación funcional y visual para adopción.

### 2) Estable con limitaciones conocidas
- **Controles nativos del navegador/SO** (por ejemplo, date/file) mantienen variaciones de rendering propias de plataforma.
- **Nivel visual premium homogéneo**: funcionalmente correcto, pero algunos controles avanzados aún priorizan estabilidad/claridad contractual frente a refinamiento visual de nivel “design suite premium”.
- **Cobertura de validación actual**: baseline mínima sólida (restore/build + smoke de rutas y temas), pero sin matriz exhaustiva cross-browser/cross-device para todos los escenarios enterprise.
- **Vínculos inter-host desde navegación compartida**: en host Server, la ruta `/wasm-demo` no está expuesta localmente (la demo WASM se valida en su host dedicado).

### 3) Legacy / obsolete
- Componentes legacy retenidos solo por compatibilidad y no promocionables para desarrollo nuevo:
  - `PageContainer`
  - `BaseCard`
  - `FormSection`
  - `FieldGroup`
  - `SectionTitle`
- Directiva vigente: toda nueva adopción debe usar contratos `Mx*`; legacy queda como puente temporal de compatibilidad.

## Alcance para siguiente fase (preparación NuGet)
- **Dentro de scope inmediato**: empaquetar Core reutilizable con contratos públicos estables `Mx*`, theming y assets necesarios.
- **Fuera de scope inmediato**: expandir catálogo, rediseñar arquitectura o abrir mejoras cosméticas sin impacto de plataforma.

## Riesgos residuales (reales y acotados)
1. Diferencias de UX menores derivadas de controles HTML nativos según navegador/SO.
2. Necesidad de formalizar una matriz de compatibilidad cross-browser más amplia antes de adopción masiva multi-producto.
3. Riesgo de uso accidental de componentes legacy en equipos nuevos si no se aplica la checklist de adopción.
