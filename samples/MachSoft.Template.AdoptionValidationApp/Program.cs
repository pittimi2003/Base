var builder = WebApplication.CreateBuilder(args);

builder.Services.AddRazorComponents().AddInteractiveServerComponents();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<global::MachSoft.Template.AdoptionValidationApp.Components.App>()
    .AddAdditionalAssemblies(typeof(MachSoft.Template.Core.Pages.Home).Assembly)
    .AddInteractiveServerRenderMode();

app.Run();
