using MachSoft.PrivateNuGetFeed.Web.Models;
using MachSoft.PrivateNuGetFeed.Web.Options;
using Microsoft.Extensions.Options;

namespace MachSoft.PrivateNuGetFeed.Web.Services;

public sealed class PortalContentFactory
{
    private const string ServiceIndexPath = "/v3/index.json";
    private const string PackagePublishPath = "/api/v2/package";
    private const string SearchPath = "/v3/search";
    private const string RegistrationPath = "/v3/registration";

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
            HeroDescription = "Repositorio interno de paquetes NuGet para publicar y consumir artefactos de ingeniería con control operativo, endpoints estándar y una experiencia web corporativa desacoplada del feed técnico.",
            InternalUseBadgeText = _portalOptions.InternalUseBadgeText,
            PortalVersion = _portalOptions.PortalVersion,
            FooterUsageText = _portalOptions.FooterUsageText,
            FeedOwnerContact = _portalOptions.FeedOwnerContact,
            CurrentYear = DateTime.UtcNow.Year,
            PortalBaseUrl = publicBaseUrl,
            ServiceIndexUrl = serviceIndexUrl,
            PackagePublishUrl = publishUrl,
            SourceName = _feedOptions.SourceName,
            StorageSummary = $"Paquetes: {_feedOptions.PackageStoragePath} · Metadatos: {_feedOptions.DatabasePath}",
            ConsumeCommands =
            [
                new CommandSnippetViewModel
                {
                    Label = "Agregar source privado",
                    Command = $"dotnet nuget add source \"{serviceIndexUrl}\" --name {_feedOptions.SourceName}",
                    Description = "Registra el service index v3 del feed privado usando la ruta pública compatible con clientes NuGet modernos."
                },
                new CommandSnippetViewModel
                {
                    Label = "Restaurar desde el feed",
                    Command = $"dotnet restore --source \"{serviceIndexUrl}\"",
                    Description = "Verifica conectividad y resolución de metadatos antes de instalar o actualizar dependencias."
                },
                new CommandSnippetViewModel
                {
                    Label = "Instalar un paquete corporativo",
                    Command = $"dotnet add package MachSoft.Template.Core --source \"{serviceIndexUrl}\"",
                    Description = "Instala el paquete objetivo usando la URL del feed para una resolución determinista y fácil de automatizar."
                }
            ],
            PublishCommands =
            [
                new CommandSnippetViewModel
                {
                    Label = "Publicar paquete .nupkg",
                    Command = $"dotnet nuget push .\\artifacts\\MachSoft.Template.Core.1.0.0.nupkg --source \"{serviceIndexUrl}\" --api-key {_feedOptions.ApiKey}",
                    Description = "El source v3 conduce al endpoint real de push de BaGet y exige API key configurable como seguridad mínima sensible."
                }
            ],
            FeaturedPackages =
            [
                new FeaturedPackageViewModel
                {
                    Name = "MachSoft.Template.Core",
                    Description = "Base compartida de UI, estilos y contratos reutilizables para soluciones internas sobre .NET moderno.",
                    Version = "1.0.0",
                    InstallCommand = $"dotnet add package MachSoft.Template.Core --source \"{serviceIndexUrl}\""
                },
                new FeaturedPackageViewModel
                {
                    Name = "MachSoft.Template.Official",
                    Description = "Starter corporativo con convenciones oficiales para acelerar nuevos productos internos.",
                    Version = "1.2.0",
                    InstallCommand = $"dotnet add package MachSoft.Template.Official --source \"{serviceIndexUrl}\""
                },
                new FeaturedPackageViewModel
                {
                    Name = "MachSoft.BuildingBlocks",
                    Description = "Conjunto interno de building blocks transversales para observabilidad, configuración y utilidades comunes.",
                    Version = "2.4.1",
                    InstallCommand = $"dotnet add package MachSoft.BuildingBlocks --source \"{serviceIndexUrl}\""
                }
            ],
            QuickGuideSteps =
            [
                new QuickGuideStepViewModel
                {
                    Number = "01",
                    Title = "Agregar source",
                    Detail = "Registrar la URL v3 pública del feed privado en la máquina del desarrollador o en el pipeline de CI."
                },
                new QuickGuideStepViewModel
                {
                    Number = "02",
                    Title = "Restaurar",
                    Detail = "Ejecutar restore para confirmar que el portal no interfiere con los endpoints técnicos del feed."
                },
                new QuickGuideStepViewModel
                {
                    Number = "03",
                    Title = "Instalar paquete",
                    Detail = "Consumir el paquete requerido desde la URL del feed o un source ya registrado en la configuración del entorno."
                },
                new QuickGuideStepViewModel
                {
                    Number = "04",
                    Title = "Publicar nuevas versiones",
                    Detail = "Empaquetar el artefacto, aplicar versionado semántico y hacer push con API key en el endpoint real del feed."
                }
            ],
            RouteSummaries =
            [
                new CommandSnippetViewModel
                {
                    Label = "Portal humano",
                    Command = "/",
                    Description = "Home corporativa con branding MachSoft, comandos útiles y orientación operativa para el equipo."
                },
                new CommandSnippetViewModel
                {
                    Label = "Feed v3",
                    Command = ServiceIndexPath,
                    Description = "Service index JSON compatible con dotnet CLI, Visual Studio y nuget.exe."
                },
                new CommandSnippetViewModel
                {
                    Label = "Push de paquetes",
                    Command = PackagePublishPath,
                    Description = "Endpoint de publicación resuelto por BaGet a través del source v3 y protegido por API key."
                },
                new CommandSnippetViewModel
                {
                    Label = "Búsqueda y registro",
                    Command = $"{SearchPath} · {RegistrationPath}",
                    Description = "Endpoints de soporte para descubrimiento y metadatos del feed NuGet."
                }
            ],
            ConfigurationHighlights =
            [
                $"Portal__PublicBaseUrl = {publicBaseUrl}",
                $"Feed__SourceName = {_feedOptions.SourceName}",
                "Feed__ApiKey debe definirse en App Settings o mediante Key Vault references, nunca como secreto real en el repositorio.",
                $"Feed__PackageStoragePath = {_feedOptions.PackageStoragePath}",
                $"Feed__DatabasePath = {_feedOptions.DatabasePath}"
            ],
            InternalNotes =
            [
                "Uso interno exclusivo.",
                "Mantener versionado semántico y changelog por paquete.",
                "No publicar paquetes experimentales en producción.",
                $"Contactar al responsable del feed en caso de incidencias: {_portalOptions.FeedOwnerContact}."
            ]
        };
    }
}
