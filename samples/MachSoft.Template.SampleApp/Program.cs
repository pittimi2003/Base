using MachSoft.Template.Core.Extensions;
using MachSoft.Template.CorePremium.Extensions;

var builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddRazorComponents()
    .AddInteractiveServerComponents();

builder.Services
    .AddMachSoftTemplateCore(options =>
    {
        options.ApplicationName = "MachSoft SampleApp";
        options.CompanyName = "MachSoft";
    })
    .AddMachSoftTemplateCorePremium();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<MachSoft.Template.SampleApp.Components.App>()
    .AddInteractiveServerRenderMode();

app.Run();
