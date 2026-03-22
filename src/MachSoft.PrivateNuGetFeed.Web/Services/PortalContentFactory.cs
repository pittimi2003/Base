using MachSoft.PrivateNuGetFeed.Web.Models;
using MachSoft.PrivateNuGetFeed.Web.Options;
using Microsoft.Extensions.Options;

namespace MachSoft.PrivateNuGetFeed.Web.Services;

public sealed class PortalContentFactory
{
    private const string ServiceIndexPath = "/v3/index.json";
    private const string PackagePublishPath = "/api/v2/package";

    private readonly PortalOptions _portalOptions;
    private readonly FeedRuntimeOptions _feedOptions;

    public PortalContentFactory(IOptions<PortalOptions> portalOptions, IOptions<FeedRuntimeOptions> feedOptions)
    {
        _portalOptions = portalOptions.Value;
        _feedOptions = feedOptions.Value;
    }

    public HomeViewModel Create(string requestBaseUrl)
    {
        var publicBaseUrl = string.IsNullOrWhiteSpace(_portalOptions.PublicBaseUrl)
            ? requestBaseUrl.TrimEnd('/')
            : _portalOptions.PublicBaseUrl!.TrimEnd('/');

        var serviceIndexUrl = $"{publicBaseUrl}{ServiceIndexPath}";
        var publishUrl = $"{publicBaseUrl}{PackagePublishPath}";

        return new HomeViewModel
        {
            CompanyName = _portalOptions.CompanyName,
            PortalTitle = _portalOptions.PortalTitle,
            PortalSubtitle = _portalOptions.PortalSubtitle,
            HeroDescription = "Portal operativo para consumir y publicar paquetes internos con endpoints NuGet reales, configuración auditable y separación clara entre experiencia humana y feed técnico.",
            InternalUseBadgeText = _portalOptions.InternalUseBadgeText,
            PortalVersion = _portalOptions.PortalVersion,
            FooterUsageText = _portalOptions.FooterUsageText,
            FeedOwnerContact = _portalOptions.FeedOwnerContact,
            CurrentYear = DateTime.UtcNow.Year,
            PortalBaseUrl = publicBaseUrl,
            ServiceIndexUrl = serviceIndexUrl,
            PackagePublishUrl = publishUrl,
            ConsumeCommands =
            [
                new CommandSnippetViewModel
                {
                    Label = "Registrar source privado",
                    Command = $"dotnet nuget add source \"{serviceIndexUrl}\" --name {_feedOptions.SourceName}",
                    Description = "Agrega el feed privado v3 para dotnet CLI, Visual Studio y herramientas compatibles con NuGet."
                },
                new CommandSnippetViewModel
                {
                    Label = "Instalar paquete desde el feed",
                    Command = $"dotnet add package MachSoft.Template.Core --source {_feedOptions.SourceName}",
                    Description = "Consume un paquete corporativo usando el source registrado, sin mezclarlo con feeds públicos."
                }
            ],
            PublishCommands =
            [
                new CommandSnippetViewModel
                {
                    Label = "Publicar paquete .nupkg",
                    Command = $"dotnet nuget push .\\artifacts\\MachSoft.Template.Core.1.0.0.nupkg --source \"{serviceIndexUrl}\" --api-key {_feedOptions.ApiKey}",
                    Description = "Empuja versiones internas usando la API key configurable desde appsettings o Azure App Settings."
                }
            ],
            FeaturedPackages =
            [
                new FeaturedPackageViewModel
                {
                    Name = "MachSoft.Template.Core",
                    Description = "Foundation UI, layout y estilos compartidos para soluciones corporativas Blazor y ASP.NET Core.",
                    Version = "1.0.0",
                    InstallCommand = $"dotnet add package MachSoft.Template.Core --source {_feedOptions.SourceName}"
                },
                new FeaturedPackageViewModel
                {
                    Name = "MachSoft.Template.Official",
                    Description = "Starter corporativo con convenciones oficiales, bootstrap y assets estandarizados por MachSoft.",
                    Version = "1.2.0",
                    InstallCommand = $"dotnet add package MachSoft.Template.Official --source {_feedOptions.SourceName}"
                },
                new FeaturedPackageViewModel
                {
                    Name = "MachSoft.BuildingBlocks",
                    Description = "Biblioteca interna de building blocks transversales para telemetría, configuración y utilidades comunes.",
                    Version = "2.4.1",
                    InstallCommand = $"dotnet add package MachSoft.BuildingBlocks --source {_feedOptions.SourceName}"
                }
            ],
            QuickGuideSteps =
            [
                new QuickGuideStepViewModel
                {
                    Number = "01",
                    Title = "Agregar source",
                    Detail = "Registrar el service index v3 del feed privado en la máquina o pipeline consumidor."
                },
                new QuickGuideStepViewModel
                {
                    Number = "02",
                    Title = "Restaurar",
                    Detail = "Ejecutar restore para comprobar conectividad con el feed antes de instalar o actualizar dependencias."
                },
                new QuickGuideStepViewModel
                {
                    Number = "03",
                    Title = "Instalar paquete",
                    Detail = "Consumir el paquete requerido indicando el source privado o usando el nombre ya registrado."
                },
                new QuickGuideStepViewModel
                {
                    Number = "04",
                    Title = "Publicar versión",
                    Detail = "Generar el .nupkg, aplicar versionado semántico y hacer push con API key desde una ubicación autorizada."
                }
            ],
            InternalNotes =
            [
                "Uso interno exclusivo de MachSoft.",
                "Mantener versionado semántico y changelog por paquete.",
                "No publicar paquetes experimentales en entornos de producción.",
                $"Contactar al responsable del feed en caso de incidencias: {_portalOptions.FeedOwnerContact}."
            ]
        };
    }
}
