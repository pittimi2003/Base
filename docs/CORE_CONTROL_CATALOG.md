# MachSoft.Template.Core.Control — enfoque técnico inicial

## Objetivo
Definir el catálogo oficial `Mx*` como paquete NuGet distribuible y host de validación desacoplado.

## Separación de responsabilidades
- `MachSoft.Template.Core`: base del design system (tokens, theming, utilidades, contratos compartidos).
- `MachSoft.Template.Core.Control`: catálogo oficial de controles con API pública y static web assets propios.
- `MachSoft.Template.Core.Control.Showcase`: aplicación host para validación visual/funcional.

## Estructura base de `Core.Control`
- `Components/`
- `Styles/`
- `Internal/`
- `Models/`
- `Services/`
- `wwwroot/css/machsoft-template-core-control.css`

## Roadmap de familias preparado
- DataGrid / Tabla
- Select / ComboBox / Autocomplete / MultiSelect
- Button / IconButton
- DatePicker / DateRangePicker
- TimePicker
- Scheduler
- List / ListBox
- Dialog / Popup
- Snackbar / Toast
- Alert
- Progress
- Avatar
- Chip
- Tooltip
- Upload

## Validación en Showcase
- Home del catálogo
- Foundations visuales (`/foundations`)
- Familias por roadmap
- Toggle de tema light/dark
