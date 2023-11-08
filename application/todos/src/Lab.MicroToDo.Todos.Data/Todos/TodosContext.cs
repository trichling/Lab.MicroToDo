using Microsoft.EntityFrameworkCore;

namespace Lab.MicroToDo.Todos.Data.Todos
{
    public class TodosContext : DbContext
    {
        public TodosContext(DbContextOptions<TodosContext> options) : base(options)
        {
        }

        public DbSet<TodoData> Todos { get; set; } = null!;
    }
}