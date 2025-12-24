# BugRepro_SqliteArmSoFileMissing

This repository contains a bug reproduction test for SQLite with .NET AOT compilation on ARM architectures.

## Problem

There's a potential bug in .NET AOT compilation or SQLite where SQLite may not work correctly on ARM64 with AOT compilation, while it works fine on Linux x64.

## What This Does

This project:
1. **Console Application**: A simple .NET 10 console application that performs a basic SQLite query
   - Creates an in-memory SQLite database
   - Creates a table
   - Inserts test data
   - Queries the data back
   - Uses Microsoft.Data.Sqlite directly (no Dapper dependency issues)

2. **Dockerfile**: Compiles the application with AOT enabled
   - Uses multi-stage build
   - Produces a native binary with PublishAot=true

3. **GitHub Actions Workflow**: Builds and tests on multiple architectures using Docker buildx
   - linux/amd64 (x64)
   - linux/arm64 (ARM 64-bit)
   - linux/arm/v7 (ARM 32-bit)
   - Runs daily at 2 AM UTC
   - Can be triggered manually

## Running Locally

### Without Docker
```bash
cd SqliteAotTest
dotnet run
```

### With Docker (local architecture)
```bash
docker build -t sqlite-aot-test .
docker run --rm sqlite-aot-test
```

### With Docker (specific architecture)
```bash
docker buildx build --platform linux/arm64 -t sqlite-aot-test:arm64 --load .
docker run --rm --platform linux/arm64 sqlite-aot-test:arm64
```

## Expected Results

If SQLite works correctly with AOT on all platforms, you should see:
```
SQLite AOT Test - Starting...
Database connection opened successfully
Table created successfully
Test data inserted successfully

Query Results:
  ID: 1, Name: First, Value: 100
  ID: 2, Name: Second, Value: 200
  ID: 3, Name: Third, Value: 300

✓ SQLite AOT Test - Completed successfully!
```

If there's a bug, the application might:
- Fail to load SQLite native libraries
- Crash during query execution
- Show platform-specific errors

## CI/CD Status

The GitHub Actions workflow runs automatically:
- On every push to main/master
- On every pull request
- Daily at 2 AM UTC
- Can be manually triggered

Check the Actions tab to see the results for each architecture.
