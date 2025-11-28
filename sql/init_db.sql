DROP DATABASE IF EXISTS mbta;
CREATE DATABASE mbta;
USE mbta;
DROP TABLE IF EXISTS rail_ridership;

-- create rail ridership
CREATE TABLE rail_ridership (
	object_id INT PRIMARY KEY,
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

-- check correctness 
SELECT * from rail_ridership;

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
    pct_150000_plus DECIMAL);

-- load neighborhood income
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/boston neighborhood income - Sheet1.csv'
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
select * from neighborhood_income;

-- create stops
CREATE TABLE stops (
    x DOUBLE,
    y DOUBLE,
    objectid INT PRIMARY KEY,
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
select * from stops;

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

select * from stop_neighborhood;

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
    object_id INT PRIMARY KEY);

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
