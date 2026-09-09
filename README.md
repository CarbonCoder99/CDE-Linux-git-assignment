# CoreDataEngineers — Linux & Git ETL Project

A lightweight, dependency-free ETL pipeline built entirely in Bash — extracting a CSV from a remote source, transforming it, loading it into a "Gold" layer, and running on an automated daily schedule via cron. Built as part of a Linux systems administration and Git version-control exercise for a Data Engineer role at CoreDataEngineers.

## Overview

CoreDataEngineers runs its infrastructure on Linux. This repo contains the scripts used to manage a small piece of that data infrastructure:

- **`etl_pipeline.sh`** — Extracts a CSV file, transforms it (renames a column, selects a subset of fields), and loads it into a final output layer.
- **`cron_setup.sh`** — Schedules the ETL script to run automatically every day at 12:00 AM.
- **`move_csv_json.sh`** — Utility script that sweeps CSV and JSON files from any folder into a single `json_and_csv/` folder.

All output data is versioned separately from the scripts (see [`.gitignore`](#project-structure)) — only the automation logic itself is tracked in git.

## Features

- ✅ Pure Bash — no external dependencies beyond standard Unix tools (`curl`, `awk`, `find`)
- ✅ Name-based column matching in the transform step — works even if source columns are reordered or extra columns are added
- ✅ Explicit success/failure confirmation printed at every pipeline stage
- ✅ Configurable via environment variable (`CSV_URL`) rather than hard-coded values
- ✅ One-command cron scheduling


## Project structure

```
coredataengineers-project/
├── scripts/
│   ├── etl_pipeline.sh      # Extract, Transform, Load
│   ├── cron_setup.sh        # Schedules the ETL script via cron
│   └── move_csv_json.sh     # Moves CSV/JSON files into json_and_csv/
├── raw/                      # Extract output (git-ignored, created at runtime)
├── Transformed/               # Transform output (git-ignored, created at runtime)
├── Gold/                      # Load output (git-ignored, created at runtime)
├── .gitignore
└── README.md
```

## Prerequisites

- A Linux (or WSL/macOS) environment with `bash`, `curl`, `awk`, and `find`
- `cron` installed and running, for scheduled execution
- `git`, to clone and version this repo

## Getting started

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
chmod +x scripts/*.sh
```

## Usage

### 1. Run the ETL pipeline

Set the source CSV URL as an environment variable, then run the script:

```bash
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
./scripts/etl_pipeline.sh
```

| Stage | What happens |
|---|---|
| **Extract** | Downloads the CSV from `$CSV_URL` into `raw/`, confirms the file was saved |
| **Transform** | Renames `Variable_code` → `variable_code`; keeps only `year`, `Value`, `Units`, `variable_code`; writes `Transformed/2023_year_finance.csv`, confirms the save |
| **Load** | Copies the transformed file into `Gold/`, confirms the save |

Each stage prints a clear `[EXTRACT]` / `[TRANSFORM]` / `[LOAD]` status, including a preview of the transformed data.

### 2. Schedule it with cron

```bash
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
./scripts/cron_setup.sh
```

This installs a cron entry that runs `etl_pipeline.sh` daily at **12:00 AM** (`0 0 * * *`) and logs output to `etl_log.log`.

Verify it's scheduled:
```bash
crontab -l
```

### 3. Move CSV and JSON files

```bash
./scripts/move_csv_json.sh <path-to-source-folder>
```

Moves every `.csv` and `.json` file (case-insensitive) from the given folder into a new `json_and_csv/` folder alongside it. Works with any number of files of either type.

## Sample output

```
==================================================================
 CoreDataEngineers ETL Pipeline
 Run started : 2026-09-09 00:00:01
 Source URL  : https://your-real-download-link.com/file.csv
==================================================================

>>> [EXTRACT] Downloading source CSV...
[EXTRACT] SUCCESS: File saved to: raw/source_data.csv

>>> [TRANSFORM] Renaming column and selecting required fields...
[TRANSFORM] SUCCESS: Transformed file saved to: Transformed/2023_year_finance.csv

>>> [LOAD] Loading transformed data into the Gold layer...
[LOAD] SUCCESS: File loaded into: Gold/2023_year_finance.csv

==================================================================
 ETL Pipeline completed successfully at 2026-09-09 00:00:02
==================================================================
```

## Git workflow

```bash
git add .
git commit -m "Description of change"
git push
```

Commits in this repo follow small, descriptive messages (e.g. `Fix column selection logic in transform step`) rather than bundling unrelated changes together.

## License

© CarbonCoder99

## Author

Olugbade Waziri Abiodun
