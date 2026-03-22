using System.Diagnostics;
using MachSoft.PrivateNuGetFeed.Web.Models;
using MachSoft.PrivateNuGetFeed.Web.Services;
using Microsoft.AspNetCore.Mvc;

namespace MachSoft.PrivateNuGetFeed.Web.Controllers;

public sealed class HomeController : Controller
{
    private readonly PortalContentFactory _portalContentFactory;

    public HomeController(PortalContentFactory portalContentFactory)
    {
        _portalContentFactory = portalContentFactory;
    }

    [HttpGet("/")]
    public IActionResult Index()
    {
        var requestBaseUrl = $"{Request.Scheme}://{Request.Host}{Request.PathBase}";
        var model = _portalContentFactory.Create(requestBaseUrl);
        return View(model);
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel
        {
            RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier
        });
    }
}
