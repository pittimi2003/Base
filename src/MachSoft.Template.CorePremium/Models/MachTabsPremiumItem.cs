namespace MachSoft.Template.CorePremium.Models;

public sealed record MachTabsPremiumItem(
    string Value,
    string Text,
    string? Hint = null,
    string? Badge = null,
    bool Disabled = false);
