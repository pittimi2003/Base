using System;
using System.Collections.Generic;
using System.Web.Mvc;
using MachSoft.PrivateNuGetFeed.Web.Models;

namespace MachSoft.PrivateNuGetFeed.Web.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            var portalSettings = PortalSettings.FromRequest(Request);
            var model = new HomeViewModel
            {
                PortalBaseUrl = portalSettings.PublicPortalUrl,
                FeedUrl = portalSettings.FeedUrl,
                PushApiKeyPlaceholder = portalSettings.PushApiKeyPlaceholder,
                PortalVersion = portalSettings.PortalVersion,
                CurrentYear = DateTime.UtcNow.Year,
                PackageRepositoryPath = portalSettings.PackageRepositoryPath,
                Notes = new[]
                {
                    "Uso interno exclusivo para distribución controlada de dependencias corporativas.",
                    "Mantén versionado semántico y notas de cambio antes de publicar nuevas versiones.",
                    "No publiques paquetes experimentales en entornos productivos sin revisión previa.",
                    "Contacta al responsable del feed si detectas paquetes corruptos, conflictos de dependencias o errores de publicación."
                },
                QuickGuide = new[]
                {
                    "Agregar el source privado con dotnet CLI o con el administrador de paquetes de Visual Studio.",
                    "Ejecutar restore o add package apuntando al source MachSoftPrivate.",
                    "Validar que la versión consumida corresponde al paquete interno esperado.",
                    "Publicar nuevas versiones con dotnet nuget push usando la API key corporativa vigente."
                },
                Commands = new[]
                {
                    new CommandSnippetViewModel("Agregar source", $"dotnet nuget add source \"{portalSettings.FeedUrl}\" --name MachSoftPrivate"),
                    new CommandSnippetViewModel("Instalar paquete", "dotnet add package MachSoft.Template.Core --source MachSoftPrivate"),
                    new CommandSnippetViewModel("Publicar paquete", $"dotnet nuget push .\\artifacts\\MachSoft.Template.Core.1.0.0.nupkg --source \"{portalSettings.FeedUrl}\" --api-key {portalSettings.PushApiKeyPlaceholder}")
                },
                FeaturedPackages = new List<PackageHighlightViewModel>
                {
                    new PackageHighlightViewModel
                    {
                        Name = "MachSoft.Template.Core",
                        Description = "Base reutilizable de layout, componentes UI y estilos corporativos para soluciones internas.",
                        Version = "1.0.0-internal",
                        InstallCommand = "dotnet add package MachSoft.Template.Core --source MachSoftPrivate"
                    },
                    new PackageHighlightViewModel
                    {
                        Name = "MachSoft.Template.Official",
                        Description = "Plantilla oficial de arranque para proyectos MachSoft con estructura y convenciones internas.",
                        Version = "1.0.0-internal",
                        InstallCommand = "dotnet add package MachSoft.Template.Official --source MachSoftPrivate"
                    },
                    new PackageHighlightViewModel
                    {
                        Name = "MachSoft.BuildingBlocks",
                        Description = "Biblioteca base para contratos compartidos, cross-cutting concerns y utilidades comunes.",
                        Version = "1.0.0-preview",
                        InstallCommand = "dotnet add package MachSoft.BuildingBlocks --source MachSoftPrivate"
                    }
                }
            };

            return View(model);
        }
    }
}
