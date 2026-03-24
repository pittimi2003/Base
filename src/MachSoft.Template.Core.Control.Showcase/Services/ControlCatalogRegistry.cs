using MachSoft.Template.Core.Control.Showcase.Models;

namespace MachSoft.Template.Core.Control.Showcase.Services;

public static class ControlCatalogRegistry
{
    public static IReadOnlyList<ControlFamilyDefinition> Families { get; } =
    [
        new("datagrid", "DataGrid / Tabla", "Estructuras tabulares, columnas tipadas y estados vacíos.", "Planned"),
        new("selection", "Select / ComboBox / Autocomplete / MultiSelect", "Entradas de selección simple y múltiple para flujos enterprise.", "In progress"),
        new("actions", "Button / IconButton", "Acciones primarias, secundarias y contextuales.", "In progress"),
        new("dates", "DatePicker / DateRangePicker", "Selección de fechas y rangos con contrato consistente.", "In progress"),
        new("time", "TimePicker", "Selección horaria con formato consistente y accesible.", "Planned"),
        new("scheduler", "Scheduler", "Visualización y edición básica de slots operativos.", "Planned"),
        new("lists", "List / ListBox", "Listados accesibles para navegación y selección.", "Planned"),
        new("overlays", "Dialog / Popup", "Capas modales y contextuales.", "In progress"),
        new("notifications", "Snackbar / Toast", "Mensajería temporal y notificaciones transitorias.", "In progress"),
        new("alert", "Alert", "Feedback persistente por severidad.", "Planned"),
        new("progress", "Progress", "Indicadores de avance lineales y compactos.", "In progress"),
        new("avatar", "Avatar", "Representación visual de usuario/equipo.", "Planned"),
        new("chip", "Chip", "Etiquetas interactivas y filtros rápidos.", "Planned"),
        new("tooltip", "Tooltip", "Ayuda contextual breve y no intrusiva.", "Planned"),
        new("upload", "Upload", "Carga de archivos cross-hosting.", "In progress")
    ];
}
