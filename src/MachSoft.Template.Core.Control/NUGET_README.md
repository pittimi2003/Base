# MachSoft.Template.Core.Control

`MachSoft.Template.Core.Control` is the public controls catalog package built on top of `MachSoft.Template.Core`.

## Baseline inputs in this package

- `MxTextField`
- `MxTextArea`
- `MxCheckbox`
- `MxRadio`
- `MxSwitch`
- `MxSelect`

## Notes

- The package is host-agnostic and supports Blazor Server and WebAssembly.
- `MxSelect.ReadOnly` is intentionally implemented as a non-interactive mode to keep cross-browser behavior consistent.
- `MxRadio` currently uses native `name` grouping; an advanced group abstraction is intentionally out of scope for this baseline.
