FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ./
RUN dotnet restore 
COPY . .
WORKDIR "/src/."
RUN dotnet build "RemitWeb.csproj" -c Release -o out

FROM build AS publish
RUN dotnet publish "RemitWeb.csproj" -c Release -o out

FROM base AS final
WORKDIR /app
COPY --from=publish
ENTRYPOINT ["dotnet", "RemitWeb.dll"]
