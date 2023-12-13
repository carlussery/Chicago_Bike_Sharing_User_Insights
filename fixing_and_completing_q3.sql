-- Create the table for Q3 data with columns matching that of the .csv file
CREATE TABLE q3_trips (
trip_id INT NOT NULL, 
start_time DATETIME NOT NULL, 
end_time DATETIME NOT NULL, 
bikeid INT NOT NULL, 
tripduration VARCHAR(255) NOT NULL, 
from_station_id INT NOT NULL, 
from_station_name VARCHAR(255) NOT NULL, 
to_station_id INT NOT NULL, 
to_station_name VARCHAR(255) NOT NULL, 
usertype VARCHAR(255) NOT NULL, 
gender VARCHAR(255), 
birthyear YEAR);
    
-- Load data from .csv file into table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q3.csv'
INTO TABLE q3_trips 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

    

-- Check columns and number of rows for successful execution. Number of trips should be 1640718 and...it is!
SELECT * from q3_trips
LIMIT 100;

SELECT COUNT(trip_id) AS num_of_trips
FROM q3_trips;

DESCRIBE q3_trips;
-- Next create a duplicate of the Q3 table and modify the duplicate by doing the following:
-- 1. adding four columns: period (after trip_id, value=Q3), ride_length (after end_time, value= time between end and start), day_of_week ( after ride_length, value = day of start_time), category (after day_of_week, value = day_of_week as 'Weekend' or 'Weekday')
-- 2. Removing the commas and decimals from the tripduration and changing the datatype to int. 
-- 3. If all goes well, replace the original with the duplicate and rename it to match the original 

CREATE TABLE q3_cleaned AS
SELECT * FROM q3_trips;

SELECT * FROM q3_cleaned
LIMIT 1000;

ALTER TABLE q3_cleaned
	ADD period VARCHAR(2) AFTER trip_id, 
	ADD ride_length TIME AFTER end_time,
    ADD day_of_week DATE AFTER ride_length,
    ADD category VARCHAR(7) AFTER day_of_week;
    
UPDATE q3_cleaned SET
period = 'Q3',
ride_length = end_time - start_time,
day_of_week = DAYNAME(start_time);  

ALTER TABLE q3_cleaned
MODIFY COLUMN day_of_week VARCHAR(255);

SELECT DAYNAME(start_time) AS day_of_week
FROM q3_cleaned
LIMIT 100;

UPDATE q3_cleaned SET
day_of_week  = DAYNAME(start_time);

UPDATE q3_cleaned
SET category = CASE
WHEN day_of_week = 'Saturday' OR day_of_week = 'Sunday' THEN 'Weekend'
ELSE 'Weekday'
END;

-- checking to see if the Weekend/Weekday logical statements worked. 
SELECT DISTINCT category
FROM q3_cleaned;

SELECT day_of_week, category
FROM q3_cleaned
WHERE day_of_week = 'Friday'
LIMIT 100;

-- formatting trip duration column
UPDATE q3_cleaned
SET tripduration = REPLACE(tripduration,',','');

SELECT tripduration 
FROM q3_cleaned
ORDER BY tripduration 
LIMIT 10000;

ALTER TABLE q3_cleaned
MODIFY tripduration INT UNSIGNED;

ALTER TABLE q3_trips
RENAME COLUMN tripduration TO trip_duration;

ALTER TABLE q3_trips_copy
RENAME COLUMN tripduration TO trip_duration;

-- Everything looks good. Now time to replace and make a copy 
-- WARNING --
drop table q3_trips;
-- WARNING --
RENAME TABLE q3_cleaned TO q3_trips;

CREATE TABLE q3_trips_copy AS
SELECT * FROM q3_trips;

SELECT*
FROM q3_trips_copy;

-- and we're back on track. Detour over :)
