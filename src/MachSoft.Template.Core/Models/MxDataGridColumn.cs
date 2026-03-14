namespace MachSoft.Template.Core.Models;

public sealed record MxDataGridColumn<TItem>(string Title, Func<TItem, string?> ValueSelector, string? Width = null);
