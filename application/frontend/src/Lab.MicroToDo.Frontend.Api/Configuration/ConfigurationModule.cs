namespace Lab.MicroToDo.Frontend.Api.Configuration;

public static class ConfigurationModule
{
    public static IServiceCollection RegisterSerivcesForConfigurationModule(this IServiceCollection services, IConfiguration configuration)
    {
        return services;
    }

    public static IEndpointRouteBuilder MapEndpointsForConfigurationModule(this IEndpointRouteBuilder endpoints)
    {
        endpoints.MapGet("/configuration", GetSecret.Handle);
        
        return endpoints;
    }
}