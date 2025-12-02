DROP DATABASE IF EXISTS mbta;
CREATE DATABASE mbta;
USE mbta;

DROP TABLE IF EXISTS direction;
CREATE TABLE direction (
	direction_id INT PRIMARY KEY,
	direction_name VARCHAR(20)
);
INSERT INTO direction (direction_id, direction_name) VALUES
(0, 'Inbound'),
(1, 'Outbound');
-- check
SELECT * FROM direction;


DROP TABLE IF EXISTS transport_mode;
CREATE TABLE transport_mode (
	mode_id INT PRIMARY KEY,
    mode_name VARCHAR(20)
);
INSERT INTO transport_mode (mode_id, mode_name)
VALUES
(0, 'Bus'),
(1, 'Subway'),
(2, 'Commuter Rail'),
(3, 'Access');
-- check
SELECT * FROM transport_mode;


DROP TABLE IF EXISTS rail_line;
CREATE TABLE rail_line (
    line_id VARCHAR(10) PRIMARY KEY,
    line_name VARCHAR(50),
    rail_type VARCHAR(50),
    mode_id INT,
    FOREIGN KEY (mode_id) REFERENCES transport_mode(mode_id)
);
INSERT INTO rail_line (line_id, line_name, rail_type, mode_id)
VALUES
('Red', 'Red Line', 'Rapid Transit', 1),
('Orange', 'Orange Line', 'Rapid Transit', 1),
('Blue', 'Blue Line', 'Rapid Transit', 1),
('Green', 'Green Line', 'Light Rail', 1);
-- check
SELECT * FROM rail_line;


DROP TABLE IF EXISTS rail_stop;
-- create stops
CREATE TABLE rail_stop (
    stop_id VARCHAR(20) PRIMARY KEY,
    stop_name VARCHAR(255), 
    stop_lat DOUBLE,
    stop_lon DOUBLE,
    stop_address VARCHAR(255),
    stop_url VARCHAR(255),
    level_id VARCHAR(50),
    location_type VARCHAR(50),
    wheelchair_boarding VARCHAR(10),
    municipality VARCHAR(100));
-- load stops
LOAD DATA LOCAL INFILE '/Users/sarahjanegregory/Desktop/cs3200/project/processed_data/Rapid_Transit_Stops.csv'
INTO TABLE rail_stop
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES(
    stop_id,
    stop_name,
    stop_lat,
    stop_lon,
    stop_address,
    stop_url,
    level_id,
    location_type,
    wheelchair_boarding,
    municipality);
-- check
SELECT * FROM rail_stop;


DROP TABLE IF EXISTS rail_ridership;
-- create rail ridership
CREATE TABLE rail_ridership (
    season VARCHAR(50),
    route_id VARCHAR(50),
    direction_id INT, 
    day_type_name VARCHAR(50),
    time_period_id VARCHAR(50),
    time_period_name VARCHAR(100),
    stop_id VARCHAR(50), 
    total_ons INT,
    total_offs INT,
    number_service_days INT,
    average_ons INT,
    average_offs INT,
    average_flow INT,
    FOREIGN KEY (route_id) REFERENCES rail_line(line_id),
    FOREIGN KEY (direction_id) REFERENCES direction(direction_id),
    FOREIGN KEY (stop_id) REFERENCES rail_stop(stop_id)
);
    
-- load rail ridership
LOAD DATA LOCAL INFILE '/Users/sarahjanegregory/Desktop/cs3200/project/processed_data/rail_ridership.csv'
INTO TABLE rail_ridership
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES(
    season,
    route_id,
    direction_id,
    day_type_name,
    time_period_id,
    time_period_name,
    stop_id, 
    total_ons,
    total_offs,
    number_service_days,
    average_ons,
    average_offs,
    average_flow
);
-- add primary key
ALTER TABLE rail_ridership
ADD rail_ridership_id INT PRIMARY KEY AUTO_INCREMENT;
-- check correctness 
SELECT * from rail_ridership;


DROP TABLE IF EXISTS neighborhood_income;
-- income by neighborhood
CREATE TABLE neighborhood_income (
    neighborhood VARCHAR(100) PRIMARY KEY,
    median_household_income INT,
    total_households INT,

    less_than_15000 INT,
    pct_less_than_15000 DECIMAL,

    income_15000_24999 INT,
    pct_15000_24999 DECIMAL,

    income_25000_34999 INT,
    pct_25000_34999 DECIMAL,

    income_35000_49999 INT,
    pct_35000_49999 DECIMAL,

    income_50000_74999 INT,
    pct_50000_74999 DECIMAL,

    income_75000_99999 INT,
    pct_75000_99999 DECIMAL,

    income_100000_149999 INT,
    pct_100000_149999 DECIMAL,

    income_150000_plus INT,
    pct_150000_plus DECIMAL
);

-- load neighborhood income
LOAD DATA LOCAL INFILE '/Users/sarahjanegregory/Desktop/cs3200/project/processed_data/neighborhood_income.csv'
INTO TABLE neighborhood_income
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES(
    neighborhood,
    median_household_income,
    total_households,
    less_than_15000,
    pct_less_than_15000,
	income_15000_24999,
    pct_15000_24999,
    income_25000_34999,
    pct_25000_34999,
    income_35000_49999,
    pct_35000_49999,
    income_50000_74999,
    pct_50000_74999,
    income_75000_99999,
    pct_75000_99999,
    income_100000_149999,
    pct_100000_149999,
    income_150000_plus,
    pct_150000_plus);
-- check
SELECT * FROM neighborhood_income;


DROP TABLE IF EXISTS neighborhood_mapping;
CREATE TABLE neighborhood_mapping (
    raw_name VARCHAR(100) PRIMARY KEY,
    income_name VARCHAR(100),
    FOREIGN KEY (income_name) REFERENCES neighborhood_income(neighborhood)
);
INSERT INTO neighborhood_mapping (raw_name, income_name) VALUES
('Allston', 'Allston'),
('Back Bay', 'Back Bay'),
('Bay Village', 'South End'),
('Beacon Hill', 'Beacon Hill'),
('Brighton', 'Brighton'),
('Charlestown', 'Charlestown'),
('Chinatown', 'Chinatown'),
('Dorchester', 'Dorchester'),
('Downtown', 'Downtown'),
('East Boston', 'East Boston'),
('Fenway', 'Fenway'),
('Harbor Islands', NULL),
('Hyde Park', 'Hyde Park'),
('Jamaica Plain', 'Jamaica Plain'),
('Leather District', 'Downtown'),
('Longwood', 'Longwood'),
('Mattapan', 'Mattapan'),
('Mission Hill', 'Mission Hill'),
('North End', 'North End'),
('Roslindale', 'Roslindale'),
('Roxbury', 'Roxbury'),
('South Boston', 'South Boston'),
('South Boston Waterfront', 'South Boston Waterfront'),
('South End', 'South End'),
('West End', 'West End'),
('West Roxbury', 'West Roxbury');
SELECT * FROM neighborhood_mapping;


DROP TABLE IF EXISTS bus_stop;
CREATE TABLE bus_stop (
    stop_id INT PRIMARY KEY,
    stop_name VARCHAR(255),
    neighborhood_name VARCHAR(100)
);

LOAD DATA LOCAL INFILE '/Users/sarahjanegregory/Desktop/cs3200/project/processed_data/stop_neighborhood.csv'
INTO TABLE bus_stop
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(stop_id, stop_name, neighborhood_name);
-- check
SELECT * FROM bus_stop;


DROP TABLE IF EXISTS bus_ridership;
-- create bus table
CREATE TABLE bus_ridership (
    season VARCHAR(50),
    route_id INT,
    direction_id INT,
    day_type_name VARCHAR(50),
    time_period_id VARCHAR(50),
    time_period_name VARCHAR(100),
    stop_id INT,
    average_ons DECIMAL,
    average_offs DECIMAL,
    average_load DECIMAL,
    num_trips INT,
    ons_all_trips DECIMAL,
    FOREIGN KEY (direction_id) REFERENCES direction(direction_id),
    FOREIGN KEY (stop_id) REFERENCES bus_stop(stop_id)
);

-- load bus data
LOAD DATA LOCAL INFILE '/Users/sarahjanegregory/Desktop/cs3200/project/processed_data/bus_ridership.csv'
INTO TABLE bus_ridership
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES(
    season, 
    route_id, 
    direction_id,
    day_type_name, 
    time_period_id,
    time_period_name,
    stop_id,
    average_ons,
    average_offs,
    average_load,
    num_trips,
    ons_all_trips
); 
-- add primary key
ALTER TABLE bus_ridership
ADD bus_ridership_id INT PRIMARY KEY AUTO_INCREMENT;
-- check


DROP TABLE IF EXISTS bus_route;
CREATE TABLE bus_route (
	route_id INT PRIMARY KEY,
    route_name INT,
    mode_id INT DEFAULT 0,
    FOREIGN KEY (mode_id) REFERENCES transport_mode(mode_id)
);
INSERT INTO bus_route (route_id, route_name)
SELECT DISTINCT route_id AS route_id, route_id AS route_name
FROM bus_ridership
ORDER BY route_id;
-- check
SELECT * FROM bus_route;

ALTER TABLE bus_ridership
ADD CONSTRAINT FOREIGN KEY (route_id) REFERENCES bus_route(route_id);


DROP TABLE IF EXISTS stops_on_a_rail_line;
CREATE TABLE stops_on_a_rail_line (
    stop_id VARCHAR(20),
    line_id VARCHAR(10),
    FOREIGN KEY (stop_id) REFERENCES rail_stop(stop_id),
    FOREIGN KEY (line_id) REFERENCES rail_line(line_id)
);
INSERT INTO stops_on_a_rail_line (stop_id, line_id)
SELECT DISTINCT s.stop_id, l.line_id
FROM rail_ridership rr
JOIN rail_stop s ON rr.stop_id = s.stop_id
JOIN rail_line l ON rr.route_id = l.line_id;
-- check
SELECT * FROM stops_on_a_rail_line;

DROP TABLE IF EXISTS stops_on_a_bus_route;
CREATE TABLE stops_on_a_bus_route (
    stop_id INT,
    route_id INT,
    FOREIGN KEY (stop_id) REFERENCES bus_stop(stop_id),
    FOREIGN KEY (route_id) REFERENCES bus_route(route_id)
);
INSERT INTO stops_on_a_bus_route (stop_id, route_id)
SELECT DISTINCT s.stop_id, r.route_id
FROM bus_ridership br
JOIN bus_stop s USING (stop_id)
JOIN bus_route r USING (route_id);
-- check
SELECT * FROM stops_on_a_bus_route;

-- load alerts
DROP TABLE IF EXISTS alert;
CREATE TABLE alert (
    alert_id            INT PRIMARY KEY,
    mode_id             INT NULL,
    alert_time_type     VARCHAR(50) NULL,
    effect_code         VARCHAR(50) NULL,
    cause_name          VARCHAR(100) NULL,
    cause_code          VARCHAR(50) NULL,
    severity_code       INT NULL,
    notif_start         TIMESTAMP NULL,
    notif_end           TIMESTAMP NULL,
    created_dt          TIMESTAMP NULL,
    service_effect_text TEXT NULL,
    FOREIGN KEY (mode_id) REFERENCES transport_mode(mode_id)
);

LOAD DATA LOCAL INFILE '/Users/sarahjanegregory/Desktop/cs3200/project/processed_data/service_alerts.csv'
INTO TABLE alert
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    alert_id,
    mode_id,
    alert_time_type,
    effect_code,
    cause_name,
    cause_code,
    severity_code,
    notif_start,
    notif_end,
    created_dt,
    service_effect_text
);
SELECT * FROM alert;
