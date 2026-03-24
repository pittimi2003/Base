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


## Incremento: separación Core / Core.Control / Showcase

- Added `MachSoft.Template.Core.Control` as a NuGet-ready Razor Class Library as the distributable base for the official `Mx*` catalog roadmap (incremental, not complete).
- Added `MachSoft.Template.Core.Control.Showcase` as an isolated host to validate catalog rendering and interactions.
- Preserved `MachSoft.Template.Core` as base design system layer (tokens, theme, shared primitives).
- Registered both projects in `MachSoft.Templates.sln` and wired references: `Core.Control -> Core`, `Showcase -> Core.Control`.
- Established visible light/dark validation path in Showcase without coupling demo-only assets into the package payload.


## Consolidation fixes (post-initial iteration)

- Renamed Showcase route/page from `/fundations` to `/foundations` for consistent naming.
- Moved roadmap model/service/component out of `MachSoft.Template.Core.Control` into `MachSoft.Template.Core.Control.Showcase` to keep NuGet payload focused on distributable assets/contracts.
- Kept package and showcase separation explicit before starting new control-family implementations.
