FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
FROM mcr.microsoft.com/dotnet/sdk:6.0  AS build
WORKDIR /src
COPY ["RemitWeb.csproj","RemitWeb/"]
RUN dotnet restore "RemitWeb/RemitWeb.csproj"
COPY . "RemitWeb/"
WORKDIR "/src/RemitWeb"
RUN dotnet build "RemitWeb.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "RemitWeb.csproj" -c Release -o /app/publish /p:UseAppHost=false
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","RemitWeb.dll"]