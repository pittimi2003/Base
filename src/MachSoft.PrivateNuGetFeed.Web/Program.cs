using BaGet;
using BaGet.Core;
using BaGet.Web;
using MachSoft.PrivateNuGetFeed.Web.Options;
using MachSoft.PrivateNuGetFeed.Web.Services;
using Microsoft.AspNetCore.HttpOverrides;

var builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddOptions<PortalOptions>()
    .Bind(builder.Configuration.GetSection(PortalOptions.SectionName))
    .ValidateDataAnnotations()
    .ValidateOnStart();

builder.Services
    .AddOptions<FeedRuntimeOptions>()
    .Bind(builder.Configuration.GetSection(FeedRuntimeOptions.SectionName))
    .ValidateDataAnnotations()
    .ValidateOnStart();

builder.Services.AddSingleton<FeedConfigurationInitializer>();
builder.Services.AddSingleton<PortalContentFactory>();
builder.Services.AddHttpContextAccessor();
builder.Services.AddRazorPages();

var feedSettings = builder.Configuration.GetSection(FeedRuntimeOptions.SectionName).Get<FeedRuntimeOptions>()
    ?? throw new InvalidOperationException("Feed settings are required.");

var resolvedStoragePath = ResolvePath(builder.Environment.ContentRootPath, feedSettings.PackageStoragePath);
var resolvedDatabasePath = ResolvePath(builder.Environment.ContentRootPath, feedSettings.DatabasePath);

Directory.CreateDirectory(resolvedStoragePath);
Directory.CreateDirectory(Path.GetDirectoryName(resolvedDatabasePath) ?? builder.Environment.ContentRootPath);

builder.Services.Configure<BaGetOptions>(options =>
{
    options.ApiKey = feedSettings.ApiKey;
    options.RunMigrationsAtStartup = true;
    options.AllowPackageOverwrites = false;
    options.IsReadOnlyMode = false;
    options.PackageDeletionBehavior = PackageDeletionBehavior.Unlist;
});

builder.Services.Configure<SearchOptions>(options =>
{
    options.Type = "Database";
});

builder.Services.Configure<StorageOptions>(options =>
{
    options.Type = "FileSystem";
});

builder.Services.AddBaGetWebApplication(baget =>
{
    baget.AddSqliteDatabase(options =>
    {
        options.ConnectionString = $"Data Source={resolvedDatabasePath}";
    });

    baget.AddFileStorage(options =>
    {
        options.Path = resolvedStoragePath;
    });
});

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var initializer = scope.ServiceProvider.GetRequiredService<FeedConfigurationInitializer>();
    initializer.LogResolvedConfiguration(resolvedStoragePath, resolvedDatabasePath);
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto,
    KnownNetworks = { },
    KnownProxies = { }
});

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

await app.RunMigrationsAsync();

app.MapRazorPages();
new BaGetEndpointBuilder().MapEndpoints(app);

app.Run();

static string ResolvePath(string contentRootPath, string configuredPath)
{
    if (Path.IsPathRooted(configuredPath))
    {
        return configuredPath;
    }

    return Path.GetFullPath(Path.Combine(contentRootPath, configuredPath));
}
