using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace MachSoft.Template.CorePremium.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddMachSoftTemplateCorePremium(this IServiceCollection services)
    {
        services.TryAddSingleton<MachSoftPremiumRegistration>();
        return services;
    }

    public sealed class MachSoftPremiumRegistration;
}
