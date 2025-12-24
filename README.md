# BugRepro_SqliteArmSoFileMissing

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