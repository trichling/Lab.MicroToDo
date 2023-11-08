using Lab.MicroToDo.Frontend.Contracts.Todos;
using Microsoft.AspNetCore.Mvc;

namespace Lab.MicroToDo.Frontend.Api.Todos;

public static class CreateTodo
{

    public static async Task<IResult> Handle(TodoViewModel todoViewModel, [FromServices] IHttpClientFactory httpClientFactory)
    {
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