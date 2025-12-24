FROM mcr.microsoft.com/dotnet/aspnet:10.0-noble AS base

# Install TGT and required packages for iSCSI target functionality
RUN apt-get update && apt-get install -y \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Use the .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# Set the working directory
WORKDIR /src

# Copy the project file and restore
COPY SqliteAotTest/SqliteAotTest.csproj SqliteAotTest/
RUN dotnet restore SqliteAotTest/SqliteAotTest.csproj

# Copy the rest of the application code
COPY SqliteAotTest/ SqliteAotTest/

# Build and publish the application with AOT
WORKDIR /src/SqliteAotTest
RUN dotnet publish -c Release -o /app/publish /p:PublishAot=true /p:DebugType=None





# Use a minimal runtime image
FROM base AS final

# Set the working directory
WORKDIR /app

# Copy the published application
COPY --from=build /app/publish .

# Add scripts
COPY scripts/ ./scripts/
# Fix line endings and make scripts executable
RUN dos2unix ./scripts/*.sh && chmod +x ./scripts/*.sh
# Set the entrypoint
ENTRYPOINT ["./scripts/entrypoint.sh"]
