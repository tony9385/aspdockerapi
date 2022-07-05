FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 8090
FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["aspdockerapi.csproj", "./"]
RUN dotnet restore "./aspdockerapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aspdockerapi.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "aspdockerapi.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspdockerapi.dll"]