-- use the mbta database that we have created
USE mbta;

SELECT * FROM rail_ridership;
SELECT * FROM neighborhood_income;
SELECT * FROM neighborhood_mapping;
SELECT * FROM rail_stop;
SELECT * FROM bus_stop;
SELECT * FROM bus_ridership;
SELECT * FROM rail_line;
SELECT * FROM bus_route;
SELECT * FROM direction;
SELECT * FROM transport_mode;
SELECT * FROM stops_on_a_rail_line;
SELECT * FROM stops_on_a_bus_route;
SELECT * FROM alert;

-- Which stations have the highest overall ridership?
SELECT stop_name, SUM(total_ons) as "total_overall_on"
FROM rail_ridership rr
JOIN rail_stop rs USING (stop_id)
GROUP BY stop_name
ORDER BY total_overall_on DESC;

-- What neighborhood has the highest income?
SELECT neighborhood, median_household_income
FROM neighborhood_income
ORDER BY median_household_income DESC;

-- What are the most popular stops based on total offs?
SELECT 
    line_name,
    stop_name,
    SUM(total_offs) AS total_offs_ranked
FROM rail_ridership rr
JOIN rail_line rl ON rr.route_id = rl.line_id
JOIN rail_stop rs USING (stop_id)
GROUP BY line_name, stop_name
ORDER BY total_offs_ranked DESC;

-- Which rail stations have the highest overall ridership?
SELECT DISTINCT stop_name, SUM(total_ons) as "total_overall_on"
FROM rail_ridership rr
JOIN rail_stop USING (stop_id)
GROUP BY stop_name
ORDER BY total_overall_on DESC
LIMIT 10;

-- Which bus stations have the highest overall ridership?
SELECT DISTINCT stop_name, SUM(ons_all_trips) as "total_overall_on"
FROM bus_ridership br
JOIN bus_stop USING (stop_id)
GROUP BY stop_name
ORDER BY total_overall_on DESC
LIMIT 10;

-- Which transit modes have the most alerts and how severe are they?
SELECT
    tm.mode_name AS mode,
    a.alert_time_type,
    COUNT(*) AS total_alerts,
    AVG(a.severity_code) AS avg_severity
FROM alert a
JOIN transport_mode tm USING (mode_id)
GROUP BY tm.mode_name, a.alert_time_type
ORDER BY total_alerts DESC;

-- How many stops are wheelchair accessible on each line?
-- what percent of stops are wheelchair accessible?
SELECT 
    rl.line_name,
    SUM(CASE WHEN rs.wheelchair_boarding = '1' THEN 1 ELSE 0 END) AS accessible_stops,
    COUNT(*) AS total_stops,
    SUM(CASE WHEN rs.wheelchair_boarding = '1' THEN 1 ELSE 0 END) / COUNT(*) AS pct_accessible
FROM stops_on_a_rail_line srl
JOIN rail_stop rs USING (stop_id)
JOIN rail_line rl USING (line_id)
GROUP BY rl.line_name;


## bus_stop query returning blank for these 4 queries ?? 
-- Are ridership and income related?
SELECT 
    ni.neighborhood,
    ni.median_household_income,
    SUM(rr.total_ons + rr.total_offs) AS total_ridership
FROM rail_ridership rr
JOIN bus_stop bs ON rr.stop_id = bs.stop_id
JOIN neighborhood_mapping nm ON bs.neighborhood_name = nm.raw_name
JOIN neighborhood_income ni ON nm.income_name = ni.neighborhood
GROUP BY ni.neighborhood, ni.median_household_income
ORDER BY total_ridership DESC;


-- The number of stations in each neighborhood?
SELECT 
    ni.neighborhood,
    ni.median_household_income,
    COUNT(DISTINCT bs.stop_id) AS num_stations
FROM bus_stop bs
JOIN neighborhood_mapping nm ON bs.neighborhood_name LIKE nm.raw_name
JOIN neighborhood_income ni ON bs.neighborhood_name = ni.neighborhood
GROUP BY ni.neighborhood, ni.median_household_income
ORDER BY ni.median_household_income ASC;

-- Which neighborhoods rely on the bus most?
SELECT 
    ni.neighborhood,
    ni.median_household_income,
    SUM(br.average_ons + br.average_offs) AS bus_ridership
FROM bus_ridership br
JOIN bus_stop bs ON br.stop_id = bs.stop_id
JOIN neighborhood_mapping nm ON bs.neighborhood_name = nm.raw_name
JOIN neighborhood_income ni ON nm.income_name = ni.neighborhood
GROUP BY ni.neighborhood, ni.median_household_income
ORDER BY bus_ridership DESC;

SELECT DISTINCT bs.neighborhood_name, ROUND(AVG(average_load), 2) as "avg_traffic"
FROM bus_ridership br
JOIN bus_stop bs USING (stop_id)
GROUP BY bs.neighborhood_name
ORDER BY avg_traffic DESC;



-- Which neighborhoods rely on the rail the most?
SELECT 
    ni.neighborhood,
    ni.median_household_income,
    SUM(rr.total_ons + rr.total_offs) AS rail_ridership
FROM rail_ridership rr
JOIN bus_stop bs ON rr.stop_id = bs.stop_id
JOIN neighborhood_mapping nm ON sn.neighborhood_name = nm.raw_name
JOIN neighborhood_income ni ON nm.income_name = ni.neighborhood
GROUP BY ni.neighborhood, ni.median_household_income
ORDER BY rail_ridership DESC;



-- Trigger for identifying status of alerts
ALTER TABLE alerts ADD COLUMN status VARCHAR(20);

DROP TRIGGER IF EXISTS classify_alert_status;
DELIMITER //
CREATE TRIGGER classify_alert_status
BEFORE INSERT ON alerts
FOR EACH ROW
BEGIN
    IF NEW.notif_start <= NOW() AND (NEW.notif_end IS NULL OR NEW.notif_end > NOW()) THEN
        SET NEW.status = 'Active';
    ELSEIF NEW.notif_start > NOW() THEN
        SET NEW.status = 'Upcoming';
    ELSE
        SET NEW.status = 'Expired';
    END IF;
END //

DELIMITER ;

-- Test case for trigger
INSERT INTO alerts (
    alert_id, notif_start, notif_end, created_dt) VALUES (9999, 
    NOW() - INTERVAL 2 HOUR,   -- started earlier today
    NOW() + INTERVAL 3 HOUR,   -- ends later today
    NOW());

SELECT alert_id, status, notif_start, notif_end
FROM alerts
WHERE alert_id = 9999;
