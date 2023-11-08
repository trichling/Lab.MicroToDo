using Lab.MicroToDo.Frontend.Api.Infrastructure;

namespace Lab.MicroToDo.Frontend.Api.Todos
{
    public static class TodosModule 
    {
        public static IServiceCollection RegisterSerivcesForTodosModule(this IServiceCollection services, IConfiguration configuration)
        {
            var todosApiBaseUrl = configuration["Dependencies:APIs:TodosApiBaseUrl"];
            services.AddHttpClientWithBaseUrl("todos-api", todosApiBaseUrl);
            
            return services;
        }

        public static IEndpointRouteBuilder MapEndpointsForTodosModule(this IEndpointRouteBuilder endpoints)
        {
            endpoints.MapGet("/todos", GetAllTodos.Handle);
            endpoints.MapPost("/todos", CreateTodo.Handle);
            
            return endpoints;
        }
    }
}
