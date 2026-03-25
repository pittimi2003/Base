using MachSoft.Template.Core.Control.Models;

namespace MachSoft.Template.Core.Control.Internal;

internal static class SelectionSearch
{
    public static IReadOnlyList<MxSelectOption> Filter(IEnumerable<MxSelectOption> options, string? searchText)
    {
        if (string.IsNullOrWhiteSpace(searchText))
        {
            return options.ToArray();
        }

        return options
            .Where(option => option.Text.Contains(searchText, StringComparison.OrdinalIgnoreCase))
            .ToArray();
    }

    public static int MoveActiveIndex(int currentIndex, int totalCount, int direction)
    {
        if (totalCount <= 0)
        {
            return -1;
        }

        var next = currentIndex;
        if (next < 0)
        {
            return direction > 0 ? 0 : totalCount - 1;
        }

        next += direction;
        if (next < 0)
        {
            return totalCount - 1;
        }

        if (next >= totalCount)
        {
            return 0;
        }

        return next;
    }
}
