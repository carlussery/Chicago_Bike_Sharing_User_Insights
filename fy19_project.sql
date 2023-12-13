-- Ok, we need to create the database (or schema) for our full year analysis
CREATE DATABASE FY19_bikes
USE FY19_bikes;
-- Now, we need to create the tables into which we will import our data from the .csv files. We will set all datatypes to varchar and then change them later when we clean in SQL.
CREATE TABLE q1_trips (trip_id varchar(200), period varchar(200), start_time varchar(200), end_time varchar(200), 
	ride_length varchar(200), day_of_week varchar(200), category varchar(200), bikeid varchar(200), trip_duration varchar(200), from_station_id varchar(200), from_station_name varchar(200),
    to_station_id varchar(200), to_station_name varchar(200), usertype varchar(200), gender varchar(200), birth_year varchar(200));
    
CREATE TABLE q2_trips (trip_id varchar(200), period varchar(200), start_time varchar(200), end_time varchar(200), 
	ride_length varchar(200), day_of_week varchar(200), category varchar(200), bikeid varchar(200), trip_duration varchar(200), from_station_id varchar(200), from_station_name varchar(200),
    to_station_id varchar(200), to_station_name varchar(200), usertype varchar(200), gender varchar(200), birth_year varchar(200));
    
CREATE TABLE q3_trips (trip_id varchar(200), period varchar(200), start_time varchar(200), end_time varchar(200), 
	ride_length varchar(200), day_of_week varchar(200), category varchar(200), bikeid varchar(200), trip_duration varchar(200), from_station_id varchar(200), from_station_name varchar(200),
    to_station_id varchar(200), to_station_name varchar(200), usertype varchar(200), gender varchar(200), birth_year varchar(200));
    
CREATE TABLE q4_trips (trip_id varchar(200), period varchar(200), start_time varchar(200), end_time varchar(200), 
	ride_length varchar(200), day_of_week varchar(200), category varchar(200), bikeid varchar(200), trip_duration varchar(200), from_station_id varchar(200), from_station_name varchar(200),
    to_station_id varchar(200), to_station_name varchar(200), usertype varchar(200), gender varchar(200), birth_year varchar(200));
    
-- Table columns look good. Now, let's insert the data into the table. 	
SET autocommit=0;    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q1_Cleaned.csv'
INTO TABLE q1_trips FIELDS TERMINATED BY ','
IGNORE 1 LINES;
COMMIT;  

SET autocommit=0;    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q2_Cleaned.csv'
INTO TABLE q2_trips FIELDS TERMINATED BY ','
IGNORE 1 LINES;
COMMIT;  

SET autocommit=0;    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q3_Cleaned.csv'
INTO TABLE q3_trips FIELDS TERMINATED BY ','
IGNORE 1 LINES;
COMMIT;  

SET autocommit=0;    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q4_Cleaned.csv'
INTO TABLE q4_trips FIELDS TERMINATED BY ','
IGNORE 1 LINES;
COMMIT;    

-- I had trouble doing this but the solution required me to a) move the files to the secure_file_priv location and change the forward slashed to back slashes. b) reformat a column on the .csv file to remove decimals 
-- from the whole numbers and c) resolve the slow speed of import by turning off the autocommit permanently. All files and all rows have been successfully imported (after three agonizing days of trying!!).
-- The plan from here on out is to a) inspect, clean, and format b) combine the files and c) perform full year analysis and calculations. 

-- Inspect the data: Check for duplicates. The only unique identifyer in our dataset is the trip id from the trip_id columns of each table.
SELECT 
c1.q1_count, c1.q1_dist, c2.q2_count, c2.q2_dist, c3.q3_count, c3.q3_dist, c4.q4_count, c4.q4_dist
FROM
	(SELECT COUNT(trip_id) AS q1_count, COUNT(DISTINCT trip_id) AS q1_dist FROM q1_trips) AS c1,
    (SELECT COUNT(trip_id) AS q2_count, COUNT(DISTINCT trip_id) AS q2_dist FROM q2_trips) AS c2,
	(SELECT COUNT(trip_id) AS q3_count, COUNT(DISTINCT trip_id) AS q3_dist FROM q3_trips) AS c3,
    (SELECT COUNT(trip_id) AS q4_count, COUNT(DISTINCT trip_id) AS q4_dist FROM q4_trips) AS c4;
    
-- No duplicates found. Next check and, if necessary, clean string characters and their length for columns with an expected output length.
SELECT
LENGTH(trip_id),LENGTH(period),LENGTH(start_time),LENGTH(end_time),
LENGTH(ride_length),LENGTH(day_of_week),LENGTH(category),LENGTH(usertype),
LENGTH(gender),LENGTH(birth_year)
FROM q1_trips;   

 SELECT
LENGTH(trip_id),LENGTH(period),LENGTH(start_time),LENGTH(end_time),
LENGTH(ride_length),LENGTH(day_of_week),LENGTH(category),LENGTH(usertype),
LENGTH(gender),LENGTH(birth_year)
FROM q2_trips; 

SELECT
LENGTH(trip_id),LENGTH(period),LENGTH(start_time),LENGTH(end_time),
LENGTH(ride_length),LENGTH(day_of_week),LENGTH(category),LENGTH(usertype),
LENGTH(gender),LENGTH(birth_year)
FROM q3_trips; 

SELECT
LENGTH(trip_id),LENGTH(period),LENGTH(start_time),LENGTH(end_time),
LENGTH(ride_length),LENGTH(day_of_week),LENGTH(category),LENGTH(usertype),
LENGTH(gender),LENGTH(birth_year)
FROM q4_trips; 

-- birth_year is showing 5 characters when it's supposed to be 4 (or 1 for the nulls). Let's change this cautiously by adding a column, copying the data over, testing, then replacing.  
ALTER TABLE q1_trips
ADD trimmed_by varchar(4) AFTER birth_year;
UPDATE q1_trips
SET trimmed_by = birth_year;

SELECT LENGTH(birth_year), LENGTH(trimmed_by)
FROM q1_trips;

ALTER TABLE q1_trips
DROP birth_year;

ALTER TABLE q1_trips
RENAME COLUMN trimmed_by TO birth_year;

SELECT LENGTH(birth_year)
FROM q1_trips;
-- Q2
ALTER TABLE q2_trips
ADD trimmed_by varchar(4) AFTER birth_year;

SET autocommit=0;
UPDATE q2_trips
SET trimmed_by = birth_year;
COMMIT;

SELECT LENGTH(birth_year), LENGTH(trimmed_by)
FROM q2_trips;

ALTER TABLE q2_trips
DROP birth_year;

ALTER TABLE q2_trips
RENAME COLUMN trimmed_by TO birth_year;

SELECT LENGTH(birth_year)
FROM q2_trips;
-- Q3
ALTER TABLE q3_trips
ADD trimmed_by varchar(4) AFTER birth_year;

UPDATE q3_trips
SET trimmed_by = birth_year;

SELECT LENGTH(birth_year), LENGTH(trimmed_by)
FROM q3_trips;

ALTER TABLE q3_trips
DROP birth_year;

ALTER TABLE q3_trips
RENAME COLUMN trimmed_by TO birth_year;

SELECT LENGTH(birth_year)
FROM q3_trips;
-- Q4
ALTER TABLE q4_trips
ADD trimmed_by varchar(4) AFTER birth_year;

UPDATE q4_trips
SET trimmed_by = birth_year;

SELECT LENGTH(birth_year), LENGTH(trimmed_by)
FROM q4_trips;

ALTER TABLE q4_trips
DROP birth_year;

ALTER TABLE q4_trips
RENAME COLUMN trimmed_by TO birth_year;

SELECT LENGTH(birth_year)
FROM q4_trips;
-- Next, it's time to format (or typecast) these columns for calculation. First, let's see what we're working with:
DESCRIBE q1_trips;
DESCRIBE q2_trips;
DESCRIBE q3_trips;
DESCRIBE q4_trips;

-- Everything is a variable character string. Cool. Everything can stay as such except the following (changed to the following): trip_id(int), start_time & end_time(datetime)
-- ride_length(time), trip_duration (int) and birth_year (year).  As formatting can cause unwanted changes, it's best if we first duplicate the original tables then make changes on the duplicates
-- instead of the originals. After we finish our analysis job, we could always drop the duplicate tables as a housecleaning measure.  

CREATE TABLE q1_trips_copy AS
SELECT *
FROM q1_trips;

DESCRIBE q1_trips_copy;
EXPLAIN SELECT* FROM q1_trips;
EXPLAIN SELECT* FROM q1_trips_copy;
-- Q2
CREATE TABLE q2_trips_copy AS
SELECT *
FROM q2_trips;

DESCRIBE q2_trips_copy;
EXPLAIN SELECT* FROM q2_trips;
EXPLAIN SELECT* FROM q2_trips_copy;
-- Q3
CREATE TABLE q3_trips_copy AS
SELECT *
FROM q3_trips;

DESCRIBE q3_trips_copy;
EXPLAIN SELECT* FROM q3_trips;
EXPLAIN SELECT* FROM q3_trips_copy;
-- Q4
CREATE TABLE q4_trips_copy AS
SELECT *
FROM q4_trips;

DESCRIBE q4_trips_copy;
EXPLAIN SELECT* FROM q4_trips;
EXPLAIN SELECT* FROM q4_trips_copy;

-- I'm getting an error while attempting to change the time columns to datetime formats. I need to format the text first and then I can modify the datatype. 

UPDATE q1_trips_copy
SET start_time = STR_TO_DATE(start_time, '%m/%d/%Y %T');
UPDATE q1_trips_copy
SET end_time = STR_TO_DATE(end_time, '%m/%d/%Y %T');

ALTER TABLE q1_trips_copy
	MODIFY COLUMN trip_id INT,
    MODIFY COLUMN start_time DATETIME,
    MODIFY COLUMN end_time DATETIME,
    MODIFY COLUMN ride_length TIME,
    MODIFY COLUMN trip_duration INT,
    MODIFY COLUMN birth_year YEAR;
-- Q2
UPDATE q2_trips_copy
SET start_time = STR_TO_DATE(start_time, '%m/%d/%Y %T');
UPDATE q2_trips_copy
SET end_time = STR_TO_DATE(end_time, '%m/%d/%Y %T');

ALTER TABLE q2_trips_copy
	MODIFY COLUMN trip_id INT,
    MODIFY COLUMN start_time DATETIME,
    MODIFY COLUMN end_time DATETIME,
    MODIFY COLUMN ride_length TIME,
    MODIFY COLUMN trip_duration INT,
    MODIFY COLUMN birth_year YEAR;
-- Q3
UPDATE q3_trips_copy
SET start_time = STR_TO_DATE(start_time, '%m/%d/%Y %T');
UPDATE q3_trips_copy
SET end_time = STR_TO_DATE(end_time, '%m/%d/%Y %T');

ALTER TABLE q3_trips_copy
	MODIFY COLUMN trip_id INT,
    MODIFY COLUMN start_time DATETIME,
    MODIFY COLUMN end_time DATETIME,
    MODIFY COLUMN ride_length TIME,
    MODIFY COLUMN trip_duration INT,
    MODIFY COLUMN birth_year YEAR;
-- Q4
UPDATE q4_trips_copy
SET start_time = STR_TO_DATE(start_time, '%m/%d/%Y %T');
UPDATE q4_trips_copy
SET end_time = STR_TO_DATE(end_time, '%m/%d/%Y %T');

ALTER TABLE q4_trips_copy
	MODIFY COLUMN trip_id INT,
    MODIFY COLUMN start_time DATETIME,
    MODIFY COLUMN end_time DATETIME,
    MODIFY COLUMN ride_length TIME,
    MODIFY COLUMN trip_duration INT,
    MODIFY COLUMN birth_year YEAR;
 
 -- Great, Now it's time to combine the 4 quarters into a full year. But, we don't need all of the data from all of the tables. We just need the data relevant to our business question: how do
 -- casual riders (usertype = customer) use the service differently from annual members (usertype = subscribers)? Instead of going deep down the rabbit hole, we will limit our observations to time and duration. 
 -- This means we only need the following columns: trip_id (to count # of trips and keep everyting in sequential order), period (to track time by quarter), start_time (to track time by month and keep everything in sequential order)
 -- ride_length (measure duration), day_of_week (track time by day of week, duh!), category (track time of week), trip_duration (to cross check duration), and usertype (who's who). Let's build!
 
CREATE TABLE fy19_usage
	SELECT trip_id, period, start_time, ride_length, day_of_week, category, trip_duration, usertype
	FROM q1_trips_copy
	UNION ALL
	SELECT trip_id, period, start_time, ride_length, day_of_week, category, trip_duration, usertype
	FROM q2_trips_copy
	UNION ALL
	SELECT trip_id, period, start_time, ride_length, day_of_week, category, trip_duration, usertype
	FROM q3_trips_copy
	UNION ALL
	SELECT trip_id, period, start_time, ride_length, day_of_week, category, trip_duration, usertype
	FROM q4_trips_copy;
    
    -- Let's check our new combined table with full year results. Let's see if we have all 4 quarters, all 12 months, the first date on jan 1st and the last date on dec 31st. 
    
    SELECT 
		COUNT(DISTINCT period) AS no_of_periods,
        COUNT(DISTINCT MONTH(start_time)) AS no_of_months,
        MIN(start_time) AS first_day,
        MAX(start_time) AS last_day
	FROM fy19_usage;
    -- There is an issue here. It's showing a count of 3 for quarters and 11 for months. However, the first and last days are correct. Which quarter is missing and which month is missing?
    SELECT DISTINCT period
    FROM fy19_usage;
    
    SELECT DISTINCT MONTHNAME(start_time)
    FROM fy19_usage;
    -- Q4 is missing but, the Q4 table's information has been merged. The issue is that the period column for q4_trips_copy erronously had the value Q3. I used the update and set functions to change them. Now to update the
    -- merged full year file, I could update it with with a where clause or I could just drop the table and re-run the query to re-create the table since the merged files have been changed. As for the months, September is missing.
    -- Big problem: Q3 data was too large for Excel and thus didn't load completely (the journey of these files went from original .csv -> cleaning and formating in Excel -> loading into SQL for analysis. 
    -- The Q3 dataset is incomplete so,please wait while I load the orginal in sql, clean it and format it in SQL, and put it in the place of the incomplete dataset....OK, done! Let's drop the fy19 table and recreate it.
    SELECT DISTINCT MONTHNAME(start_time), period
    FROM fy19_usage;
    -- And we have our full year dataset. Let's analyze. First, let's create a temporary table with the summary of our data. We want to know the following: min ride lenght, max ride length, avg ride length, most popular day of week,
    -- number of rides under 1 hr, number of rides 1h or more, total number of rides. Then, we can export our table as a .csv
    
		SELECT 
			MIN(SEC_TO_TIME(trip_duration)) AS min_ride_length, MAX(FLOOR(trip_duration/3600)) AS max_ride_length_hrs, 
			SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_ride_length, 'Tuesday' AS top_day, 'August' AS top_month, 'Q3' AS top_quarter, 
            SUM(CASE WHEN trip_duration <3600 THEN 1 ELSE 0 END) AS rides_under_1hr, ROUND((SUM(CASE WHEN trip_duration <3600 THEN 1 ELSE 0 END)/COUNT(trip_id) * 100),2) AS percent_of_total,
			SUM(CASE WHEN trip_duration >=3600 THEN 1 ELSE 0 END) AS rides_1hr_or_more, ROUND((SUM(CASE WHEN trip_duration >=3600 THEN 1 ELSE 0 END)/COUNT(trip_id) * 100),2) AS percent_of_total,
            COUNT(trip_id) AS total_rides
		FROM fy19_usage; -- This is a raw summary
    -- Here is a summary filtered for rides under 1hr. The Tuesday, August, and Q3 are still the top day, month, and quarter respectively. 
    SELECT 
			MIN(SEC_TO_TIME(trip_duration)) AS min_ride_length, MAX(SEC_TO_TIME(trip_duration)) AS max_ride_length, 
			SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_ride_length, 'Tuesday' AS top_day, 'August' AS top_month, 'Q3' AS top_quarter, 
            SUM(CASE WHEN trip_duration <3600 THEN 1 ELSE 0 END) AS rides_under_1hr, ROUND((SUM(CASE WHEN trip_duration <3600 THEN 1 ELSE 0 END)/COUNT(trip_id) * 100),2) AS percent_of_total,
			SUM(CASE WHEN trip_duration >=3600 THEN 1 ELSE 0 END) AS rides_1hr_or_more, ROUND((SUM(CASE WHEN trip_duration >=3600 THEN 1 ELSE 0 END)/COUNT(trip_id) * 100),2) AS percent_of_total,
            COUNT(trip_id) AS total_rides
		FROM fy19_usage
        WHERE trip_duration < 3600;
        
        -- Avg ride length per user, raw and filtered
CREATE TEMPORARY TABLE raw_vs_filtered
	SELECT
		usertype, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_length_raw,
		COUNT(trip_id) AS total_rides_raw 
	FROM fy19_usage
	GROUP BY usertype;

CREATE TEMPORARY TABLE filtered    
SELECT
usertype, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_length_filtered,  COUNT(trip_id) AS total_rides_filtered
FROM fy19_usage 
WHERE trip_duration < 3600
GROUP BY usertype;   
    
    SELECT * FROM raw_vs_filtered;
    SELECT * FROM filtered;
    
    SELECT r.usertype, r.avg_length_raw, f.avg_length_filtered, r.total_rides_raw, f.total_rides_filtered
    FROM raw_vs_filtered r
    JOIN filtered f ON r.usertype = f.usertype; -- here is the output
    
-- Average ride length and total rides per day per customer, filtered for rides under 1 hour
CREATE TEMPORARY TABLE length_cust_days
	SELECT day_of_week, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_customer_length,  COUNT(trip_id) AS total_customer_rides
	FROM fy19_usage 
	WHERE usertype = 'Customer' AND trip_duration <3600
	GROUP BY day_of_week;
    
CREATE TEMPORARY TABLE length_subs_days
	SELECT day_of_week, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_subscriber_length,  COUNT(trip_id) AS total_subscriber_rides
	FROM fy19_usage 
	WHERE usertype = 'Subscriber' AND trip_duration <3600
	GROUP BY day_of_week;

SELECT c.day_of_week, c.avg_customer_length, c.total_customer_rides, s.avg_subscriber_length, s.total_subscriber_rides
FROM length_cust_days c 
JOIN length_subs_days s ON c.day_of_week = s.day_of_week; -- here is the export

-- Average ride length and total rides per month per customer, filtered for rides under 1 hour
CREATE TEMPORARY TABLE length_cust_months
	SELECT MONTHNAME(start_time) AS fy19_month, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_customer_length,  COUNT(trip_id) AS num_customer_rides
	FROM fy19_usage 
	WHERE usertype = 'Customer' AND trip_duration <3600
	GROUP BY MONTHNAME(start_time)
    ORDER BY start_time; 
    
CREATE TEMPORARY TABLE length_subs_months
	SELECT MONTHNAME(start_time) AS fy19_month, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_subscriber_length,  COUNT(trip_id) AS num_subscriber_rides
	FROM fy19_usage 
	WHERE usertype = 'Subscriber' AND trip_duration <3600
	GROUP BY MONTHNAME(start_time)
    ORDER BY start_time;
    
   SELECT c.fy19_month, c.avg_customer_length, c.num_customer_rides, s.avg_subscriber_length, s.num_subscriber_rides
   FROM length_cust_months c 
   JOIN length_subs_months s ON c.fy19_month  = s.fy19_month; -- here is the export
   
 -- Average ride length and total rides per quarter per customer, filtered for rides under 1 hour
CREATE TEMPORARY TABLE length_cust_quarters
	SELECT period, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_customer_length,  COUNT(trip_id) AS num_customer_rides
	FROM fy19_usage 
	WHERE usertype = 'Customer' AND trip_duration <3600
	GROUP BY period
    ORDER BY period; 
    
CREATE TEMPORARY TABLE length_subs_quarters
	SELECT period, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_subscriber_length,  COUNT(trip_id) AS num_subscriber_rides
	FROM fy19_usage 
	WHERE usertype = 'Subscriber' AND trip_duration <3600
	GROUP BY period
    ORDER BY period; 
    
   SELECT c.period, c.avg_customer_length, c.num_customer_rides, s.avg_subscriber_length, s.num_subscriber_rides
   FROM length_cust_quarters c 
   JOIN length_subs_quarters s ON c.period  = s.period; -- here is the export
   
   -- And that's the end of this SeQueL. I'll save and export my scripts. 


    
   
