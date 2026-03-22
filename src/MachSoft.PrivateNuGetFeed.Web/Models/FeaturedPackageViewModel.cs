namespace MachSoft.PrivateNuGetFeed.Web.Models;

public sealed class FeaturedPackageViewModel
{
    public required string Name { get; init; }

    public required string Description { get; init; }

    public required string Version { get; init; }

    public required string InstallCommand { get; init; }
}
