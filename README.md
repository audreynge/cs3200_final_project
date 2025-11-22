# MBTA Accessibility and Equity: The Effectiveness of the MBTA system
### CS 3200 Final Project - Anna Bennett, Sarah Jane Gregory, Audrey Ng, Chipego Nkolola 

## File Structure

```
cs3200_final_project/
│
├-- data/
│   ├-- raw/               original CSVs / .sql files exactly as downloaded/dumped
│   ├-- processed/         cleaned/merged files
│
├-- src/
│   ├-- cleaning/          scripts to clean/process each dataset
│   ├-- analysis/          SQL scripts, EDA, geospatial analysis
│   ├-- visualization/     plots, maps, charts
│   └-- utils/             helper functions
│
│-- sql/
│   │-- init_db.sql        initialize db, create schema, load data (prob want to split into diff files, one for each step)
│   │-- load_data.sql      populate db
│   │-- queries_[...].sql  queries that get specific info from db
```

NOTE FOR THE CSV FILES:
In `/data/raw`, there should be a `raw.zip` file. Make sure to unzip this file so you can get the `.csv` files on your machine (make sure it's still in `/data/raw` after unzipping). Do not commit the `.csv` files, as they are too large for GitHub.
