FROM mcr.microsoft.com/dotnet/aspnet:7.0 as base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 as build
WORKDIR /application
COPY Lab.MicroToDo.Frontend.Api/Lab.MicroToDo.Frontend.Api.csproj frontend/src/Lab.MicroToDo.Frontend.Api/
COPY Lab.MicroToDo.Frontend.Contracts/Lab.MicroToDo.Frontend.Contracts.csproj frontend/src/Lab.MicroToDo.Frontend.Contracts/

RUN dotnet restore "frontend/src/Lab.MicroToDo.Frontend.Api/Lab.MicroToDo.Frontend.Api.csproj"

COPY . frontend/src

WORKDIR "/application/frontend/src/Lab.MicroToDo.Frontend.Api"
RUN dotnet publish "Lab.MicroToDo.Frontend.Api.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Lab.MicroToDo.Frontend.Api.dll"]
