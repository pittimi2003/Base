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


## 2026-03-25 - Forms baseline adoption (architectural correction)

- Moved baseline public inputs ownership from `MachSoft.Template.Core` to `MachSoft.Template.Core.Control`.
- Added dedicated host `MachSoft.Template.Core.Control.Showcase` for visual/functional validation of the family.
- Removed duplicated public implementations from `MachSoft.Template.Core` to keep base/control boundaries clean.
- Kept API decisions for `MxSelect.ReadOnly` (non-interactive mode) and minimal contracts for all controls.

## 2026-03-25 - Inputs baseline hardening

- Hardened accessibility/state handling in `MxTextField`, `MxTextArea`, `MxCheckbox`, `MxRadio`, `MxSwitch`, `MxSelect`.
- Added explicit NuGet readme metadata in `MachSoft.Template.Core.Control`.
- Documented current limits for `MxRadio` grouping and `MxSelect` readonly semantics.
