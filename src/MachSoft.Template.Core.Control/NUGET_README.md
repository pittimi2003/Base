# MachSoft.Template.Core.Control

`MachSoft.Template.Core.Control` is the public controls catalog package built on top of `MachSoft.Template.Core`.

## Baseline inputs in this package

- `MxTextField`
- `MxTextArea`
- `MxCheckbox`
- `MxRadio`
- `MxSwitch`
- `MxSelect`

## Advanced selection family (iteration 1)

- `MxAutocomplete`
  - Local text filtering over `IEnumerable<MxSelectOption>`.
  - Explicit suggestion list (`role="listbox"`) with keyboard support (`ArrowUp`, `ArrowDown`, `Enter`, `Escape`).
  - Supports `disabled`, `invalid`, `loading`, and `no-results` states.
- `MxMultiSelect`
  - Real multi-selection without native `<select multiple>`.
  - Selected values rendered as removable chips.
  - Supports local filter text, `disabled`, `invalid`, `loading`, and `no-results` states.
- `MxComboBox`
  - Single selection with free-text search and controlled popup.
  - Combines input + dropdown behavior with clear selection path.
  - Supports `disabled`, `invalid`, `loading`, and `no-results` states.

## Notes

- The package is host-agnostic and supports Blazor Server and WebAssembly.
- `MxSelect.ReadOnly` is intentionally implemented as a non-interactive mode to keep cross-browser behavior consistent.
- `MxRadio` currently uses native `name` grouping; an advanced group abstraction is intentionally out of scope for this baseline.
- Iteration 1 intentionally does not include remote providers, virtualization, advanced templating, or enterprise-grade ranking.
