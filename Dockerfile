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
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0

# Set the working directory
WORKDIR /app

# Copy the published application
COPY --from=build /app/publish .

# Set the entrypoint
ENTRYPOINT ["./SqliteAotTest"]
