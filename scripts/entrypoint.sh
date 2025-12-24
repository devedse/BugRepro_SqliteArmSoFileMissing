#!/bin/sh

echo "Listing /app/publish contents:"
ls

echo "Running the SqliteAotTest application:"
exec ./SqliteAotTest

echo "Listing /app/publish contents after execution:"
ls