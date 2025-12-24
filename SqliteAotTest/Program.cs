using Microsoft.Data.Sqlite;

Console.WriteLine("SQLite AOT Test - Starting...");

// Create a SQLite database file
var dbPath = "test.db";
Console.WriteLine($"Database path: {dbPath}");

using var connection = new SqliteConnection($"Data Source={dbPath}");
connection.Open();

Console.WriteLine("Database connection opened successfully");

// Create a simple table
using (var createCommand = connection.CreateCommand())
{
    createCommand.CommandText = @"
        CREATE TABLE TestTable (
            Id INTEGER PRIMARY KEY,
            Name TEXT NOT NULL,
            Value INTEGER NOT NULL
        )
    ";
    createCommand.ExecuteNonQuery();
}

Console.WriteLine("Table created successfully");

// Insert some test data
using (var insertCommand = connection.CreateCommand())
{
    insertCommand.CommandText = @"
        INSERT INTO TestTable (Id, Name, Value) VALUES 
        (1, 'First', 100),
        (2, 'Second', 200),
        (3, 'Third', 300)
    ";
    insertCommand.ExecuteNonQuery();
}

Console.WriteLine("Test data inserted successfully");

// Query the data
using (var queryCommand = connection.CreateCommand())
{
    queryCommand.CommandText = "SELECT Id, Name, Value FROM TestTable";
    using var reader = queryCommand.ExecuteReader();
    
    Console.WriteLine("\nQuery Results:");
    while (reader.Read())
    {
        var id = reader.GetInt32(0);
        var name = reader.GetString(1);
        var value = reader.GetInt32(2);
        Console.WriteLine($"  ID: {id}, Name: {name}, Value: {value}");
    }
}

Console.WriteLine("\n✓ SQLite AOT Test - Completed successfully!");
