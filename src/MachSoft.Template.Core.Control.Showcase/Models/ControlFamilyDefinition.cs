namespace MachSoft.Template.Core.Control.Showcase.Models;

public sealed record ControlFamilyDefinition(
    string Key,
    string Name,
    string Description,
    string Status = "Planned");
