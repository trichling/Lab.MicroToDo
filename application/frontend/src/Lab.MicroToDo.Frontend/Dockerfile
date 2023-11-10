FROM mcr.microsoft.com/dotnet/sdk:7.0 as build
WORKDIR /application

COPY Lab.MicroToDo.Frontend/Lab.MicroToDo.Frontend.csproj frontend/src/Lab.MicroToDo.Frontend/
COPY Lab.MicroToDo.Frontend.Contracts/Lab.MicroToDo.Frontend.Contracts.csproj frontend/src/Lab.MicroToDo.Frontend.Contracts/

RUN dotnet restore "frontend/src/Lab.MicroToDo.Frontend/Lab.MicroToDo.Frontend.csproj"

COPY . frontend/src

WORKDIR "/application/frontend/src/Lab.MicroToDo.Frontend"
RUN dotnet publish "Lab.MicroToDo.Frontend.csproj" -c Release -o /app/publish

FROM nginx:alpine as final
COPY --from=build /app/publish /usr/share/nginx/html
COPY Lab.MicroToDo.Frontend/nginx.conf.template /etc/nginx/nginx.conf.template
COPY Lab.MicroToDo.Frontend/entrypoint.sh /docker-entrypoint.d/40-replace-env-vars.sh
CMD ["nginx", "-g", "daemon off;"]
