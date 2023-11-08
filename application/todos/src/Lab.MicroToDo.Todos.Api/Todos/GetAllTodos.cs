using Lab.MicroToDo.Todos.Contracts.Todos;
using Lab.MicroToDo.Todos.Data.Todos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Lab.MicroToDo.Todos.Api.Todos;

public static class GetAllTodos
{
    public static async Task<IResult> Handle(TodosContext context)
    {
        var todos = await context.Todos.ToListAsync();

        var viewModel = new TodoListViewModel
        {
            Todos = todos.Select(todo => new TodoViewModel
            {
                Id = todo.Id,
                Title = todo.Title,
                Description = todo.Description,
                IsCompleted = todo.IsCompleted
            }).ToList()
        };

        return Results.Ok(viewModel);
    }
}