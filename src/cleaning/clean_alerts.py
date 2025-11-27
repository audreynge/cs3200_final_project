import pandas as pd

# working in clean_alerts.ipynb first


def clean_alerts():
  df = pd.read_csv("../../data/raw/MBTA_Service_Alerts.csv")
  df = df[["alert_id", "alert_type", "description", "created_at"]]
  df.to_csv("../../data/processed/alerts.csv", index=False)

def main():
  clean_alerts()