from clean_alerts import main as clean_alerts
from clean_rail_ridership import main as clean_rail_ridership
from clean_bus_ridership import main as clean_bus_ridership
from clean_neighborhood_income import main as clean_neighborhood_income

def main():
    """Cleans all the CSVs."""
    clean_alerts()
    clean_rail_ridership()
    clean_bus_ridership()
    clean_neighborhood_income()

if __name__ == "__main__":
    main()