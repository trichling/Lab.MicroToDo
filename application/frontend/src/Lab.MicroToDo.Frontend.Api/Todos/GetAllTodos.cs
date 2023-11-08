using Lab.MicroToDo.Frontend.Contracts.Todos;
using Microsoft.AspNetCore.Mvc;

namespace Lab.MicroToDo.Frontend.Api.Todos;

public static class GetAllTodos
{

    public static async Task<IResult> Handle([FromServices] IHttpClientFactory httpClientFactory)
    {
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