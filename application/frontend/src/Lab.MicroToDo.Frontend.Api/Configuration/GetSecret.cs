using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

namespace Lab.MicroToDo.Frontend.Api.Configuration;

public static class GetSecret
{

    public static async Task<IResult> Handle()
    {
        string keyVaultUrl = Environment.GetEnvironmentVariable("KEYVAULT_URL");
        string secretName = "microtodo-todos-api-somesecret";

        var client = new SecretClient(
            new Uri(keyVaultUrl),
            new DefaultAzureCredential());

        var secret = await client.GetSecretAsync(secretName);

        return Results.Ok(secret);
    }

}