FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled as base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
ARG CONFIG
# Install remote debugger
RUN wget https://aka.ms/getvsdbgsh -O - 2>/dev/null | /bin/sh /dev/stdin -v latest -l ~/vsdbg
RUN apt-get update && apt-get -y install procps

WORKDIR /application/frontend/src
COPY Lab.MicroToDo.Frontend.Api/Lab.MicroToDo.Frontend.Api.csproj Lab.MicroToDo.Frontend.Api/
COPY Lab.MicroToDo.Frontend.Contracts/Lab.MicroToDo.Frontend.Contracts.csproj Lab.MicroToDo.Frontend.Contracts/

RUN dotnet restore "Lab.MicroToDo.Frontend.Api/Lab.MicroToDo.Frontend.Api.csproj"

COPY . .

# target this image for development builds (including remote debugger)
FROM build AS publish
WORKDIR /application/frontend/src/Lab.MicroToDo.Frontend.Api
RUN dotnet publish "Lab.MicroToDo.Frontend.Api.csproj" -c  ${CONFIG} -o /app/publish
WORKDIR /app/publish
ENTRYPOINT ["dotnet", "Lab.MicroToDo.Frontend.Api.dll"]

# target this image for production builds (without remote debugger)
FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Lab.MicroToDo.Frontend.Api.dll"]
