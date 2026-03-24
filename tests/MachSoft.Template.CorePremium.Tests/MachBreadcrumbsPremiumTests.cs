using Bunit;
using MachSoft.Template.Core.Models;
using MachSoft.Template.CorePremium.Components.Navigation;
using Xunit;

namespace MachSoft.Template.CorePremium.Tests;

public sealed class MachBreadcrumbsPremiumTests : TestContext
{
    [Fact]
    public void Renders_Breadcrumb_Items_And_EndContent()
    {
        var items = new[]
        {
            new MxBreadcrumbItem("Inicio", "/"),
            new MxBreadcrumbItem("Premium", "/premium-showcase", true)
        };

        var cut = RenderComponent<MachBreadcrumbsPremium>(parameters => parameters
            .Add(x => x.Items, items)
            .Add(x => x.EndContent, builder => builder.AddMarkupContent(0, "<span data-test='end'>ok</span>")));

        Assert.Contains("Inicio", cut.Markup);
        cut.Find("[data-test='end']");
    }
}
