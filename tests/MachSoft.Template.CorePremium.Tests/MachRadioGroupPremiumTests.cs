using Bunit;
using MachSoft.Template.CorePremium.Components.Forms;
using MachSoft.Template.CorePremium.Models;
using Xunit;

namespace MachSoft.Template.CorePremium.Tests;

public sealed class MachRadioGroupPremiumTests : TestContext
{
    [Fact]
    public void Emits_ValueChanged_When_Option_Changes()
    {
        string? changed = null;
        var options = new[]
        {
            new MachRadioOptionPremium("a", "A"),
            new MachRadioOptionPremium("b", "B")
        };

        var cut = RenderComponent<MachRadioGroupPremium>(parameters => parameters
            .Add(x => x.Label, "Modo")
            .Add(x => x.Options, options)
            .Add(x => x.Value, "a")
            .Add(x => x.ValueChanged, value => changed = value));

        cut.Find("input[value='b']").Change("b");

        Assert.Equal("b", changed);
    }
}
