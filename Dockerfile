# Stage 1: Runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base

WORKDIR /app

EXPOSE 8080

ENV ASPNETCORE_HTTP_PORTS=8080


# Stage 2: Build environment
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

COPY ["MyFirstAPI.csproj", "./"]

RUN dotnet restore "MyFirstAPI.csproj"

COPY . .

RUN dotnet publish "MyFirstAPI.csproj" \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false


# Stage 3: Final runtime image
FROM base AS final

WORKDIR /app

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "MyFirstAPI.dll"]
