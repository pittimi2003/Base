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

    public static int MoveActiveEnabledIndex(IReadOnlyList<MxSelectOption> options, int currentIndex, int direction)
    {
        if (options.Count == 0)
        {
            return -1;
        }

        if (options.All(option => option.Disabled))
        {
            return -1;
        }

        var next = currentIndex;
        for (var step = 0; step < options.Count; step++)
        {
            next = MoveActiveIndex(next, options.Count, direction);
            if (!options[next].Disabled)
            {
                return next;
            }
        }

        return -1;
    }

    public static int FirstEnabledIndex(IReadOnlyList<MxSelectOption> options)
        => options.FindIndex(option => !option.Disabled);

    private static int FindIndex(this IReadOnlyList<MxSelectOption> options, Func<MxSelectOption, bool> predicate)
    {
        for (var index = 0; index < options.Count; index++)
        {
            if (predicate(options[index]))
            {
                return index;
            }
        }

        return -1;
    }
}
