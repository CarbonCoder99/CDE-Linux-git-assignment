#!/bin/bash

#Set up Folder and File names as variables so they can be easily changed in one place
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"      #this will be the project root
RAW_DIR="$BASE_DIR/raw"        #this is where the raw data will be stored
TRANSFORMED_DIR="$BASE_DIR/Transformed"  #this is where the transformed data will be stored
GOLD_DIR="$BASE_DIR/gold"        #this is where the final data will be stored

RAW_FILE="$RAW_DIR/source_data.csv"  #this is the path to the raw data file
TRANSFORMED_FILE="$TRANSFORMED_DIR/2023_year_finance.csv"  #this is the path to the transformed data file

LOG_TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"  #this will be used to create a timestamp for terminal logging


echo "===================================================================="
echo "========== ETL Pipeline Started ======="
echo " Run started at: $LOG_TIMESTAMP"
echo "===================================================================="



# EXTRACT LOGIC
echo ""
echo "Extraction starting now..."
echo "Downloading raw data from source..."

# Download the raw data from the source and save it to the raw directory
curl -s -L -o "$RAW_FILE" "$CSV_URL"

# Confirm that the raw data was downloaded successfully
if [ -f "$RAW_FILE" ]; then
    echo "SUCCESS: Raw data downloaded successfully."
else
    echo "ERROR: Raw data download failed."
    exit 1
fi



# TRANSFORM LOGIC
echo ""
echo "Transformation starting now..."

mkdir -p "$TRANSFORMED_DIR"  # Create the transformed directory if it doesn't exist

# Transformation will be done here with awk command. The transformation logic will:
#   - Reads the header row and records the position (column number) of
#     each column we care about, by NAME, so column order in the source
#     file doesn't matter.
#   - Renames "Variable_code" to "variable_code" while reading the header.
#   - Writes out only: year, Value, Units, variable_code, in that order.

awk -F',' ' BEGIN {
  OFS=","
}
NR==1 {
  # Find column indices by name
  for (i=1; i<=NF; i++) {
    if ($i=="Year") y=i
    if ($i=="Value") v=i
    if ($i=="Units") u=i
    if ($i=="Variable_code" || $i=="variable code") c=i
  }
  print "Year","Value","Units","variable_code"
  next
}
{
  print $y,$v,$u,$c
}
' "$RAW_FILE" > "$TRANSFORMED_FILE"

# Now, we confirm if the tranformed file was written successfully

if [ -s "$TRANSFORMED_FILE" ] && [ "$(wc -l < "$TRANSFORMED_FILE")" -gt 1 ]; then
    echo "[TRANSFORM] SUCCESS: Transformed file saved to: $TRANSFORMED_FILE"
    echo "[TRANSFORM] Preview of transformed data:"
    head -n 5 "$TRANSFORMED_FILE"
else
    echo "[TRANSFORM] ERROR: Transformation produced no data rows. Aborting..."
    exit 1
fi

# LOAD LOGIC

echo ""
echo "Loading starting now..."

mkdir -p "$GOLD_DIR"  # Create the gold directory if it doesn't exist

cp "$TRANSFORMED_FILE" "$GOLD_DIR/"

# Confirm that the file was copied successfully
if [ -s "$GOLD_DIR/2023_year_finance.csv" ]; then
    echo "[LOAD] SUCCESS: File loaded into: $GOLD_DIR/2023_year_finance.csv"
else
    echo "[LOAD] ERROR: Load step failed. Aborting."
    exit 1
fi


echo "===================================================================="
echo "========== ETL Pipeline completed successfully ======="
echo " Completed at: $LOG_TIMESTAMP"
echo "===================================================================="