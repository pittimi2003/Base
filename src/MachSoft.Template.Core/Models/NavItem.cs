namespace MachSoft.Template.Core.Models;

public sealed record NavItem(
    string Text,
    string Href,
    string Icon = "",
    string? Section = null,
    IReadOnlyList<NavItem>? Children = null);
