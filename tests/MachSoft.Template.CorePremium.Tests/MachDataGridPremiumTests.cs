using Bunit;
using MachSoft.Template.Core.Models;
using MachSoft.Template.CorePremium.Components.Data;
using Xunit;

namespace MachSoft.Template.CorePremium.Tests;

public sealed class MachDataGridPremiumTests : TestContext
{
    [Fact]
    public void Renders_Columns_And_Rows()
    {
        var items = new[] { new Row("SO-1", "Ready") };
        var columns = new[]
        {
            new MxDataGridColumn<Row>("Order", x => x.OrderId),
            new MxDataGridColumn<Row>("Status", x => x.Status)
        };

        var cut = RenderComponent<MachDataGridPremium<Row>>(parameters => parameters
            .Add(x => x.Items, items)
            .Add(x => x.Columns, columns)
            .Add(x => x.Title, "Grid"));

        Assert.Contains("SO-1", cut.Markup);
        Assert.Contains("Status", cut.Markup);
    }

    private sealed record Row(string OrderId, string Status);
}
