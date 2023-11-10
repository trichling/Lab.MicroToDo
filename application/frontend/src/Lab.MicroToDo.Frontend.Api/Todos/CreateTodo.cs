using Lab.MicroToDo.Frontend.Contracts.Todos;
using Microsoft.AspNetCore.Mvc;

namespace Lab.MicroToDo.Frontend.Api.Todos;

public static class CreateTodo
{

    public static async Task<IResult> Handle(
        TodoViewModel todoViewModel, 
        [FromServices] IHttpClientFactory httpClientFactory,
        [FromServices] IConfiguration configuration)
    {
        var useTodosService = bool.TryParse(configuration["FeatureFlags:UseTodosService"], out var useTodosServiceResult) ? useTodosServiceResult : false;

        if (!useTodosService)
        {
            return Results.Ok(todoViewModel);
        }

        todoViewModel.Id = Guid.NewGuid();
        todoViewModel.IsCompleted = false;

        var httpClient = httpClientFactory.CreateClient("todos-api");
        var response = await httpClient.PostAsJsonAsync("/todos", todoViewModel);
        if (!response.IsSuccessStatusCode)
        {
            return Results.Problem(response.ReasonPhrase);
        }

        return Results.Ok(todoViewModel);
    }

}