namespace Lab.MicroToDo.Frontend.Api.Todos
{
    public static class TodosModule 
    {
        public static IServiceCollection RegisterSerivcesForTodosModule(this IServiceCollection services, IConfiguration configuration)
        {
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
