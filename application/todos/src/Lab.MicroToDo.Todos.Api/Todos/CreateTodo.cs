using Lab.MicroToDo.Todos.Contracts.Todos;
using Lab.MicroToDo.Todos.Data.Todos;
using Microsoft.AspNetCore.Mvc;

namespace Lab.MicroToDo.Todos.Api.Todos;

public static class CreateTodo
{

    public static async Task<IResult> Handle(TodoViewModel todoViewModel, [FromServices]TodosContext todosContext)
    {
        todoViewModel.Id = Guid.NewGuid();
        todoViewModel.IsCompleted = false;

        var todo = new TodoData
        {
            Id = todoViewModel.Id,
            Title = todoViewModel.Title,
            Description = todoViewModel.Description,
            IsCompleted = todoViewModel.IsCompleted
        };

        await todosContext.Todos.AddAsync(todo);
        await todosContext.SaveChangesAsync();

        return Results.Ok(todoViewModel);
    }

}