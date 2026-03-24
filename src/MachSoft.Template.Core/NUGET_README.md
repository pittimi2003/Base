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
