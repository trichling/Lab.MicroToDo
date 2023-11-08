using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace Lab.MicroToDo.Todos.Data.Todos
{
    public class TodosContextFactory : IDesignTimeDbContextFactory<TodosContext>
    {
        public TodosContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<TodosContext>();
            optionsBuilder.UseSqlServer(args[0]);

            return new TodosContext(optionsBuilder.Options);
        }
    }
}