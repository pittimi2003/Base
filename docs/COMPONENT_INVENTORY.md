# Component Inventory (Consolidation Iteration)

## Scope audited
- `src/MachSoft.Template.Core/Components/Foundation`
- `src/MachSoft.Template.Core/Components/Forms`
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

### LEGACY
- `BaseCard` → replaced by `MxCard`
- `PageContainer` → replaced by `MxPageHeader` + `MxPanel/MxCard` composition
- `FormSection` → replaced by `MxFormSection`
- `FieldGroup` → replaced by `MxFieldGroup`
- `SectionTitle` → replaced by `MxFormSection` header semantics

### INTERNAL
- `AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`, `MainLayout`
- `SideNav` (legacy navigation helper)
- `AppMenuTile` (template navigation tile for starter/sample shell)

## Consolidation decisions
1. No new groups/components were introduced.
2. Legacy components remain functional but explicitly marked as deprecated in source.
3. Starter pages are now composed using Mx* components/patterns to accelerate team adoption.
