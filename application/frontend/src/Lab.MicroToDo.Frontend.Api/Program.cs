using Lab.MicroToDo.Frontend.Api.Configuration;
using Lab.MicroToDo.Frontend.Api.Todos;
using Microsoft.OpenApi.Models;



var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

// Register Modules
builder.Services.RegisterSerivcesForTodosModule(builder.Configuration);
builder.Services.RegisterSerivcesForConfigurationModule(builder.Configuration);

var app = builder.Build();

app.UseSwagger(c => {
            // Use this to add a server node that allows to call this correctly when being behind a reverse proxe
    c.PreSerializeFilters.Add((swagger, _) => {
        swagger.Servers.Add(new OpenApiServer() {
            Description = "Hosted environment",
            Url = "/api"
        });
        swagger.Servers.Add(new OpenApiServer() {
            Description = "Local environment",
            Url = "/"
        });
    });
});

app.UseSwaggerUI();

app.UseCors("AllowAll");

app.MapEndpointsForTodosModule();
app.MapEndpointsForConfigurationModule();

app.Run();
