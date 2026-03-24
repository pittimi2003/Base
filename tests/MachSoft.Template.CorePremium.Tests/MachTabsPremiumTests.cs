using Bunit;
using MachSoft.Template.CorePremium.Components.Navigation;
using MachSoft.Template.CorePremium.Models;
using Xunit;

namespace MachSoft.Template.CorePremium.Tests;

public sealed class MachTabsPremiumTests : TestContext
{
    [Fact]
    public void Emits_ActiveValueChanged_On_Click()
    {
        var changed = string.Empty;
        var items = new[]
        {
            new MachTabsPremiumItem("a", "A"),
            new MachTabsPremiumItem("b", "B")
        };

        var cut = RenderComponent<MachTabsPremium>(parameters => parameters
            .Add(x => x.Items, items)
            .Add(x => x.ActiveValue, "a")
            .Add(x => x.ActiveValueChanged, v => changed = v)
            .Add(x => x.ActiveTemplate, item => builder => builder.AddContent(0, item.Text)));

        cut.FindAll("button")[1].Click();

        Assert.Equal("b", changed);
    }
}
