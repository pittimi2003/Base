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

## Forms baseline in Core.Control

As of 2026-03-25, the public Forms inputs catalog is owned by `MachSoft.Template.Core.Control`, while `MachSoft.Template.Core` stays as foundational layer.

- `MachSoft.Template.Core`: tokens, shared theming, layout and reusable infrastructure.
- `MachSoft.Template.Core.Control`: `MxTextField`, `MxTextArea`, `MxCheckbox`, `MxRadio`, `MxSwitch`, `MxSelect`.
- `MachSoft.Template.Core.Control.Showcase`: dedicated visual/functional validation host for those controls.

This avoids ambiguity and prevents public catalog duplication between base and controls packages.
