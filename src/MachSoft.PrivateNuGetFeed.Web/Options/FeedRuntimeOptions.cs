using System.ComponentModel.DataAnnotations;

namespace MachSoft.PrivateNuGetFeed.Web.Options;

public sealed class FeedRuntimeOptions
{
    public const string SectionName = "Feed";

    [Required]
    public string SourceName { get; set; } = "MachSoftPrivate";

    [Required]
    public string ApiKey { get; set; } = "__SET_IN_APP_SETTINGS__";

    [Required]
    public string PackageStoragePath { get; set; } = "App_Data/Packages";

    [Required]
    public string DatabasePath { get; set; } = "App_Data/Data/baget.db";
}
