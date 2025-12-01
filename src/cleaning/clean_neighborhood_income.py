import pandas as pd
from pathlib import Path

RAW_PATH = Path('../../data/raw/boston_neighborhood_income.csv')
PROCESSED_PATH = Path('../../data/processed/neighborhood_income.csv')

def load_raw_neighborhood_income(path=RAW_PATH):
    """Load raw neighborhood income CSV into a DataFrame."""
    return pd.read_csv(path)

def clean_neighborhood_income(df: pd.DataFrame) -> pd.DataFrame:
  """Apply cleaning transformations to the neighborhood income DataFrame."""
  # rename cols
  new_cols = [
      "neighborhood",
      "median_income",
      "total_households",
      "income_lt_15000",
      "pct_lt_15000",
      "income_15000_24999",
      "pct_15000_24999",
      "income_25000_34999",
      "pct_25000_34999",
      "income_35000_49999",
      "pct_35000_49999",
      "income_50000_74999",
      "pct_50000_74999",
      "income_75000_99999",
      "pct_75000_99999",
      "income_100000_149999",
      "pct_100000_149999",
      "income_150000_plus",
      "pct_150000_plus"
  ]

  df.columns = new_cols
  return df

def save_neighborhood_income(df: pd.DataFrame, path=PROCESSED_PATH):
    """Save cleaned neighborhood income to CSV."""
    df.to_csv(path, index=False)

def main():
    raw = load_raw_neighborhood_income()
    cleaned = clean_neighborhood_income(raw)
    save_neighborhood_income(cleaned)

if __name__ == "__main__":
    main()