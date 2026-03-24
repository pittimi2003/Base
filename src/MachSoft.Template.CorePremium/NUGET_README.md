# MachSoft.Template.CorePremium

`MachSoft.Template.CorePremium` extends `MachSoft.Template.Core` with optional enterprise-grade premium controls.

## Includes
- Advanced page header, toolbar and section surfaces
- Rich tabs, dialog and toast interactions
- KPI/stat cards and premium empty states
- Shared premium theme bundle

## Usage

```csharp
builder.Services
    .AddMachSoftTemplateCore()
    .AddMachSoftTemplateCorePremium();
```

```html
<link rel="stylesheet" href="_content/MachSoft.Template.Core/css/machsoft-template-core.css" />
<link rel="stylesheet" href="_content/MachSoft.Template.CorePremium/css/machsoft-template-corepremium.css" />
```

## Premium catalog (v1)

- Layout/surfaces: `MachPageHeaderPremium`, `MachToolbarPremium`, `MachCardPremium`, `MachStatCardPremium`, `MachSectionPanelPremium`
- Navigation: `MachTabsPremium`, `MachBreadcrumbsPremium`
- Forms/inputs: `MachTextFieldPremium`, `MachSelectPremium`, `MachCheckboxPremium`, `MachRadioGroupPremium`, `MachSwitchPremium`, `MachDatePickerPremium`, `MachUploadPremium`
- Data: `MachDataGridPremium<TItem>`, `MachListPremium<TItem>`
- Feedback/overlays: `MachEmptyStatePremium`, `MachDialogPremium`, `MachToastPremium`

## Pack and push

```powershell
pwsh ./build/scripts/Pack-CorePremium.ps1 -Configuration Release
```

Push the generated `.nupkg` to your configured `MachSoftPrivate` source.
