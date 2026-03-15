# MachSoft Template

Starter corporativo para proyectos Blazor bajo convención MachSoft, con variantes **Server** y **WebAssembly** sobre una base visual común.

## Versión interna
- Versión actual del template: **`v1.0.0-internal`**.
- Convención: versión semántica + sufijo `-internal` para consumo interno controlado.

## Estructura
- `MachSoft.Template.sln`
- `docs/`: arquitectura, migración y guía de uso.
- `docs/MACHSOFT_DESIGN_SYSTEM_FOUNDATION.md`: base formal del MachSoft Design System (identidad, foundations concretas, tokens, dark mode, componentes y governance).
- `src/MachSoft.Template.Core`: base reusable (layout, foundation components, estilos, páginas base).
- `template/MachSoft.Template.Starter`: starter principal en Blazor Server.
- `template/MachSoft.Template.Starter.Wasm`: starter equivalente en Blazor WebAssembly.
- `samples/MachSoft.Template.SampleApp`: demo funcional de referencia.
- `samples/MachSoft.Template.AdoptionValidationApp`: app de validación de adopción (simula proyecto nuevo).

## Proyectos
- **MachSoft.Template.Core**: Razor Class Library reusable compartida por Server/WASM.
- **MachSoft.Template.Starter**: starter productivo mínimo (Server).
- **MachSoft.Template.Starter.Wasm**: starter productivo mínimo (WASM standalone).
- **MachSoft.Template.SampleApp**: showcase funcional de referencia (Server).
- **MachSoft.Template.AdoptionValidationApp**: validación de adopción real con branding y páginas propias (Server).

## Qué comparten Server y WASM
- `MainLayout` corporativo.
- Componentes foundation y patterns oficiales (`MxPageHeader`, `MxCard`, `MxPanel`, `MxFormSection`, `MxSearchPanel`, `MxDashboardSection`) y `AppMenuTile` como helper de navegación del template.
- Páginas base (`/`, `/showcase`).
- Sistema de estilos (`tokens.css`, `base.css`, `layout.css`, `components.css`, `utilities.css`).
  - `tokens.css` agrega arquitectura `--mx-*` (primitives/semantic/themes), dark mode y mantiene compatibilidad `--ms-*`.

## Ejecutar
> Requiere .NET SDK 8+

```bash
dotnet build MachSoft.Template.sln

# Starter Server
dotnet run --project template/MachSoft.Template.Starter

# Starter WASM
dotnet run --project template/MachSoft.Template.Starter.Wasm

# Sample Server
dotnet run --project samples/MachSoft.Template.SampleApp

# Adoption validation app
dotnet run --project samples/MachSoft.Template.AdoptionValidationApp
```

## Uso como base corporativa
1. Clonar la solución.
2. Elegir `Starter` (Server) o `Starter.Wasm` según tipo de aplicación.
3. Mantener componentes y estilo compartido en `MachSoft.Template.Core`.
4. Usar `SampleApp` para validar cambios de foundation antes de adopción.

## Guía de adopción
- Flujo operativo completo y checklist de arranque: `docs/ADOPTION_GUIDE.md`.
- Cierre ejecutivo de release interna (estado, clasificación y riesgos): `docs/DESIGN_SYSTEM_STATUS.md`.
- Playbook de adopción + baseline mínima + delimitación NuGet/template: `docs/DESIGN_SYSTEM_ADOPTION_PLAYBOOK.md`.


## Validación de adopción real
- Referencia implementada: `samples/MachSoft.Template.AdoptionValidationApp`.
- Simula un equipo que adopta `Starter` y personaliza branding, navegación y páginas (`/operations`, `/settings`) usando lenguaje oficial `Mx*` del Core.


## Theming
- Toggle de tema (🌙/☀️) integrado en el header del layout compartido.
- Persistencia por `localStorage` (`mx-theme`) y aplicación por atributo `data-mx-theme` en root.
- Funciona en Server, WASM y Sample al consumir `MachSoft.Template.Core`.


## Preparación NuGet (Fase 14)
- Proyecto empaquetable definido: `src/MachSoft.Template.Core`.
- Identificador de paquete: `MachSoft.Template.Core`.
- Empaquetado local:

```bash
dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o artifacts/nuget
```

- Guía mínima de consumo del paquete: `src/MachSoft.Template.Core/NUGET_README.md` y `docs/TEMPLATE_GUIDE.md`.

## Template corporativo oficial (Fase 15)
- Proyecto base del template: `template/MachSoft.Template.Official`.
- Short name del template: `machsoft-app`.
- Salida del template: app Blazor Server limpia, con shell/layout corporativo, theming light/dark y wiring mínimo con `MachSoft.Template.Core`.
- Exclusiones deliberadas: showcase, demo, wasm-demo y apps de sample/adopción (se mantienen en este repositorio solo para validación interna).

Flujo rápido:

```bash
# 1) Empaquetar runtime reusable
dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o ./.artifacts/local-nuget

# 2) Instalar template
dotnet new install ./template/MachSoft.Template.Official

# 3) Crear app nueva
dotnet new machsoft-app -n MyCompany.App

# 4) Restaurar y ejecutar
cd MyCompany.App
dotnet restore
dotnet run
```
