namespace MachSoft.Template.Core.Models;

public sealed record MxBreadcrumbItem(string Text, string? Href = null, bool IsCurrent = false, bool Disabled = false);
