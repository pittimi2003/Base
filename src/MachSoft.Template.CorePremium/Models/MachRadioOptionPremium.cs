namespace MachSoft.Template.CorePremium.Models;

public sealed record MachRadioOptionPremium(
    string Value,
    string Label,
    string? Description = null,
    bool Disabled = false);
