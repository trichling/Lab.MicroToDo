using Lab.MicroToDo.Frontend.Contracts.Todos;

namespace Lab.MicroToDo.Frontend.Api.Todos;

public static class CreateTodo
{

    public static async Task<IResult> Handle(TodoViewModel todoViewModel)
    {
        todoViewModel.Id = Guid.NewGuid();
        todoViewModel.IsCompleted = false;

        return Results.Ok(todoViewModel);
    }

}