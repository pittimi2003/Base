namespace MachSoft.Template.Core.Control.Models;

public sealed record MxListBoxOption(
    string Value,
    string Text,
    string? SecondaryText = null,
    string? Icon = null,
    bool Disabled = false);
