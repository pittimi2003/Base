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
- **Core (común)**: layout base desacoplado (MainLayout + AppShell/AppHeader/AppNavigation/AppFooter), componentes foundation, páginas base, CSS y tokens.
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

Componentes base actuales de referencia:
- `PageContainer` (`Compact`)
- `BaseCard` (`Variant`: `default|elevated|outlined|muted`, `Compact`)
- `AppMenuTile` (`Variant`: `default|elevated|muted`)

---

## 4) Reglas de Layout
Ubicación: `src/MachSoft.Template.Core/Layout`.

- `MainLayout` es el contrato visual común y debe permanecer liviano.
- Delegar estructura visual en subcomponentes (`AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`).
- No inyectar servicios de negocio en layout común.
- Las variantes por host deben resolverse en el host, no rompiendo el layout base.

---

## 5) Sistema de estilos y design tokens
Ubicación: `src/MachSoft.Template.Core/wwwroot/css/template/`

Archivos y propósito:
- `tokens.css` → variables y design tokens.
- `base.css` → tipografía, resets mínimos y defaults.
- `layout.css` → shell/layout principal.
- `components.css` → estilos de componentes.
- `utilities.css` → utilidades de spacing/grid/helpers.

Reglas CSS:
1. Usar prefijo `ms-` en clases corporativas.
2. Evitar estilos inline salvo casos justificados.
3. Nuevos colores/espaciados primero como token.
4. No duplicar estilos entre Server y WASM.

---

## 6) Reglas de reutilización Server/WASM
- Toda UI compartida debe vivir en `MachSoft.Template.Core`.
- Server/WASM solo contienen bootstrap, runtime y necesidades específicas de host.
- Si algo se repite en ambos hosts, mover al Core.
- No copiar componentes/estilos entre hosts.

---

## 7) Convenciones de nombres
- Prefijo obligatorio: `MachSoft.Template.*`.
- Nombres claros por responsabilidad (`Core`, `Starter`, `Starter.Wasm`, `SampleApp`).
- Evitar nombres legacy o ambiguos.

---

## 8) Cómo agregar nuevos componentes
1. Crear componente en `Core/Components/Foundation` o carpeta temática reusable.
2. Añadir estilos en `components.css` y tokens si aplica.
3. Exponer uso en `Pages/Showcase` o en `SampleApp`.
4. Verificar compilación de solución completa.
5. Actualizar documentación relevante en `docs/`.

---

## 9) Reglas de dependencias
- En `Core`: solo dependencias necesarias para componentes/layout compartidos.
- Evitar dependencias pesadas o acopladas a host específico.
- Cualquier librería exclusiva de host debe quedarse en el host.
- Mantener versiones alineadas con .NET 8.

---

## 10) Reglas de documentación
Actualizar siempre cuando cambie arquitectura o flujo de uso:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/TEMPLATE_GUIDE.md`
- `docs/MIGRATION_REPORT.md`

La documentación debe reflejar estado real del código (no intenciones futuras).

---

## 11) Flujo de trabajo esperado para agentes
1. Validar entorno (`dotnet --info`).
2. Restaurar y compilar (`dotnet restore`, `dotnet build`).
3. Hacer cambios mínimos y coherentes con la arquitectura.
4. Verificar que Server y WASM sigan reutilizando Core.
5. Ejecutar validaciones de arranque básicas cuando sea posible.
6. Actualizar docs.
7. Commit atómico con mensaje claro y PR con resumen técnico.

Comandos base sugeridos:
- `dotnet restore MachSoft.Template.sln`
- `dotnet build MachSoft.Template.sln`
- `dotnet run --project template/MachSoft.Template.Starter`
- `dotnet run --project template/MachSoft.Template.Starter.Wasm`
