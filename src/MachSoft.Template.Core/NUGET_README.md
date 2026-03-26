# MachSoft.Template.Core

`MachSoft.Template.Core` is the reusable corporate baseline package for MachSoft Blazor applications.

## Included baseline capabilities

- service registration extensions
- lightweight reusable shell components
- shared static web assets and theme bundle
- host-neutral options for company and application metadata

## Usage

```csharp
builder.Services.AddMachSoftTemplateCore(options =>
{
    options.ApplicationName = builder.Environment.ApplicationName;
    options.CompanyName = "MachSoft";
});
```

Reference the theme bundle from the package static assets:

```html
<link rel="stylesheet" href="_content/MachSoft.Template.Core/css/machsoft-template-core.css" />
```

### Required theme script for `AppShell`

`AppShell` uses JS interop with `window.machsoftTheme` to persist and toggle light/dark mode.
Add this script in the host page (`App.razor`, `_Host.cshtml`, or `index.html` depending on the host model):

```html
<script src="_content/MachSoft.Template.Core/js/theme.js"></script>
```

If the script is missing, `AppShell` now falls back safely to light mode (without persisted theme toggle) instead of throwing runtime exceptions.


## Architectural boundary (2026-03-26)

`MachSoft.Template.Core` no longer exposes public `Mx*` catalog controls.
Use `MachSoft.Template.Core.Control` for all public UI controls.
