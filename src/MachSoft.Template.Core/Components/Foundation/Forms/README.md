# Legacy note — Foundation Forms in `MachSoft.Template.Core`

Los componentes `Mx*` de esta carpeta se mantienen por compatibilidad histórica interna de la plantilla.

## Estado arquitectónico actual
- **Catálogo público oficial de inputs base (`MxTextField`, `MxTextArea`, `MxCheckbox`, `MxRadio`, `MxSwitch`, `MxSelect`)**:
  - `MachSoft.Template.Core.Control`
- **Host de validación visual/funcional oficial de esta familia**:
  - `MachSoft.Template.Core.Control.Showcase` (`/families/inputs`)

## Regla de evolución
- No promover nuevos contratos públicos de inputs en `MachSoft.Template.Core`.
- Toda evolución de API pública de inputs debe ocurrir en `MachSoft.Template.Core.Control`.
