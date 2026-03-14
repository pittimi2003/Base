namespace MachSoft.Template.Core.Models;

public sealed class MxTreeGridItem
{
    public required string Id { get; init; }
    public required string Label { get; init; }
    public string? Meta { get; init; }
    public IReadOnlyList<MxTreeGridItem> Children { get; init; } = Array.Empty<MxTreeGridItem>();
}
