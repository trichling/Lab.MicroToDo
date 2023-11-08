using Lab.MicroToDo.Todos.Api.Todos;
using Lab.MicroToDo.Todos.Data.Todos;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.RegisterSerivcesForTodosModule(builder.Configuration);

var app = builder.Build();

Console.WriteLine($"{app.Environment.EnvironmentName}: {app.Configuration.GetConnectionString("TodosDbConnectionString")}");

using (var scope = app.Services.CreateScope())
{
    var todosContext = scope.ServiceProvider.GetRequiredService<TodosContext>();
    todosContext.Database.Migrate();
}

app.UseSwagger();
app.UseSwaggerUI();

app.MapEndpointsForTodosModule();

app.Run();
