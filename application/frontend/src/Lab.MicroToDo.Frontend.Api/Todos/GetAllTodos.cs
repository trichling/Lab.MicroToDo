using Lab.MicroToDo.Frontend.Contracts.Todos;

namespace Lab.MicroToDo.Frontend.Api.Todos;

public static class GetAllTodos
{

    public static async Task<IResult> Handle()
    {
       
        return Results.Ok(new TodoListViewModel() {
            Todos = new List<TodoViewModel>() 
            {
                new TodoViewModel() { Id = Guid.NewGuid(), Title = "Todo 1", Description = "Description 1", IsCompleted = false },
                new TodoViewModel() { Id = Guid.NewGuid(), Title = "Todo 2", Description = "Description 2", IsCompleted = false },
                new TodoViewModel() { Id = Guid.NewGuid(), Title = "Todo 3", Description = "Description 3", IsCompleted = false },
                new TodoViewModel() { Id = Guid.NewGuid(), Title = "Todo 4", Description = "Description 4", IsCompleted = false },
                new TodoViewModel() { Id = Guid.NewGuid(), Title = "Todo 5", Description = "Description 5", IsCompleted = false },
                new TodoViewModel() { Id = Guid.NewGuid(), Title = "Todo 6", Description = "Description 6", IsCompleted = false }
            }
        });

        // return Results.NoContent();
    }
}