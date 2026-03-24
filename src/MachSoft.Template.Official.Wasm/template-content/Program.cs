using MachSoft.Template.Core.Extensions;
using TemplateRootNamespace;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;

var builder = WebAssemblyHostBuilder.CreateDefault(args);

builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

builder.Services.AddScoped(_ => new HttpClient
{
    BaseAddress = new Uri(builder.HostEnvironment.BaseAddress)
});

builder.Services.AddMachSoftTemplateCore(options =>
{
    options.ApplicationName = typeof(App).Assembly.GetName().Name ?? "TemplateRootNamespace";
    options.CompanyName = builder.Configuration["MachSoft:CompanyName"] ?? "TemplateCompanyName";
    options.SupportEmail = builder.Configuration["MachSoft:SupportEmail"] ?? "platform@your-company.example";
    options.DocumentationUrl = builder.Configuration["MachSoft:DocumentationUrl"] ?? "https://your-documentation-url";
});

await builder.Build().RunAsync();
