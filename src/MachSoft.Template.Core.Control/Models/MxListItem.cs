namespace MachSoft.Template.Core.Control.Models;

public sealed record MxListItem(
    string Value,
    string Text,
    string? SecondaryText = null,
    string? Icon = null,
    bool Disabled = false);
