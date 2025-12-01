import pandas as pd
from pathlib import Path

RAW_PATH = Path("../../data/raw/rail_ridership.csv")
PROCESSED_PATH = Path("../../data/processed/rail_ridership.csv")

def load_raw_rail_ridership(path=RAW_PATH):
    """Load raw rail ridership CSV into a DataFrame."""
    return pd.read_csv(path)

def clean_rail_ridership(df: pd.DataFrame) -> pd.DataFrame:
  """Apply cleaning transformations to the rail ridership DataFrame."""
  drop_cols = ['mode', 'route_name', 'day_type_id', 'stop_name', 'ObjectId']
  df = df.drop(columns=drop_cols, errors="ignore")
  return df

def save_rail_ridership(df: pd.DataFrame, path=PROCESSED_PATH):
    """Save cleaned rail ridership to CSV."""
    df.to_csv(path, index=False)

def main():
    raw = load_raw_rail_ridership()
    cleaned = clean_rail_ridership(raw)
    save_rail_ridership(cleaned)

if __name__ == "__main__":
    main()