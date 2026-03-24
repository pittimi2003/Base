# Migration Report

## Status

The repository now includes a dedicated .NET 8 productization layout for MachSoft corporate templates.

## Delivered changes

- Added a dedicated solution file, `MachSoft.Templates.sln`, for the active template productization artifacts.
- Kept `MachSoft.Template.Core` as the reusable baseline package.
- Added two separate official `dotnet new` template packages:
  - `MachSoft.Template.Official.Server`
  - `MachSoft.Template.Official.Wasm`
- Added placeholder-only private feed configuration with no secrets.
- Added packaging scripts and documentation for build, pack, install, and internal feed consumption.

## Conservative assumptions made

1. The shared package version starts at `1.0.0-internal`.
2. Generated applications restore `MachSoft.Template.Core` from a NuGet feed rather than a project reference.
3. Root namespace override is treated as an optional template parameter, while project name remains the primary generated identifier.
4. Template content is intentionally minimal, production-oriented, and free of business logic.


## Actualización v1.0.0-internal (CorePremium)

- Se incorpora `src/MachSoft.Template.CorePremium` como RCL opcional para controles enterprise avanzados.
- `MachSoft.Template.Core` mantiene su rol foundation sin dependencias hacia Premium.
- Se agrega `samples/MachSoft.Template.SampleApp` para validación visual de `Core + CorePremium` en la ruta `/premium-showcase`.
- Se agrega flujo de empaquetado `build/scripts/Pack-CorePremium.ps1` y su integración en `Pack-All.ps1`.

## CorePremium catalog expansion (2026-03-24)

- Expanded `MachSoft.Template.CorePremium` to include a first complete enterprise catalog for layout/surfaces, navigation, forms, data/list, feedback, and overlays.
- Added premium wrappers that reuse foundation components from `MachSoft.Template.Core` to avoid duplication and preserve optional adoption.
- Updated `MachSoft.Template.SampleApp` with a complete visual preview page in `/premium-showcase`, plus shell compatibility routes `/demo` and `/wasm-demo`.
- Added bUnit baseline tests for breadcrumbs, radio group interaction, premium data grid rendering, tabs, dialog semantics, and page header rendering.
