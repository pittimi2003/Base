using MachSoft.PrivateNuGetFeed.Web.Options;
using Microsoft.Extensions.Options;

namespace MachSoft.PrivateNuGetFeed.Web.Services;

public sealed class FeedConfigurationInitializer
{
    private readonly FeedRuntimeOptions _feedOptions;
    private readonly ILogger<FeedConfigurationInitializer> _logger;
    private readonly IWebHostEnvironment _environment;

    public FeedConfigurationInitializer(
        IOptions<FeedRuntimeOptions> feedOptions,
        ILogger<FeedConfigurationInitializer> logger,
        IWebHostEnvironment environment)
    {
        _feedOptions = feedOptions.Value;
        _logger = logger;
        _environment = environment;
    }

    public void LogResolvedConfiguration()
    {
        _logger.LogInformation(
            "MachSoft Private Feed initialized in {Environment}. Package storage: {StoragePath}. Database path: {DatabasePath}.",
            _environment.EnvironmentName,
            _feedOptions.PackageStoragePath,
            _feedOptions.DatabasePath);
    }
}
