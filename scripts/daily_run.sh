#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ETL_SCRIPT="$SCRIPT_DIR/etl_pipeline.sh"


CRON_ENTRY="0 0 * * * CSV_URL=\"${CSV_URL:-}\" $ETL_SCRIPT"

echo "=================================================================="
echo " Scheduling ETL script with cron"
echo " Schedule : daily at 12:00 AM"
echo " Script   : $ETL_SCRIPT"
echo "=================================================================="

# Write the cron entry as the current user's crontab
echo "$CRON_ENTRY" | crontab -

echo "SUCCESS: Cron job scheduled."
echo ""
