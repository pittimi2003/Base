using MachSoft.PrivateNuGetFeed.Web.Models;
using MachSoft.PrivateNuGetFeed.Web.Services;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace MachSoft.PrivateNuGetFeed.Web.Pages;

public sealed class IndexModel : PageModel
{
    private readonly PortalContentFactory _portalContentFactory;

    public IndexModel(PortalContentFactory portalContentFactory)
    {
        _portalContentFactory = portalContentFactory;
    }

    public HomeViewModel Home { get; private set; } = default!;

    public void OnGet()
    {
        var requestBaseUrl = $"{Request.Scheme}://{Request.Host}{Request.PathBase}";
        Home = _portalContentFactory.Create(requestBaseUrl);
    }
}
