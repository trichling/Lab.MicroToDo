using Lab.MicroToDo.Todos.Data.Todos;
using Microsoft.EntityFrameworkCore;

namespace Lab.MicroToDo.Todos.Api.Todos;

public static class TodosModule 
{
    public static IServiceCollection RegisterSerivcesForTodosModule(this IServiceCollection services, IConfiguration configuration)
    {
        var todosDbConnectionString = configuration.GetConnectionString("TodosDbConnectionString");
        todosDbConnectionString = string.Format(todosDbConnectionString, "todosDb");
        services.AddDbContext<TodosContext>(options =>
        {
            options.UseSqlServer(todosDbConnectionString);
        });
        return services;
    }

    public static IEndpointRouteBuilder MapEndpointsForTodosModule(this IEndpointRouteBuilder endpoints)
    {
        endpoints.MapGet("/todos", GetAllTodos.Handle);
        endpoints.MapPost("/todos", CreateTodo.Handle);
        
        return endpoints;
    }
}
