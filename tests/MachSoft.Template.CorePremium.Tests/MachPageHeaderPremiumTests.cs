using Bunit;
using MachSoft.Template.CorePremium.Components.Layout;
using Xunit;

namespace MachSoft.Template.CorePremium.Tests;

public sealed class MachPageHeaderPremiumTests : TestContext
{
    [Fact]
    public void Renders_Title_Subtitle_And_Metadata()
    {
        var cut = RenderComponent<MachPageHeaderPremium>(parameters => parameters
            .Add(x => x.Title, "Premium Header")
            .Add(x => x.Subtitle, "Enterprise subtitle")
            .Add(x => x.Metadata, builder => builder.AddMarkupContent(0, "<span data-test='meta'>Meta</span>")));

        Assert.Contains("Premium Header", cut.Markup);
        Assert.Contains("Enterprise subtitle", cut.Markup);
        cut.Find("[data-test='meta']");
    }
}
