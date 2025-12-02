import pandas as pd
from pathlib import Path

RAW_PATH = Path('../../data/raw/Rapid_Transit_Stops.csv')
PROCESSED_PATH = Path('../../data/processed/Rapid_Transit_Stops.csv')

def clean_rapid_transit_stops():
    # Load raw CSV
    df = pd.read_csv(RAW_PATH)

    # Drop irrelevant columns
    drop_cols = [
        'X', 'Y', 'OBJECTID',
        'created_user', 'created_date',
        'last_edited_user', 'last_edited_date',
        'stop_desc', 'platform_code', 'platform_name'
    ]

    df = df.drop(columns=[c for c in drop_cols if c in df.columns], errors='ignore')

    # Stop codes completely dropped
    df = df.drop(columns=['stop_code'], errors='ignore')

    # drops 'zone_id' and 'parent_station' columns if majority are empty
    if 'zone_id' in df.columns:
        if df['zone_id'].isna().mean() > 0.85:
            df = df.drop(columns=['zone_id'])

    if 'parent_station' in df.columns:
        if df['parent_station'].isna().mean() > 0.85:
            df = df.drop(columns=['parent_station'])


    df = df.drop(columns=[col for col in drop_cols if col in df.columns], errors='ignore')

    #Strip whitespace from all string columns
    str_cols = df.select_dtypes(include='object').columns
    df[str_cols] = df[str_cols].apply(lambda x: x.astype(str).str.strip())

    # Convert lat/lon to numeric
    df['stop_lat'] = pd.to_numeric(df['stop_lat'], errors='coerce')
    df['stop_lon'] = pd.to_numeric(df['stop_lon'], errors='coerce')

    # Drop rows missing KEY fields
    key_fields = ['stop_id', 'stop_lat', 'stop_lon', 'stop_name']
    df = df.dropna(subset=[col for col in key_fields if col in df.columns])

    # Remove rows with invalid coordinates
    df = df[df['stop_lat'].between(-90, 90)]
    df = df[df['stop_lon'].between(-180, 180)]

    # Remove duplicate stop_id (keep first)
    if 'stop_id' in df.columns:
        df = df.drop_duplicates(subset='stop_id')

    # Reset index for cleanliness
    df = df.reset_index(drop=True)

    # Save cleaned CSV
    PROCESSED_PATH.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(PROCESSED_PATH, index=False)

    print(f"✔ Cleaned file saved to: {PROCESSED_PATH}")


if __name__ == "__main__":
    clean_rapid_transit_stops()