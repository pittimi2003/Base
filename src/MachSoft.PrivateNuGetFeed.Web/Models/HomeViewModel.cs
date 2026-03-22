namespace MachSoft.PrivateNuGetFeed.Web.Models;

public sealed class HomeViewModel
{
    public required string CompanyName { get; init; }

    public required string PortalTitle { get; init; }

    public required string PortalSubtitle { get; init; }

    public required string HeroDescription { get; init; }

    public required string InternalUseBadgeText { get; init; }

    public required string PortalVersion { get; init; }

    public required string FooterUsageText { get; init; }

    public required string FeedOwnerContact { get; init; }

    public required int CurrentYear { get; init; }

    public required string PortalBaseUrl { get; init; }

    public required string ServiceIndexUrl { get; init; }

    public required string PackagePublishUrl { get; init; }

    public required string SourceName { get; init; }

    public required string StorageSummary { get; init; }

    public required IReadOnlyList<CommandSnippetViewModel> ConsumeCommands { get; init; }

    public required IReadOnlyList<CommandSnippetViewModel> PublishCommands { get; init; }

    public required IReadOnlyList<FeaturedPackageViewModel> FeaturedPackages { get; init; }

    public required IReadOnlyList<QuickGuideStepViewModel> QuickGuideSteps { get; init; }

    public required IReadOnlyList<CommandSnippetViewModel> RouteSummaries { get; init; }

    public required IReadOnlyList<string> ConfigurationHighlights { get; init; }

    public required IReadOnlyList<string> InternalNotes { get; init; }
}
