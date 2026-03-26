# Component Inventory (Consolidation Iteration)

## Scope audited
- `src/MachSoft.Template.Core/Components/Foundation`
- `src/MachSoft.Template.Core/Components/Navigation`
- `src/MachSoft.Template.Core/Layout`
- `src/MachSoft.Template.Core/Components/Common` (no files currently)

## Classification

### FOUNDATION
- `MxButton`, `MxIconButton`
- `MxBadge`, `MxToast`
- `MxCard`, `MxPanel`
- `MxPageHeader`
- `MxTextField`, `MxTextarea`, `MxSelect`, `MxCheckbox`, `MxSwitch`, `MxFieldGroup`, `MxFormSection`
- `MxTabs`, `MxBreadcrumb`, `MxDialog`, `MxDrawer`
- `MxTag`, `MxStatusIndicator`, `MxEmptyState`, `MxStatCard`, `MxProgress`

### COMPONENT
- `MxDatePicker`, `MxDateRangePicker`, `MxAutocomplete`, `MxMultiSelect`, `MxFileUpload`

### DATA
- `MxDataGrid`, `MxTreeGrid`, `MxChart`

### PATTERN
- `MxSearchPanel`, `MxFilterBar`, `MxDashboardSection`, `MxMasterDetail`, `MxSettingsPage`

### INTERNAL
- `AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`, `MainLayout`
- `SideNav` (navigation helper used by `AppNavigation`)

## Consolidation decisions
1. No new groups/components were introduced.
2. Legacy components (`BaseCard`, `PageContainer`, `FormSection`, `FieldGroup`, `SectionTitle`, `AppMenuTile`) were removed from `MachSoft.Template.Core`.
3. Showcase/demo experiences remain isolated in dedicated hosts (`Core.Control.Showcase` and official templates), not inside `Core`.
