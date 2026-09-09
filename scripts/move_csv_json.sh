#!/bin/bash


SOURCE_DIR="${1:-}"
DEST_DIR_NAME="json_and_csv"

# Validate user input

if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <source_directory>"
    echo "Example: $0 ./incoming_files"
    exit 1
fi

# Check if the source directory exists

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Destination folder is created alongside the source directory
DEST_DIR="$(dirname "$SOURCE_DIR")/$DEST_DIR_NAME"
mkdir -p "$DEST_DIR"

echo "=================================================================="
echo " Moving CSV and JSON files"
echo " Source      : $SOURCE_DIR"
echo " Destination : $DEST_DIR"
echo "=================================================================="

# Move all .csv files (case-insensitive) that exist in the source folder
# -maxdepth 1 keeps this to the top-level folder only (not subfolders)

csv_count=$(find "$SOURCE_DIR" -maxdepth 1 -iname "*.csv" | wc -l)
if [ "$csv_count" -gt 0 ]; then
    find "$SOURCE_DIR" -maxdepth 1 -iname "*.csv" -exec mv -v {} "$DEST_DIR" \;
    echo "Moved $csv_count CSV file(s)."
else
    echo "No CSV files found in $SOURCE_DIR."
fi


# Move all .json files (case-insensitive)

json_count=$(find "$SOURCE_DIR" -maxdepth 1 -iname "*.json" | wc -l)
if [ "$json_count" -gt 0 ]; then
    find "$SOURCE_DIR" -maxdepth 1 -iname "*.json" -exec mv -v {} "$DEST_DIR" \;
    echo "Moved $json_count JSON file(s)."
else
    echo "No JSON files found in $SOURCE_DIR."
fi

echo ""
echo "Done. Current contents of $DEST_DIR:"
ls -la "$DEST_DIR"
