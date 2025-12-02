import pandas as pd
from pathlib import Path

RAW_PATH = Path("../../data/raw/MBTA_Service_Alerts.csv")
PROCESSED_PATH = Path("../../data/processed/service_alerts.csv")

DATETIME_COLS = ["notif_start", "notif_end", "created_dt", "last_modified_dt", "closed_dt"]

def load_raw_alerts(path=RAW_PATH):
    """Load raw alerts CSV into a DataFrame."""
    return pd.read_csv(path)

def clean_alerts(df: pd.DataFrame) -> pd.DataFrame:
    """Apply cleaning transformations to the alerts DataFrame."""
    df = df.set_index("alert_id")

    # convert datetime columns
    for col in DATETIME_COLS:
        df[col] = pd.to_datetime(df[col], errors="coerce", utc=True)
    df[DATETIME_COLS] = df[DATETIME_COLS].apply(lambda x: x.dt.tz_convert("America/New_York"))

    # drop unnecessary columns
    drop_cols = ['url', 'timeframe_text', 'header', 'alert_lifecycle', 
                'details', 'affent_list', 'severity_name', 'ObjectId']
    df = df.drop(columns=drop_cols, errors="ignore")

    # filter out placeholder rows
    df = df[~df['color'].isin(['999999', 'FFFFFF'])]

    # rename columns
    df = df.rename(columns={'gui_mode_name': 'transit_mode', 
                            'short_header': 'header'})
    return df

def save_alerts(df: pd.DataFrame, path=PROCESSED_PATH):
    """Save cleaned alerts to CSV."""
    df.to_csv(path, index=False)

def main():
    raw = load_raw_alerts()
    cleaned = clean_alerts(raw)
    save_alerts(cleaned)

if __name__ == "__main__":
    main()