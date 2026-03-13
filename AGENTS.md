# AGENTS.md — Guía operativa para agentes en MachSoft.Template

## 1) Propósito del repositorio
Este repositorio contiene una plantilla corporativa Blazor bajo convención **MachSoft.Template.*** para acelerar nuevos proyectos con una base visual y estructural reutilizable.

Objetivo principal:
- centralizar UI foundation y estilos en una capa común,
- ofrecer hosts listos para **Server** y **WebAssembly**,
- mantener un **sample** para validación funcional y visual.

---

## 2) Arquitectura general de la solución
Estructura esperada:
- `src/MachSoft.Template.Core` → capa reusable común (RCL).
- `template/MachSoft.Template.Starter` → starter Blazor Server.
- `template/MachSoft.Template.Starter.Wasm` → starter Blazor WebAssembly.
- `samples/MachSoft.Template.SampleApp` → aplicación demo de referencia.
- `docs/` → arquitectura, guía de uso y migración.

### Responsabilidades por capa
- **Core (común)**: layout base desacoplado (MainLayout + AppShell/AppHeader/AppNavigation/AppFooter), foundation components, base mínima de formularios, páginas base, CSS y tokens.
- **Starter Server**: bootstrap server y páginas específicas de host server.
- **Starter WASM**: bootstrap cliente WASM y páginas específicas de host WASM.
- **Sample**: validar patrones de uso reales sin lógica de negocio legacy.

---

## 3) Reglas para Foundation Components
Ubicación: `src/MachSoft.Template.Core/Components/Foundation`.

Reglas:
1. Deben ser **genéricos** y sin dependencias de negocio.
2. API de parámetros simple y explícita.
3. Evitar side effects, acceso directo a servicios de dominio o persistencia.
4. Priorizar composición (ChildContent) sobre especialización rígida.
5. Si un componente deja de ser reusable, moverlo a host específico.

Contratos de referencia:
- `PageContainer` (`Title`, `Description`, `IsCompact`)
- `BaseCard` (`Title`, `BadgeText`, `Variant: SurfaceVariant`, `IsCompact`)
- `AppMenuTile` (`Title`, `Description`, `Href`, `Icon`, `Variant: TileVariant`)

---

## 4) Base mínima de formularios
Ubicación: `src/MachSoft.Template.Core/Components/Forms`.

Componentes:
- `FormSection`
- `SectionTitle`
- `FieldGroup`

Regla: mantenerlos como **patrones visuales ligeros**. No convertir esta capa en framework de formularios.

---

## 5) Reglas de Layout y navegación
Ubicación: `src/MachSoft.Template.Core/Layout`.

- `MainLayout` es el contrato visual común y debe permanecer liviano.
- Delegar estructura visual en subcomponentes (`AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`).
- `AppShell` gestiona estado de sidebar colapsable (`IsMenuOpen`) y overlay.
- Patrón oficial de shell: **desktop con sidebar fijo y sin overlay**; **mobile/tablet con sidebar flotante + overlay**.
- Botón hamburguesa visible solo en mobile/tablet.
- Mantener accesibilidad mínima del shell:
  - hamburguesa con `aria-label`, `aria-expanded`, `aria-controls`,
  - sidebar con `role="navigation"`, `aria-label`, `aria-hidden` sincronizado,
  - foco visible en controles interactivos (`:focus-visible`).
- Cierre automático del menú cuando:
  1. clic en overlay,
  2. clic en contenido fuera del sidebar,
  3. clic en opción de navegación,
  4. clic nuevamente en hamburguesa,
  5. tecla Escape.
- No inyectar servicios de negocio en layout común.

---

## 6) Sistema de estilos y design tokens
Ubicación: `src/MachSoft.Template.Core/wwwroot/css/template/`

Archivos y propósito:
- `tokens.css` → variables y design tokens.
- `base.css` → tipografía, resets mínimos y defaults.
- `layout.css` → shell/layout principal + sidebar responsive + overlay.
- `components.css` → estilos de componentes.
- `utilities.css` → utilidades de spacing/grid/helpers.

Reglas CSS:
1. Usar prefijo `ms-` en clases corporativas.
2. Evitar estilos inline salvo casos justificados.
3. Nuevos colores/espaciados/z-index primero como token.
4. No duplicar estilos entre Server y WASM.

---

## 7) Reglas de composición
- Combinación base por pantalla: `PageContainer` + `BaseCard`.
- `IsCompact=true` solo para secciones densas o anidadas.
- `SurfaceVariant.Outlined`: estructura neutral.
- `SurfaceVariant.Elevated`: bloque prioritario.
- `SurfaceVariant.Muted`: contenido secundario/contextual.
- Promover a Foundation solo si el patrón se repite cross-host y no contiene dominio.

---

## 8) Reglas de reutilización Server/WASM
- Toda UI compartida debe vivir en `MachSoft.Template.Core`.
- Server/WASM solo contienen bootstrap, runtime y necesidades específicas de host.
- Si algo se repite en ambos hosts, mover al Core.
- No copiar componentes/estilos entre hosts.

---

## 9) Convenciones de nombres
- Prefijo obligatorio: `MachSoft.Template.*`.
- Nombres claros por responsabilidad (`Core`, `Starter`, `Starter.Wasm`, `SampleApp`).
- Evitar nombres legacy o ambiguos.

---

## 10) Governance Rules
- Todo cambio reusable debe pasar por `/showcase` antes de adoptarse.
- No incorporar nuevos components en Core sin:
  1. uso repetido,
  2. contrato claro,
  3. ejemplo en showcase,
  4. docs actualizadas.
- Evitar duplicación: preferir extender Foundation antes que crear variantes locales paralelas.

---

## 11) Reglas de documentación
Actualizar siempre cuando cambie arquitectura o flujo de uso:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/TEMPLATE_GUIDE.md`
- `docs/MIGRATION_REPORT.md`

La documentación debe reflejar estado real del código (no intenciones futuras).

---

## 12) Flujo de trabajo esperado para agentes
1. Validar entorno (`dotnet --info`).
2. Restaurar y compilar (`dotnet restore`, `dotnet build`).
3. Hacer cambios mínimos y coherentes con la arquitectura.
4. Verificar que Server y WASM sigan reutilizando Core.
5. Ejecutar validaciones de arranque básicas cuando sea posible.
6. Validar visualmente `/showcase` y navegación lateral al cambiar layout/styles.
7. Ejecutar cobertura E2E mínima del shell (`tests/e2e`) cuando haya cambios en layout/navigation.
   - Revisar/actualizar `tests/e2e/README.md` si cambian scripts o prerrequisitos.
   - Mantener separación por comportamiento (`shell-mobile-tablet.spec.ts` y `shell-desktop.spec.ts`).
8. Actualizar docs.
9. Commit atómico con mensaje claro y PR con resumen técnico.

Comandos base sugeridos:
- `dotnet restore MachSoft.Template.sln`
- `dotnet build MachSoft.Template.sln`
- `dotnet run --project template/MachSoft.Template.Starter`
- `dotnet run --project template/MachSoft.Template.Starter.Wasm`
