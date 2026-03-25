namespace MachSoft.Template.Core.Control.Models;

public sealed record MxDataGridColumn<TItem>(
    string Header,
    Func<TItem, string?> ValueSelector,
    string? Width = null,
    string? HeaderClass = null,
    string? CellClass = null);
