-- use the mbta database that we have created
USE mbta;

SELECT * FROM rail_ridership;
SELECT * FROM neighborhood_income;
SELECT * FROM stops;
SELECT * FROM stop_neighborhood;
SELECT * FROM bus_ridership;
SELECT * FROM line_info;
SELECT * FROM directions;
SELECT * FROM stop_line;

-- Which stations have the highest overall ridership?
SELECT stop_name, SUM(total_ons) as "total_overall_on"
FROM rail_ridership
GROUP BY stop_name
ORDER BY total_overall_on DESC;

-- What neighborhood has the highest income
SELECT neighborhood, median_household_income
FROM neighborhood_income
ORDER BY median_household_income DESC;

-- How many stops are in each neighborhood
SELECT neighborhood_name, COUNT(*) AS total_stops
FROM stop_neighborhood
WHERE neighborhood_name IS NOT NULL
GROUP BY neighborhood_name
ORDER BY total_stops DESC;
