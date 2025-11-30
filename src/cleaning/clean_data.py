from clean_alerts import main as clean_alerts
from clean_rail_ridership import main as clean_rail_ridership

def main():
    """Cleans all the CSVs."""
    clean_alerts()
    clean_rail_ridership()

if __name__ == "__main__":
    main()