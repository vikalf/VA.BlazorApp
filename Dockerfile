#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["src/VA.BlazorApp/VA.BlazorApp.csproj", "src/VA.BlazorApp/"]
RUN dotnet restore "src/VA.BlazorApp/VA.BlazorApp.csproj"
COPY . .
WORKDIR "/src/src/VA.BlazorApp"
RUN dotnet build "VA.BlazorApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "VA.BlazorApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "VA.BlazorApp.dll"]