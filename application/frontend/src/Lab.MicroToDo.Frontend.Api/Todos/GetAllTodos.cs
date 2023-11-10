using Lab.MicroToDo.Frontend.Contracts.Todos;
using Microsoft.AspNetCore.Mvc;

namespace Lab.MicroToDo.Frontend.Api.Todos;

public static class GetAllTodos
{

    public static async Task<IResult> Handle(
        [FromServices] IConfiguration configuration, 
        [FromServices] IHttpClientFactory httpClientFactory)
    {
        var useTodosService = bool.TryParse(configuration["FeatureFlags:UseTodosService"], out var useTodosServiceResult) ? useTodosServiceResult : false;

        if (!useTodosService)
        {
            // return fake data
            var fakeTodos = new TodoListViewModel
            {
                Todos = new List<TodoViewModel>
                {
                    new TodoViewModel
                    {
                        Id = Guid.NewGuid(),
                        Title = "Todo 1",
                        Description = "Description 1",
                        IsCompleted = false
                    },
                    new TodoViewModel
                    {
                        Id = Guid.NewGuid(),
                        Title = "Todo 2",
                        Description = "Description 2",
                        IsCompleted = false
                    },
                    new TodoViewModel
                    {
                        Id = Guid.NewGuid(),
                        Title = "Todo 3",
                        Description = "Description 3",
                        IsCompleted = false
                    }
                }
            };

            return Results.Ok(fakeTodos);
        }

        var httpClient = httpClientFactory.CreateClient("todos-api");
        var response = await httpClient.GetAsync("/todos");
        if (!response.IsSuccessStatusCode)
        {
            return Results.Problem(response.ReasonPhrase);
        }

        var todos = await response.Content.ReadFromJsonAsync<TodoListViewModel>();
        return Results.Ok(todos);
       
    }
}