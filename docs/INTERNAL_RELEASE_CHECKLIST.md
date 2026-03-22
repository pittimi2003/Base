# Fase 16 — Checklist operativa de release interna

## Objetivo
Checklist ejecutable para declarar una release interna de la plataforma MachSoft Design System sin depender de conocimiento tribal.

## Versión objetivo de esta baseline
- Release interna actual: **`v1.0.0-internal`**.
- Alcance: paquete `MachSoft.Template.Core` + template `machsoft-app` + hosts de validación (`Starter` y `Starter.Wasm`).

## 1) Validaciones técnicas obligatorias

### 1.1 Solución base
- [ ] `dotnet restore MachSoft.Template.sln`
- [ ] `dotnet build MachSoft.Template.sln -c Release`

### 1.2 Paquete NuGet
- [ ] `dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o <output>`
- [ ] Verificar generación de:
  - [ ] `MachSoft.Template.Core.<version>.nupkg`
  - [ ] `MachSoft.Template.Core.<version>.snupkg`

### 1.3 Template oficial
- [ ] `dotnet pack template/MachSoft.Template.Official.Pack/MachSoft.Template.Official.Pack.csproj -c Release -o ./artifacts/templates`
- [ ] `dotnet new install ./artifacts/templates/MachSoft.Template.Official.1.0.0-internal.nupkg`
- [ ] `dotnet new machsoft-app -n <AppName> -o <output> [--CorePackageVersion <version>]`

### 1.4 App generada (smoke técnico)
- [ ] `dotnet restore <output>/<AppName>.csproj`
- [ ] `dotnet build <output>/<AppName>.csproj -c Release`
- [ ] `dotnet run --project <output>/<AppName>.csproj --no-build -c Release`

## 2) Validaciones funcionales mínimas

### 2.1 Hosts de validación interna
- [ ] Starter Server (`template/MachSoft.Template.Starter`) arranca.
- [ ] Starter WASM (`template/MachSoft.Template.Starter.Wasm`) arranca.

### 2.2 Rutas mínimas obligatorias
- [ ] Server `/showcase` en **light**.
- [ ] Server `/showcase` en **dark**.
- [ ] Server `/demo`.
- [ ] WASM `/showcase` en **light**.
- [ ] WASM `/showcase` en **dark**.
- [ ] WASM `/wasm-demo`.

### 2.3 Señales funcionales mínimas
- [ ] Shell responsive operativo (sidebar/hamburguesa/overlay según viewport).
- [ ] Toggle de tema aplica `data-mx-theme` y persiste en `localStorage` (`mx-theme`).
- [ ] Assets `_content/MachSoft.Template.Core/*` cargan sin errores visibles.
- [ ] En app generada, rutas `/`, `/operations`, `/settings` responden sin error.

## 3) Validaciones de documentación
- [ ] `README.md` refleja versión interna y circuito operativo vigente.
- [ ] `docs/ARCHITECTURE.md` refleja frontera paquete/template/hosts.
- [ ] `docs/TEMPLATE_GUIDE.md` refleja instalación y uso real de `machsoft-app`.
- [ ] `docs/ADOPTION_GUIDE.md` refleja adopción operativa para equipos.
- [ ] `src/MachSoft.Template.Core/NUGET_README.md` refleja flujo de publicación/consumo.
- [ ] Estado de release actualizado en `docs/DESIGN_SYSTEM_STATUS.md`.

## 4) Criterio Go / No-Go

### Go
La release interna **sale** solo si:
1. Todo el bloque técnico (restore/build/pack/template/app generada) pasa.
2. Smoke funcional de rutas y tema pasa en Server y WASM.
3. Documentación operativa quedó consistente con el código actual.

### No-Go
La release interna **no sale** si existe cualquiera de estos bloqueos:
1. Falla restore/build/pack.
2. No puede instalarse template o crear app nueva.
3. App generada no restaura/build/run.
4. Ruta smoke obligatoria caída (`/showcase`, `/demo`, `/wasm-demo`).
5. Rotura visible de shell/theming/assets `_content`.
6. Documentación contradictoria con el estado real.
