using Bunit;
using MachSoft.Template.CorePremium.Components.Overlays;
using Xunit;

namespace MachSoft.Template.CorePremium.Tests;

public sealed class MachDialogPremiumTests : TestContext
{
    [Fact]
    public void Renders_Dialog_Semantics_When_Open()
    {
        var cut = RenderComponent<MachDialogPremium>(parameters => parameters
            .Add(x => x.Open, true)
            .Add(x => x.Title, "Config")
            .AddChildContent("<p>Body</p>"));

        var dialog = cut.Find("section[role='dialog']");
        Assert.Equal("true", dialog.GetAttribute("aria-modal"));
    }
}
