namespace Lab.MicroToDo.Frontend.Api.Infrastructure;

public static class HttpClientExtensions
{
    public static IServiceCollection AddHttpClientWithBaseUrl(this IServiceCollection services, string name, string baseUri) 
{
        services.AddHttpClient(name)
            .ConfigurePrimaryHttpMessageHandler(p => 
            {
                var handler = new HttpClientHandler
                {
                    ServerCertificateCustomValidationCallback = (httpRequestMessage, cert, cetChain, policyErrors) => true
                };
                handler.ClientCertificateOptions = ClientCertificateOption.Manual;

                return handler;
            })
            .ConfigureHttpClient((_, client) => 
            {
                client.BaseAddress = new Uri(baseUri);
            });


        return services;
    }
}
 