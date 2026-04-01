namespace MachSoft.Template.Core.Control.Models;

public sealed record MxMenuItem(string Value, string Text, string? Description = null, bool Disabled = false);
