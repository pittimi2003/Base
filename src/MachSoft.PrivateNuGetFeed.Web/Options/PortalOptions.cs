using System.ComponentModel.DataAnnotations;

namespace MachSoft.PrivateNuGetFeed.Web.Options;

public sealed class PortalOptions
{
    public const string SectionName = "Portal";

    [Required]
    public string CompanyName { get; set; } = "MachSoft";

    [Required]
    public string PortalTitle { get; set; } = "MachSoft Private Feed";

    [Required]
    public string PortalSubtitle { get; set; } = "Repositorio interno de paquetes NuGet";

    [Required]
    public string InternalUseBadgeText { get; set; } = "Uso interno exclusivo";

    [Required]
    public string PortalVersion { get; set; } = "v1.0.0";

    [Required]
    public string FooterUsageText { get; set; } = "Herramienta interna de ingeniería para paquetes privados.";

    [Required]
    public string FeedOwnerContact { get; set; } = "platform@machsoft.local";

    public string? PublicBaseUrl { get; set; }
}
