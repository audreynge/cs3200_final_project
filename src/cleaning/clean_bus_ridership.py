import pandas as pd
from pathlib import Path

RAW_PATH = Path("../../data/raw/bus_ridership.csv")
PROCESSED_PATH = Path("../../data/processed/bus_ridership.csv")

def load_raw_bus_ridership(path=RAW_PATH):
    """Load raw bus ridership CSV into a DataFrame."""
    return pd.read_csv(path)

def clean_bus_ridership(df: pd.DataFrame) -> pd.DataFrame:
  """Apply cleaning transformations to the bus ridership DataFrame."""
  drop_cols = ['mode', 'route_name', 'route_variant', 'stop_sequence', 'day_type_id', 'stop_name', 'ObjectId']
  df = df.drop(columns=drop_cols, errors="ignore")
  return df

def save_bus_ridership(df: pd.DataFrame, path=PROCESSED_PATH):
    """Save cleaned bus ridership to CSV."""
    df.to_csv(path, index=False)

def main():
    raw = load_raw_bus_ridership()
    cleaned = clean_bus_ridership(raw)
    save_bus_ridership(cleaned)

if __name__ == "__main__":
    main()