# MachSoft.Template.Official

Template corporativo oficial para generar aplicaciones Blazor Server con shell/layout MachSoft y consumo de `MachSoft.Template.Core`.

## Uso

```bash
dotnet new install ./template/MachSoft.Template.Official
dotnet new machsoft-app -n MyCompany.App
```

## Parámetros
- `--CorePackageVersion`: versión del paquete `MachSoft.Template.Core` en la app generada (default `1.0.0-internal`).

## Incluye
- Shell corporativo (`AppShell`) con navegación lateral responsive.
- Theming base light/dark con `theme.js` y tokens oficiales.
- Páginas iniciales: `/`, `/operations`, `/settings`.

## No incluye
- Showcase interno (`/showcase`).
- Demos internas (`/demo`, `/wasm-demo`).
- Samples de validación del repositorio.
