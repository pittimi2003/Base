# Architecture

## Overview

The repository is structured as a .NET 8 productization workspace for three active deliverables and one distribution concern:

- `MachSoft.Template.Core`: reusable Razor Class Library and NuGet package.
- `MachSoft.Template.Official.Server`: official `dotnet new` template package for Blazor Web App with Razor Components + Interactive Server rendering.
- `MachSoft.Template.Official.Wasm`: official `dotnet new` template package for Blazor WebAssembly.
- Private feed onboarding: placeholder configuration and operational documentation for internal distribution.

## Solution boundaries

### 1. Reusable baseline package

`src/MachSoft.Template.Core` is the shared UI/runtime dependency for generated applications.

Responsibilities:

- options and service registration
- lightweight reusable UI components
- shared corporate theme assets distributed as static web assets
- host-agnostic baseline with no business logic

### 2. Official server template package

`src/MachSoft.Template.Official.Server` is a packaging project only.

Responsibilities:

- embed a complete `dotnet new` template in `template-content`
- expose metadata for internal template discovery
- produce a NuGet template package installable with `dotnet new install`

The generated app is a .NET 8 Blazor Web App configured for Razor Components + Interactive Server rendering and references `MachSoft.Template.Core` from NuGet.

### 3. Official WebAssembly template package

`src/MachSoft.Template.Official.Wasm` is a packaging project only.

Responsibilities:

- embed a standalone WebAssembly template in `template-content`
- expose separate template metadata for internal use
- produce a NuGet template package installable with `dotnet new install`

The generated app is a .NET 8 Blazor WebAssembly host that references `MachSoft.Template.Core` from NuGet.

## Packaging strategy

### Core package

`MachSoft.Template.Core` is packed directly from its SDK-style `.csproj` and can be published to any internal NuGet v3 source.

### Template packages

Each official template is packed as a `PackageType=Template` package. Build output is excluded and only template content plus package metadata are included.

## Private feed support

The repository intentionally uses placeholder-only URLs:

- `https://your-private-feed/v3/index.json`

No credentials are stored in source control. Teams are expected to inject credentials using standard NuGet authentication mechanisms outside the repository.

## Design choices preserved

- Server and Wasm remain separate official templates.
- The shared reusable package remains `MachSoft.Template.Core`.
- No Docker, CI/CD workflow, authentication, database, or business features are added to generated apps.


## Actualización v1.0.0-internal (CorePremium)

- Se incorpora `src/MachSoft.Template.CorePremium` como RCL opcional para controles enterprise avanzados.
- `MachSoft.Template.Core` mantiene su rol foundation sin dependencias hacia Premium.
- Se agrega `samples/MachSoft.Template.SampleApp` para validación visual de `Core + CorePremium` en la ruta `/premium-showcase`.
- Se agrega flujo de empaquetado `build/scripts/Pack-CorePremium.ps1` y su integración en `Pack-All.ps1`.

## CorePremium boundaries (updated)

`MachSoft.Template.CorePremium` is an optional RCL extension over `MachSoft.Template.Core` and contains only advanced controls (composite forms, richer data/list experiences, premium overlays, and navigation composition). `MachSoft.Template.Core` does not depend on Premium.

Sample validation host:
- `samples/MachSoft.Template.SampleApp`
- Main premium route: `/premium-showcase`
- Core showcase route (via additional assemblies): `/showcase`
