using RestEase;

namespace Lab.MicroToDo.Todos.Contracts.Todos
{
    public interface ITodosRestApi
    {
        [Get("/todos")]
        Task<TodoListViewModel> GetAllTodos();
    }
}