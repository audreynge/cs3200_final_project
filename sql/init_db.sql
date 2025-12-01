DROP DATABASE IF EXISTS mbta;
CREATE DATABASE mbta;
USE mbta;

DROP TABLE IF EXISTS rail_ridership;
-- create rail ridership
CREATE TABLE rail_ridership (
	object_id INT,
    mode VARCHAR(50),
    season VARCHAR(50),
    route_id VARCHAR(50),
    route_name VARCHAR(100),
    direction_id INT,
    direction VARCHAR(20),
    day_type_id VARCHAR(50),
    day_type_name VARCHAR(50),
    time_period_id VARCHAR(50),
    time_period_name VARCHAR(100),
    stop_name VARCHAR(255),
    stop_id VARCHAR(50),
    total_ons INT,
    total_offs INT,
    number_service_days INT,
    average_ons INT,
    average_offs INT,
    average_flow INT);
    
-- load rail ridership
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/rail_ridership.csv'
INTO TABLE rail_ridership
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES(
    mode,
    season,
    route_id,
    route_name,
    direction_id,
    day_type_id,
    day_type_name,
    time_period_id,
    time_period_name,
    stop_name,
    stop_id,
    total_ons,
    total_offs,
    number_service_days,
    average_ons,
    average_offs,
    average_flow,
    object_id)
SET direction = CASE WHEN direction_id = 0 THEN 'Inbound' ELSE 'Outbound' END;
-- add primary key
ALTER TABLE rail_ridership
ADD rr_id INT PRIMARY KEY AUTO_INCREMENT;
-- check correctness 
SELECT * from rail_ridership;


DROP TABLE IF EXISTS neighborhood_income;
-- income by neighborhood
CREATE TABLE neighborhood_income (
    neighborhood VARCHAR(100),
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
    pct_150000_plus DECIMAL);

-- load neighborhood income
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/boston_neighborhood_income.csv'
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
-- add primary key
ALTER TABLE neighborhood_income
ADD neighborhood_id INT PRIMARY KEY AUTO_INCREMENT;
-- check
SELECT * FROM neighborhood_income;


DROP TABLE IF EXISTS stop_neighborhood;
CREATE TABLE stop_neighborhood (
    stop_id VARCHAR(50) PRIMARY KEY,
    stop_name VARCHAR(255),
    neighborhood_name VARCHAR(100));

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stop_neighborhood.csv'
INTO TABLE stop_neighborhood
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(stop_id, stop_name, neighborhood_name);
-- check
SELECT * FROM stop_neighborhood;


DROP TABLE IF EXISTS bus_ridership;
-- create bus table
CREATE TABLE bus_ridership (
    mode VARCHAR(50),
    season VARCHAR(50),
    route_id VARCHAR(50),
    route_name VARCHAR(100),
    route_variant VARCHAR(50),
    stop_sequence INT,
    direction_id VARCHAR(50),
    day_type_id VARCHAR(50),
    day_type_name VARCHAR(50),
    time_period_id VARCHAR(50),
    time_period_name VARCHAR(100),
    stop_name VARCHAR(255),
    stop_id VARCHAR(50),
    average_ons DECIMAL,
    average_offs DECIMAL,
    average_load DECIMAL,
    num_trips INT,
    ons_all_trips DECIMAL,
    object_id INT );

-- load bus data
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bus_ridership.csv'
INTO TABLE bus_ridership
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES(
	mode,
    season,
    route_id,
    route_name,
    route_variant,
    stop_sequence,
    direction_id,
    day_type_id,
    day_type_name,
    time_period_id,
    time_period_name,
    stop_name,
    stop_id,
    average_ons,
    average_offs,
    average_load,
    num_trips,
    ons_all_trips,
    object_id);
-- add primary key
ALTER TABLE bus_ridership
ADD bus_id INT PRIMARY KEY AUTO_INCREMENT;


DROP TABLE IF EXISTS directions;
CREATE TABLE directions (
direction_id INT PRIMARY KEY,
direction_name VARCHAR(20)
);

INSERT INTO directions (direction_id, direction_name) VALUES
(0, 'Inbound'),
(1, 'Outbound');
-- check
SELECT * FROM directions;

DROP TABLE IF EXISTS line_info;
CREATE TABLE line_info (
    line_id INT PRIMARY KEY AUTO_INCREMENT,
    line_name VARCHAR(50),
    color VARCHAR(20),
    mode VARCHAR(50)
);

INSERT INTO line_info (line_name, color, mode)
VALUES
('Red Line', 'Red', 'Rapid Transit'),
('Orange Line', 'Orange', 'Rapid Transit'),
('Blue Line', 'Blue', 'Rapid Transit'),
('Green Line', 'Green', 'Light Rail'),
('Green Line B', 'Green', 'Light Rail'),
('Green Line C', 'Green', 'Light Rail'),
('Green Line D', 'Green', 'Light Rail'),
('Green Line E', 'Green', 'Light Rail'),
('Mattapan Trolley', 'Red', 'Light Rail');
-- check
SELECT * FROM line_info;


DROP TABLE IF EXISTS stops;
-- create stops
CREATE TABLE stops (
    x DOUBLE,
    y DOUBLE,
    objectid INT,
    stop_id VARCHAR(100),
    stop_code VARCHAR(100),
    stop_name VARCHAR(255),
    stop_desc TEXT,
    platform_code VARCHAR(100),
    platform_name VARCHAR(255),
    stop_lat DOUBLE,
    stop_lon DOUBLE,
    zone_id VARCHAR(50),
    stop_address VARCHAR(255),
    stop_url VARCHAR(255),
    level_id VARCHAR(50),
    location_type VARCHAR(50),
    parent_station VARCHAR(100),
    wheelchair_boarding VARCHAR(10),
    municipality VARCHAR(100),
    on_street VARCHAR(255),
    at_street VARCHAR(255),
    vehicle_type VARCHAR(100),
    sidewalk_width_ft VARCHAR(50),
    accessibility_score VARCHAR(50),
    sidewalk_condition VARCHAR(100),
    sidewalk_material VARCHAR(100),
    current_shelter VARCHAR(255),
    routes TEXT,
    municipality_1 VARCHAR(100),
    neighborhood VARCHAR(100),
    created_user VARCHAR(100),
    created_date VARCHAR(50),
    last_edited_user VARCHAR(100),
    last_edited_date VARCHAR(50));
-- load stops
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Rapid_Transit_Stops.csv'
INTO TABLE stops
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES(
	x,
    y,
    objectid,
    stop_id,
    stop_code,
    stop_name,
    stop_desc,
    platform_code,
    platform_name,
    stop_lat,
    stop_lon,
    zone_id,
    stop_address,
    stop_url,
    level_id,
    location_type,
    parent_station,
    wheelchair_boarding,
    municipality,
    on_street,
    at_street,
    vehicle_type,
    sidewalk_width_ft,
    accessibility_score,
    sidewalk_condition,
    sidewalk_material,
    current_shelter,
    routes,
    municipality_1,
    neighborhood,
    created_user,
    created_date,
    last_edited_user,
    last_edited_date);
-- add primary key
ALTER TABLE stops
ADD COLUMN stop_id_pk INT AUTO_INCREMENT PRIMARY KEY;
-- check
SELECT * FROM stops;


DROP TABLE IF EXISTS stop_line;
CREATE TABLE stop_line (
    id INT AUTO_INCREMENT PRIMARY KEY,
    stop_id_pk INT,
    line_id INT,
    FOREIGN KEY (stop_id_pk) REFERENCES stops(stop_id_pk),
    FOREIGN KEY (line_id) REFERENCES line_info(line_id)
);
INSERT INTO stop_line (stop_id_pk, line_id)
SELECT DISTINCT s.stop_id_pk, l.line_id
FROM rail_ridership rr
JOIN stops s ON rr.stop_id = s.stop_id
JOIN line_info l ON rr.route_name = l.line_name;
-- check
SELECT * FROM stop_line;

-- load alerts
DROP TABLE IF EXISTS alerts;
CREATE TABLE alerts (
    alert_id            INT PRIMARY KEY,
    gui_mode_name       VARCHAR(100) NULL,
    alert_time_type     VARCHAR(50) NULL,
    effect_name         VARCHAR(100) NULL,
    effect_code         VARCHAR(50) NULL,
    cause_name          VARCHAR(100) NULL,
    cause_code          VARCHAR(50) NULL,
    affent_list         VARCHAR(500) NULL,
    severity_name       VARCHAR(100) NULL,
    severity_code       INT NULL,
    header              TEXT NULL,
    details             TEXT NULL,
    url                 VARCHAR(500) NULL,
    notif_start         TIMESTAMP NULL,
    notif_end           TIMESTAMP NULL,
    created_dt          TIMESTAMP NULL,
    last_modified_dt    TIMESTAMP NULL,
    closed_dt           TIMESTAMP NULL,
    alert_lifecycle     VARCHAR(50) NULL,
    color               VARCHAR(50) NULL,
    service_effect_text TEXT NULL,
    short_header        TEXT NULL,
    timeframe_text      VARCHAR(200) NULL,
    ObjectId            INT NULL
);

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/MBTA_Service_Alerts.csv'
INTO TABLE alerts
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    alert_id,
    gui_mode_name,
    alert_time_type,
    effect_name,
    effect_code,
    cause_name,
    cause_code,
    affent_list,
    severity_name,
    severity_code,
    header,
    details,
    url,
    notif_start,
    notif_end,
    created_dt,
    last_modified_dt,
    closed_dt,
    alert_lifecycle,
    color,
    service_effect_text,
    short_header,
    timeframe_text,
    ObjectId
);

CREATE TABLE neighborhood_mapping (
    raw_name VARCHAR(100) PRIMARY KEY,
    income_name VARCHAR(100)
);

INSERT INTO neighborhood_mapping (raw_name, income_name)
SELECT DISTINCT neighborhood_name, NULL
FROM stop_neighborhood;

UPDATE neighborhood_mapping
SET income_name = raw_name
WHERE raw_name IN (
    'Allston', 'Back Bay', 'Beacon Hill', 'Boston', 'Brighton',
    'Charlestown', 'Chinatown', 'Dorchester', 'Downtown', 'East Boston',
    'Fenway', 'Hyde Park', 'Jamaica Plain', 'Longwood', 'Mattapan',
    'Mission Hill', 'North End', 'Roslindale', 'Roxbury',
    'South Boston', 'South Boston Waterfront', 'South End',
    'West End', 'West Roxbury'
);

UPDATE neighborhood_mapping
SET income_name = 'South End'
WHERE raw_name = 'Bay Village';

UPDATE neighborhood_mapping
SET income_name = 'Downtown'
WHERE raw_name = 'Leather District';

-- Harbor Islands has no population leave as NULL
UPDATE neighborhood_mapping
SET income_name = NULL
WHERE raw_name = 'Harbor Islands';

