# Adoption Guide — MachSoft.Template v1

## Versión interna objetivo
**Versión adoptada:** `v1.0.0-internal`.

### ¿Por qué esta convención?
- `1.0.0` comunica que el template ya es usable como baseline para proyectos reales.
- sufijo `-internal` deja explícito que esta versión es para consumo interno (no release pública/nuget externa).
- mantiene una evolución semántica simple para próximas iteraciones (`1.0.1-internal`, `1.1.0-internal`, etc.).

## 1) Elegir variante de arranque

### Usa `template/MachSoft.Template.Starter` (Server) cuando:
- quieres renderizado interactivo en servidor;
- priorizas time-to-first-byte y centralización de runtime en backend;
- el host ejecutará sobre infraestructura ASP.NET Core estándar.

### Usa `template/MachSoft.Template.Starter.Wasm` cuando:
- necesitas ejecución cliente standalone;
- el equipo opera con despliegue estático/CDN para frontend;
- aceptas modelo WASM para carga inicial y runtime en navegador.

## 2) Qué vive en `MachSoft.Template.Core`
Debe contener solo assets y componentes **reusables cross-host**:
- layout común (`MainLayout`, `AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`);
- foundation components (`PageContainer`, `BaseCard`, `AppMenuTile`);
- primitivas visuales mínimas de formularios (`FormSection`, `SectionTitle`, `FieldGroup`);
- páginas base compartidas (`/`, `/showcase`);
- tokens y CSS corporativo (`tokens/base/layout/components/utilities`).

No debe contener:
- lógica de negocio;
- integraciones de infraestructura;
- componentes acoplados a un flujo único de una app.

## 3) Extender sin romper el sistema
1. Reusar primero `PageContainer + BaseCard` antes de crear nuevos wrappers.
2. Si necesitas una variante visual, evaluar primero `SurfaceVariant`/`TileVariant`.
3. Promover a Foundation solo si hay repetición real en al menos 2 contextos (Server/WASM o múltiples módulos).
4. Todo patrón promovido a Core debe tener ejemplo en `/showcase`.
5. Si cambia comportamiento del shell/layout, actualizar y correr E2E del shell.

## 4) Ejecutar Showcase y E2E

### Showcase
```bash
dotnet run --project template/MachSoft.Template.Starter
# abrir /showcase
```

### E2E (Playwright)
```bash
cd tests/e2e
npm install
npm run install:browsers
npm run test:mobile
npm run test:desktop
```

## 5) Iniciar un proyecto nuevo desde la plantilla (pasos recomendados)
1. Copiar `template/MachSoft.Template.Starter` **o** `template/MachSoft.Template.Starter.Wasm` como base del nuevo producto.
2. Renombrar:
   - carpeta del proyecto,
   - `.csproj`,
   - namespace raíz,
   - `AssemblyName`/`RootNamespace` si aplica,
   - textos de branding en `MainLayout`/`AppShell`.
3. Mantener referencia a `src/MachSoft.Template.Core` durante el arranque inicial.
4. Implementar primeras páginas de negocio sin mover todavía componentes a Core.
5. Validar shell + navegación + showcase antes de la primera entrega interna.

## 6) Checklist de adopción rápida
- [ ] Elegí host base: `Starter` (Server) o `Starter.Wasm`.
- [ ] Renombré proyecto, namespaces y branding.
- [ ] Verifiqué que `MachSoft.Template.Core` sigue referenciado.
- [ ] No modifiqué tokens/layout global sin necesidad de producto.
- [ ] Si añadí patrón reusable, lo mostré en `/showcase`.
- [ ] Corrí validación mínima:
  - [ ] `dotnet restore MachSoft.Template.sln`
  - [ ] `dotnet build MachSoft.Template.sln -c Release`
  - [ ] `cd tests/e2e && npm run test:mobile`
  - [ ] `cd tests/e2e && npm run test:desktop`

## 7) Qué no tocar al inicio
- No romper estructura de capas (`Core`, `Starter`, `Starter.Wasm`, `SampleApp`).
- No duplicar CSS entre hosts.
- No mover lógica de negocio a Core.
- No introducir componentes “semi-genéricos” en Foundation sin evidencia de reutilización.

## 8) Criterio de adopción para equipos
Un equipo puede considerar “adoptado” el template si:
- seleccionó host correcto y arrancó rutas base (`/`, `/showcase`, `/demo` o `/wasm-demo`);
- conserva shell responsive y accesibilidad base;
- mantiene separación Core/host sin duplicación;
- pasó build de solución y E2E mínima del shell.
