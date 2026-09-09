#!/bin/bash

#Set up Folder and File names as variables so they can be easily changed in one place
BASE_DIR= "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"      #this will be the project root
RAW_DIR="$BASE_DIR/raw"        #this is where the raw data will be stored
TRANFORMED_DIR="$BASE_DIR/transformed"  #this is where the transformed data will be stored
GOLD_DIR="$BASE_DIR/gold"        #this is where the final data will be stored

RAW_FILE="$RAW_DIR/source_data.csv"  #this is the path to the raw data file
TRANFORMED_FILE="$TRANFORMED_DIR/2023_year_finance.csv"  #this is the path to the transformed data file

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
curl -L -o "$RAW_FILE" "$CSV_URL"

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

# Perform data transformation logic here

# LOAD LOGIC