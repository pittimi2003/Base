namespace MachSoft.Template.Core.Control.Models;

public sealed record MxSchedulerEvent(
    string Id,
    string Title,
    DateTime Start,
    DateTime? End = null,
    bool IsAllDay = false,
    string? Description = null,
    string? AccentColor = null);
