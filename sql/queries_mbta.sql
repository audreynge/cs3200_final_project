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

-- What neighborhood has the highest income?
SELECT neighborhood, median_household_income
FROM neighborhood_income
ORDER BY median_household_income DESC;

-- Are ridership and income related?
SELECT 
    ni.neighborhood,
    ni.median_household_income,
    SUM(rr.total_ons + rr.total_offs) AS total_ridership
FROM rail_ridership rr
JOIN stop_neighborhood sn ON rr.stop_id = sn.stop_id
JOIN neighborhood_mapping nm ON sn.neighborhood_name = nm.raw_name
JOIN neighborhood_income ni ON nm.income_name = ni.neighborhood
GROUP BY ni.neighborhood, ni.median_household_income
ORDER BY total_ridership DESC;

-- The number of stations in each neighborhood?
SELECT 
    ni.neighborhood,
    ni.median_household_income,
    COUNT(DISTINCT sn.stop_id) AS num_stations
FROM stop_neighborhood sn
JOIN neighborhood_mapping nm ON sn.neighborhood_name = nm.raw_name
JOIN neighborhood_income ni ON nm.income_name = ni.neighborhood
GROUP BY ni.neighborhood, ni.median_household_income
ORDER BY ni.median_household_income ASC;

-- What are the most popular stops?
-- stops by total offs (by line)
SELECT 
    route_name,
    stop_name,
    SUM(total_offs) AS total_offs_ranked
FROM rail_ridership
GROUP BY route_name, stop_name
ORDER BY route_name, total_offs_ranked DESC;

-- Which rail stations have the highest overall ridership?
SELECT DISTINCT stop_name, SUM(total_ons) as "total_overall_on"
FROM rail_ridership
GROUP BY stop_name
ORDER BY total_overall_on DESC
LIMIT 10;

-- Which bus stations have the highest overall ridership?
SELECT DISTINCT stop_name, SUM(ons_all_trips) as "total_overall_on"
FROM bus_ridership
GROUP BY stop_name
ORDER BY total_overall_on DESC
LIMIT 10;

-- which tranist modes have the most alerts and how severe are they?
SELECT
    a.gui_mode_name AS mode,
    a.alert_time_type,
    COUNT(*) AS total_alerts,
    AVG(a.severity_code) AS avg_severity
FROM alerts a
GROUP BY a.gui_mode_name, a.alert_time_type
ORDER BY total_alerts DESC;

-- How many stops are wheelchair accessible on each line?
-- what percent of stops are wheelchair accessible?
SELECT 
    li.line_name,
    SUM(CASE WHEN s.wheelchair_boarding = '1' THEN 1 ELSE 0 END) AS accessible_stops,
    COUNT(*) AS total_stops,
    SUM(CASE WHEN s.wheelchair_boarding = '1' THEN 1 ELSE 0 END) / COUNT(*) AS pct_accessible
FROM stop_line sl
JOIN stops s ON sl.stop_id_pk = s.stop_id_pk
JOIN line_info li ON sl.line_id = li.line_id
GROUP BY li.line_name;

-- Which neighborhoods rely on the bus most?
SELECT 
    ni.neighborhood,
    ni.median_household_income,
    SUM(br.average_ons + br.average_offs) AS bus_ridership
FROM bus_ridership br
JOIN stop_neighborhood sn ON br.stop_id = sn.stop_id
JOIN neighborhood_mapping nm ON sn.neighborhood_name = nm.raw_name
JOIN neighborhood_income ni ON nm.income_name = ni.neighborhood
GROUP BY ni.neighborhood, ni.median_household_income
ORDER BY bus_ridership DESC;

-- Which neighborhoods rely on the rail the most?
SELECT 
    ni.neighborhood,
    ni.median_household_income,
    SUM(rr.total_ons + rr.total_offs) AS rail_ridership
FROM rail_ridership rr
JOIN stop_neighborhood sn ON rr.stop_id = sn.stop_id
JOIN neighborhood_mapping nm ON sn.neighborhood_name = nm.raw_name
JOIN neighborhood_income ni ON nm.income_name = ni.neighborhood
GROUP BY ni.neighborhood, ni.median_household_income
ORDER BY rail_ridership DESC;
