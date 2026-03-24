using MachSoft.Template.Core.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace MachSoft.Template.Core.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddMachSoftTemplateCore(
        this IServiceCollection services,
        Action<MachSoftTemplateOptions>? configure = null)
    {
        services.AddOptions<MachSoftTemplateOptions>();

        if (configure is not null)
        {
            services.Configure(configure);
        }

        services.TryAddSingleton<MachSoftThemeRegistration>();
        return services;
    }

    public sealed class MachSoftThemeRegistration;
}
