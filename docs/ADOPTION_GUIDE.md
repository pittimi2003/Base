# Adoption Guide — MachSoft Design System (interna)

## Versión y estado operativo
- Versión interna objetivo: **`v1.0.0-internal`**.
- Estado: base estable para adopción interna controlada.
- Lenguaje oficial de desarrollo nuevo: **`Mx*`**.

## 1) Qué usar como estándar oficial
1. `MachSoft.Template.Core` como runtime reusable.
2. `machsoft-app` como template oficial para app nueva Server.
3. Componentes `Mx*` para UI nueva.
4. Tokens y estilos `_content/MachSoft.Template.Core/css/template/*`.

## 2) Qué evitar
- No crear UI nueva sobre componentes legacy (`BaseCard`, `PageContainer`, `FormSection`, `FieldGroup`, `SectionTitle`).
- No mover lógica de negocio al Core.
- No duplicar estilos entre hosts.
- No asumir que el template trae showcase/demo/samples.

## 3) Cómo arrancar una app nueva (flujo recomendado)
```bash
dotnet new install ./artifacts/templates/MachSoft.Template.Official.1.0.0-internal.nupkg
dotnet new machsoft-app -n Contoso.App -o ./Contoso.App --CorePackageVersion 1.0.0-internal
cd Contoso.App
dotnet restore --source "<PRIVATE_FEED_OR_LOCAL_SOURCE>" --source https://api.nuget.org/v3/index.json
dotnet build -c Release
dotnet run --no-build -c Release
```

## 4) Cómo referenciar y actualizar el paquete
- Referencia base en `.csproj`:

```xml
<PackageReference Include="MachSoft.Template.Core" Version="1.0.0-internal" />
```

- Para actualizar:
  1. subir versión (`1.0.1-internal`, `1.1.0-internal`, etc.),
  2. `dotnet restore`,
  3. `dotnet build -c Release`,
  4. smoke de rutas mínimas.

## 5) Smoke básico que debe correr cada equipo

### Sistema base (repo)
- Server: `/showcase` light/dark y `/demo`.
- WASM: `/showcase` light/dark y `/wasm-demo`.

### App generada
- `/`, `/operations`, `/settings`.

## 6) Limitaciones conocidas (honestas)
1. Algunos controles nativos (date/file) pueden variar visualmente según navegador/SO.
2. El template oficial es de bootstrap; no es una suite completa de módulos de negocio.
3. El estado actual es estable interno, no release público externo.

## 7) Áreas listas para uso normal
- Shell/layout responsive común.
- Theming light/dark con persistencia.
- Catálogo `Mx*` de grupos Foundation, Forms, Navigation/Overlays, Data display, Inputs y Data en su baseline actual.

## 8) Áreas estables pero no premium
- Inputs enterprise avanzados y data components están estables en contrato base, pero con alcance inicial controlado (sin feature set “premium” completo).

## 9) Referencias operativas obligatorias
- Checklist de release: `docs/INTERNAL_RELEASE_CHECKLIST.md`.
- Baseline repetible: `docs/OPERATIONS_BASELINE.md`.
- Guía de template: `docs/TEMPLATE_GUIDE.md`.
- Flujo NuGet: `src/MachSoft.Template.Core/NUGET_README.md`.
