FROM mcr.microsoft.com/dotnet/aspnet:8.0 as base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
WORKDIR /application/todos/src
COPY Lab.MicroToDo.Todos.Api/Lab.MicroToDo.Todos.Api.csproj Lab.MicroToDo.Todos.Api/
COPY Lab.MicroToDo.Todos.Contracts/Lab.MicroToDo.Todos.Contracts.csproj Lab.MicroToDo.Todos.Contracts/
COPY Lab.MicroToDo.Todos.Data/Lab.MicroToDo.Todos.Data.csproj Lab.MicroToDo.Todos.Data/

RUN dotnet restore "Lab.MicroToDo.Todos.Api/Lab.MicroToDo.Todos.Api.csproj"

COPY . .

WORKDIR /application/todos/src/Lab.MicroToDo.Todos.Api
RUN dotnet publish "Lab.MicroToDo.Todos.Api.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Lab.MicroToDo.Todos.Api.dll"]
