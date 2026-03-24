using MachSoft.Template.Core.Extensions;
using TemplateRootNamespace.Components;

var builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddRazorComponents()
    .AddInteractiveServerComponents();

builder.Services.AddMachSoftTemplateCore(options =>
{
    options.ApplicationName = builder.Environment.ApplicationName;
    options.CompanyName = builder.Configuration["MachSoft:CompanyName"] ?? "TemplateCompanyName";
    options.SupportEmail = builder.Configuration["MachSoft:SupportEmail"] ?? "platform@your-company.example";
    options.DocumentationUrl = builder.Configuration["MachSoft:DocumentationUrl"] ?? "https://your-documentation-url";
});

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseAntiforgery();
app.MapRazorComponents<App>()
   .AddInteractiveServerRenderMode();

app.Run();
