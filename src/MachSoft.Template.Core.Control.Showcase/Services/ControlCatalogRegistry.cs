using MachSoft.Template.Core.Control.Showcase.Models;

namespace MachSoft.Template.Core.Control.Showcase.Services;

public static class ControlCatalogRegistry
{
    public static IReadOnlyList<ControlFamilyDefinition> Families { get; } =
    [
        new("actions", "Actions", "Acciones primarias, secundarias y contextuales del lenguaje Mx*.", "Implemented", "Botones públicos y acciones rápidas", "/families/actions"),
        new("feedback", "Feedback", "Estados operativos y mensajería contextual de la interfaz.", "Implemented", "Alert, progress y toast", "/families/feedback"),
        new("overlays", "Overlays", "Componentes de superposición para interacción contextual y modal.", "Implemented", "Tooltip, popup y dialog", "/families/overlays"),
        new("inputs", "Inputs", "Entradas base para captura de texto y estructura de formulario.", "Implemented", "TextField, TextArea, Checkbox, Radio, Switch y Select", "/families/inputs"),
        new("selection", "Selection", "Selecciones simples y múltiples con comportamiento consistente.", "Implemented", "Autocomplete, multi-select y combo box", "/families/selection"),
        new("datetime", "DateTime", "Fecha, rango y hora con foco en consistencia y accesibilidad.", "Implemented", "DatePicker, DateRange y Time", "/families/datetime"),
        new("display", "Display", "Representación visual de estado, métricas y contenido contextual.", "Planned", "Tag, status, stats y empty states", "/families/display"),
        new("data", "Data", "Visualización enterprise de datos tabulares, jerárquicos y gráficos.", "Planned", "Grid, tree y chart", "/families/data"),
        new("upload", "Upload", "Carga de archivos reutilizable y compatible cross-host.", "Implemented", "Flujo base de upload", "/families/upload"),
        new("scheduling", "Scheduling", "Planificación operativa y visualización de slots.", "Planned", "Calendario operativo y agenda", "/families/scheduling")
    ];

    public static ControlFamilyDefinition? FindByKey(string? key)
    {
        if (string.IsNullOrWhiteSpace(key))
        {
            return null;
        }

        return Families.FirstOrDefault(family =>
            string.Equals(family.Key, key, StringComparison.OrdinalIgnoreCase));
    }
}
