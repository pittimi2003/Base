namespace MachSoft.Template.Core.Control.Models;

public enum MxButtonVariant
{
    Primary,
    Secondary,
    Tertiary,
    Danger
}

public enum MxButtonSize
{
    Small,
    Medium,
    Large
}

public enum MxBadgeVariant
{
    Neutral,
    Brand,
    Success,
    Warning,
    Danger
}

public enum MxBadgeSize
{
    Small,
    Medium
}

public enum MxTabsVariant
{
    Underline,
    Pills
}

public enum MxDialogSize
{
    Small,
    Medium,
    Large
}

public enum MxDrawerSide
{
    Start,
    End
}

public enum MxToastVariant
{
    Info,
    Success,
    Warning,
    Danger
}

public enum MxTagVariant
{
    Neutral,
    Brand,
    Success,
    Warning,
    Danger
}

public enum MxStatusVariant
{
    Info,
    Success,
    Warning,
    Danger,
    Offline
}

public enum MxProgressVariant
{
    Brand,
    Success,
    Warning,
    Danger
}

public enum MxChartType
{
    Bar,
    Line
}

public sealed record MxSelectOption(string Value, string Text, bool Disabled = false);
public sealed record MxInputOption(string Value, string Text, bool Disabled = false);
public sealed record MxTabItem(string Value, string Text, bool Disabled = false);
public sealed record MxBreadcrumbItem(string Text, string? Href = null, bool IsCurrent = false, bool Disabled = false);
public sealed record MxChartSeries(string Name, IReadOnlyList<double> Values);
public sealed record MxDataGridColumn<TItem>(string Title, Func<TItem, string?> ValueSelector, string? Width = null);

public sealed class MxTreeGridItem
{
    public string Id { get; init; } = Guid.NewGuid().ToString("N");
    public string Label { get; init; } = string.Empty;
    public string? Meta { get; init; }
    public IReadOnlyList<MxTreeGridItem> Children { get; init; } = Array.Empty<MxTreeGridItem>();
}
