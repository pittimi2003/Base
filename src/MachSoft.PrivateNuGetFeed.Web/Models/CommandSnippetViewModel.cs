namespace MachSoft.PrivateNuGetFeed.Web.Models;

public sealed class CommandSnippetViewModel
{
    public required string Label { get; init; }

    public required string Command { get; init; }

    public required string Description { get; init; }
}
