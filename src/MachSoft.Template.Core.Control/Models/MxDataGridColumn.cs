namespace MachSoft.Template.Core.Control.Models;

public sealed record MxDataGridColumn<TItem>
{
    public MxDataGridColumn(
        string Header,
        Func<TItem, string?> ValueSelector,
        string? Width = null,
        string? HeaderClass = null,
        string? CellClass = null)
    {
        if (string.IsNullOrWhiteSpace(Header))
        {
            throw new ArgumentException("Column header cannot be null or whitespace.", nameof(Header));
        }

        this.Header = Header;
        this.ValueSelector = ValueSelector ?? throw new ArgumentNullException(nameof(ValueSelector));
        this.Width = Width;
        this.HeaderClass = HeaderClass;
        this.CellClass = CellClass;
    }

    public string Header { get; }
    public Func<TItem, string?> ValueSelector { get; }
    public string? Width { get; }
    public string? HeaderClass { get; }
    public string? CellClass { get; }
}
