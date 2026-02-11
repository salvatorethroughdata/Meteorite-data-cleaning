# Meteorite-data-cleaning ✅

This repository demonstrates a simple **data cleaning workflow** on a meteorites dataset using **SQLite3**.

## Files

- `cleaning_steps.sql` — SQL script with all cleaning steps
- `meteorites.csv` — Raw meteorites dataset

## Overview

The SQL script performs:

1. Import CSV into a temporary table
2. Convert empty values to NULL and round numeric columns
3. Remove unwanted entries
4. Reorder data and regenerate unique IDs
5. Create final cleaned table `meteorites` with consistent columns
