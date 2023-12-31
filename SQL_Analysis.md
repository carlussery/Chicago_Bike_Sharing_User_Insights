# Cleaning, Merging, and Analysis in SQL

### Environment: MySQL Workbench

### Step 1: Create a database
Ok, we need to create the database (or schema) for our full year analysis
```sql
CREATE DATABASE FY19_bikes
USE FY19_bikes;
```

### Step 2: Create structures for our tables
Now, we need to create the tables into which we will import our data from the .csv files. We will set all datatypes to varchar and then change them later when we clean in SQL. The queries are as follows:
```sql
CREATE TABLE q1_trips (
  trip_id varchar(200), period varchar(200),
  start_time varchar(200), end_time varchar(200),
  ride_length varchar(200), day_of_week varchar(200),
  category varchar(200), bikeid varchar(200),
  trip_duration varchar(200), from_station_id varchar(200),
  from_station_name varchar(200),to_station_id varchar(200),
  to_station_name varchar(200),usertype varchar(200),
  gender varchar(200), birth_year varchar(200));
 ```
```sql   
CREATE TABLE q2_trips (
  trip_id varchar(200), period varchar(200),
  start_time varchar(200), end_time varchar(200),
  ride_length varchar(200), day_of_week varchar(200),
  category varchar(200), bikeid varchar(200),
  trip_duration varchar(200), from_station_id varchar(200),
  from_station_name varchar(200), to_station_id varchar(200),
  to_station_name varchar(200), usertype varchar(200),
  gender varchar(200), birth_year varchar(200));
```
```sql    
CREATE TABLE q3_trips (
  trip_id varchar(200), period varchar(200),
  start_time varchar(200), end_time varchar(200),
  ride_length varchar(200), day_of_week varchar(200),
  category varchar(200), bikeid varchar(200),
  trip_duration varchar(200), from_station_id varchar(200),
  from_station_name varchar(200), to_station_id varchar(200),
  to_station_name varchar(200), usertype varchar(200),
  gender varchar(200), birth_year varchar(200));
```
```sql    
CREATE TABLE q4_trips (
  trip_id varchar(200), period varchar(200),
  start_time varchar(200), end_time varchar(200), 
	ride_length varchar(200), day_of_week varchar(200),
  category varchar(200), bikeid varchar(200),
  trip_duration varchar(200), from_station_id varchar(200),
  from_station_name varchar(200), to_station_id varchar(200),
  to_station_name varchar(200), usertype varchar(200),
  gender varchar(200), birth_year varchar(200));
```
Output: Table columns look good.

### Step 3: Load/Insert data from .csv files into our tables
Now, let's insert the data into the table using the following queries: 
```sql
SET autocommit=0;    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q1_Cleaned.csv'
INTO TABLE q1_trips FIELDS TERMINATED BY ','
IGNORE 1 LINES;
COMMIT;  
```
```sql
SET autocommit=0;    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q2_Cleaned.csv'
INTO TABLE q2_trips FIELDS TERMINATED BY ','
IGNORE 1 LINES;
COMMIT;  
```
```sql
SET autocommit=0;    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q3_Cleaned.csv'
INTO TABLE q3_trips FIELDS TERMINATED BY ','
IGNORE 1 LINES;
COMMIT;  
```
```sql
SET autocommit=0;    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q4_Cleaned.csv'
INTO TABLE q4_trips FIELDS TERMINATED BY ','
IGNORE 1 LINES;
COMMIT;    
```
In all honesty, I did have trouble doing this but the solution required me to a) move the files to the `secure_file_priv` location and change the forward slashed to back slashes. b) reformat a column on the .csv file to remove decimals from the whole numbers and 
c) resolve the slow speed of import by turning off the autocommit permanently. All files and all rows have been successfully imported (after three agonizing days of trying!!).
The plan from here on out is to a) inspect, clean, and format b) combine the files and c) perform full year analysis and calculations. 

### Step 4: Inspect and clean the data 
#### 4a: Check for duplicates. 
The only unique identifyer in our dataset is the trip id number from the `trip_id` columns of each table. Since each trip has one unique id number, we will check for duplicate rows using the the trip id number. The query is as follows:
```sql
SELECT 
c1.q1_count, c1.q1_dist, c2.q2_count, c2.q2_dist, c3.q3_count, c3.q3_dist, c4.q4_count, c4.q4_dist
FROM
(SELECT COUNT(trip_id) AS q1_count, COUNT(DISTINCT trip_id) AS q1_dist FROM q1_trips) AS c1,
(SELECT COUNT(trip_id) AS q2_count, COUNT(DISTINCT trip_id) AS q2_dist FROM q2_trips) AS c2,
(SELECT COUNT(trip_id) AS q3_count, COUNT(DISTINCT trip_id) AS q3_dist FROM q3_trips) AS c3,
(SELECT COUNT(trip_id) AS q4_count, COUNT(DISTINCT trip_id) AS q4_dist FROM q4_trips) AS c4;
```    
Output: No duplicates found. 

#### 4b: Check string length for consistency
Next check and, if necessary, clean string characters and their length for columns with an expected output length. Here are the queries:
```sql
SELECT
LENGTH(trip_id),LENGTH(period),LENGTH(start_time),LENGTH(end_time),
LENGTH(ride_length),LENGTH(day_of_week),LENGTH(category),LENGTH(usertype),
LENGTH(gender),LENGTH(birth_year)
FROM q1_trips;   
```
```sql
 SELECT
LENGTH(trip_id),LENGTH(period),LENGTH(start_time),LENGTH(end_time),
LENGTH(ride_length),LENGTH(day_of_week),LENGTH(category),LENGTH(usertype),
LENGTH(gender),LENGTH(birth_year)
FROM q2_trips; 
```
```sql
SELECT
LENGTH(trip_id),LENGTH(period),LENGTH(start_time),LENGTH(end_time),
LENGTH(ride_length),LENGTH(day_of_week),LENGTH(category),LENGTH(usertype),
LENGTH(gender),LENGTH(birth_year)
FROM q3_trips; 
```
```sql
SELECT
LENGTH(trip_id),LENGTH(period),LENGTH(start_time),LENGTH(end_time),
LENGTH(ride_length),LENGTH(day_of_week),LENGTH(category),LENGTH(usertype),
LENGTH(gender),LENGTH(birth_year)
FROM q4_trips; 
```
Output results: `birth_year` is showing 5 characters when it's supposed to be 4 (or 1 for the nulls). Let's change this cautiously by adding a column, copying the data over, testing, then replacing using the following queries: 
```sql
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
```
Q2
```sql
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
```
Q3
```sql
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
```
Q4
```sql
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
```
Output: The string length in the `birth_year` column is 4 characters as expected.

### Step 5: Format data for analysis 

Next, it's time to format (or typecast) these columns for calculation. First, let's see what we're working with by running a query that tells us the datatype of each column:
```sql
DESCRIBE q1_trips;
DESCRIBE q2_trips;
DESCRIBE q3_trips;
DESCRIBE q4_trips;
```
Output: Everything is a variable character string or `varchar()`. Cool. Everything can stay as such except the following: 
- `trip_id` should be changed to an `int`
- `start_time` & `end_time` should be changed to a `datetime`
- `ride_length` should be formatted as a duration and thus changed to a `time`
-  'trip_duration' is measured in number of seconds and thus should be an `int`
-  `birth_year` should be changed to a `year`.

#### 5a: Back up before moving forward!
 **Important:** As formatting can cause unwanted changes, it's best if we first duplicate the original tables then make changes on the duplicates instead of the originals. After we finish our analysis job, we could always drop the duplicate tables as a housecleaning measure. The in the following queries we 1. duplicate the tables and 2. verifiy if they match the originals: 
```sql
CREATE TABLE q1_trips_copy AS
SELECT *
FROM q1_trips;

DESCRIBE q1_trips_copy;
EXPLAIN SELECT* FROM q1_trips;
EXPLAIN SELECT* FROM q1_trips_copy;
```
Q2
```sql
CREATE TABLE q2_trips_copy AS
SELECT *
FROM q2_trips;

DESCRIBE q2_trips_copy;
EXPLAIN SELECT* FROM q2_trips;
EXPLAIN SELECT* FROM q2_trips_copy;
```
Q3
```sql
CREATE TABLE q3_trips_copy AS
SELECT *
FROM q3_trips;

DESCRIBE q3_trips_copy;
EXPLAIN SELECT* FROM q3_trips;
EXPLAIN SELECT* FROM q3_trips_copy;
```
Q4
```sql
CREATE TABLE q4_trips_copy AS
SELECT *
FROM q4_trips;

DESCRIBE q4_trips_copy;
EXPLAIN SELECT* FROM q4_trips;
EXPLAIN SELECT* FROM q4_trips_copy;
```
Output: Duplicates successfully created.
### 5b: Format text strings to match expected format of the output datatype

I'm getting an error while attempting to change the `start_time` and `end_time` columns to datetime formats. That's because I first need to tell MySQL which of these string characters represents the month, day, year, and time as well as the delimiter separating these values (for dates it's usually either a backslash `/` or a dash `-`). Only then can I subsequently modify the datatype. We run the following queries to do this:
```sql
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
```
Q2
```sql
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
```
Q3
```sql
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
```
Q4
```sql
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
 ```
Output: Column datatypes successfuly modified. 

### Step 6: Merge the four datasets for complete year 2019 analysis
Great, Now it's time to combine the 4 quarters into a full year. But, we don't need all of the data from all of the tables. We just need the data relevant to our business question: *how do
casual riders (`usertype = customer`) use the service differently from annual members (`usertype = subscribers`)?* Instead of going deep down the rabbit hole (which we could **easily** do, believe me!), we will limit our observations to time and duration for this analysis. This means we only need the following columns: 
- `trip_id` (to count # of trips and keep everyting in sequential order)
- `period` (to track time by quarter)
- `start_time` (to track time by month and keep everything in sequential order)
- `ride_length` (to measure duration)
- `day_of_week` (to track time by day of week, duh!😜)
- `category` (to track time of week i.e. weekend vs weekday)
- `trip_duration` which is measured in seconds (to cross check duration) and
- `usertype` (The who's who of customers and subscribers).

Let's build! Here's the query:
```sql 
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
  ```
Output: Table created successfully.

#### 6a: Verify completeness of merged data

Let's check our new combined table with full year results. Let's see if we have all 4 quarters, all 12 months, that the first date is Jan 1st and the last date is Dec 31st. 
  ```sql  
SELECT 
	COUNT(DISTINCT period) AS no_of_periods,
	COUNT(DISTINCT MONTH(start_time)) AS no_of_months,
	MIN(start_time) AS first_day,
	MAX(start_time) AS last_day
FROM
	fy19_usage;
```
Output: There is an issue here. It's showing a count of 3 for quarters and 11 for months. However, the first and last days are correct. Which quarter is missing and which month is missing? Let's run a pair of queries to find out:
```sql
SELECT
	DISTINCT period
FROM
	fy19_usage;
    
SELECT
	DISTINCT MONTHNAME(start_time)
FROM
	fy19_usage;
```
Output: Q4 is missing and September is missing. 

Let's tackle the missing Q4 first.  This is strange because we know that the Q4 table's information has been merged (or else we wouldn't have Dec 31st as the last date). So what's the issue? The issue is that the `period` column for q4_trips_copy erronously had the value Q3. Human input error (my bad!). I used the `UDATE` and `SET` functions to change them. Simple query:
```sql
UPDATE TABLE q4_trips_copy
SET period = 'Q4';
```
Now to update the merged full year file to reflect the changes I've just made to `q4_trips_copy` , I could update it using the `UPDATE` function with a `WHERE` clause specifying the months of Oct, Nov, and Dec or I could just drop the table and re-run the query to re-create the table since one of the merged files has been changed. I chose the latter as it's simpler. I like simple.

Now onto the next issue: September is missing. Ok, it has come to my attention that we have a **big** problem: 

If I haven't mentioned it already, I've done some preliminary cleaning and analysis in Excel before uploading these files to SQL. However, the Q3 dataset was too large for Excel and thus didn't load (nor save!)completely (the journey of these files went from original .csv -> cleaning and formating in Excel -> loading into SQL for analysis. 

**The skinny**: The Q3 dataset we've loaded into SQL is *incomplete* so, please wait while I load the orginal in SQL, clean and format it in SQL, and put it in the place of the incomplete dataset....OK, done! 

---
(If you insist on wanting to see nitty gritty of how I loaded, cleaned, and formated the raw Q3 .csv file to match the cleaning and formatting of the other files which were done in Excel then take the detour [here](#appendix) 

---
### 6b Resetting
Let's drop the `fy19_usage` table and recreate it.
```sql
-- WARNING --
DROP TABLE fy19_usage;
-- WARNING --
```
After dropping the table, we deleted the above mentioned code in warning so that we don't accidently drop it again. To recreate, we just re-ran the same query above where we combined the 4 files. Now it's time to run a query to check if we have all of the months:
```sql
SELECT
DISTINCT MONTHNAME(start_time), period
FROM fy19_usage;
```
Output: All months are there including Septemeber. Success.

And we have our full year dataset. Let's analyze. 

### Step 7: Conduct descriptive analysis of the full year dataset and output results

First, let's create a temporary table with the summary of our data. This allows us to see an overview of the data and potentially spot any outliers. We want to know the following: 
- minimum ride length
- maximum ride length
- average ride length
- most popular day of week
- number of rides under 1 hr (initial analysis done in Excel on Q1,Q2, and Q4 data suggested the number of rides started to thin out at and above the 1 hr mark)
- number of rides 1h or more
- total number of rides.

Then, we can export our table as a .csv Side note: I did run into issues calculating the outputs. You can see how I resolved these issues by clicking [here](fixing_fy19.sql).
 ```sql   
SELECT 
	MIN(SEC_TO_TIME(trip_duration)) AS min_ride_length, MAX(FLOOR(trip_duration/3600)) AS max_ride_length_hrs, 
	SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_ride_length, 'Tuesday' AS top_day, 'August' AS top_month, 'Q3' AS top_quarter, 
 	SUM(CASE WHEN trip_duration <3600 THEN 1 ELSE 0 END) AS rides_under_1hr, ROUND((SUM(CASE WHEN trip_duration <3600 THEN 1 ELSE 0 END)/COUNT(trip_id) * 100),2) AS percent_of_total,
	SUM(CASE WHEN trip_duration >=3600 THEN 1 ELSE 0 END) AS rides_1hr_or_more, ROUND((SUM(CASE WHEN trip_duration >=3600 THEN 1 ELSE 0 END)/COUNT(trip_id) * 100),2) AS percent_of_total,
 	COUNT(trip_id) AS total_rides
FROM
	fy19_usage;
```
|min_ride_length|max_ride_length_hrs|avg_ride_length|top_day|top_month|top_quarter|rides_under_1hr|percent_of_total|rides_1hr_or_more|percent_of_total|total_rides|
|---------------|-------------------|---------------|-------|---------|-----------|---------------|----------------|-----------------|----------------|-----------|
|00:01:01|2952|00:24:07|Tuesday|August|Q3|3605410|95.93|153006|4.07|3758416|

This is a raw summary. We'll export the table as a .csv.
Next, we'll run a query giving us a summary filtered for rides under 1hr. Upon analysis (running separate queries), Tuesday, August, and Q3 are still the top day, month, and quarter respectively. 
``` sql
SELECT 
	MIN(SEC_TO_TIME(trip_duration)) AS min_ride_length, MAX(SEC_TO_TIME(trip_duration)) AS max_ride_length, 
	SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_ride_length, 'Tuesday' AS top_day, 'August' AS top_month, 'Q3' AS top_quarter, 
	SUM(CASE WHEN trip_duration <3600 THEN 1 ELSE 0 END) AS rides_under_1hr, ROUND((SUM(CASE WHEN trip_duration <3600 THEN 1 ELSE 0 END)/COUNT(trip_id) * 100),2) AS percent_of_total,
	SUM(CASE WHEN trip_duration >=3600 THEN 1 ELSE 0 END) AS rides_1hr_or_more, ROUND((SUM(CASE WHEN trip_duration >=3600 THEN 1 ELSE 0 END)/COUNT(trip_id) * 100),2) AS percent_of_total,
	COUNT(trip_id) AS total_rides
FROM
	fy19_usage
WHERE
	trip_duration < 3600;
```
|min_ride_length|max_ride_length|avg_ride_length|top_day|top_month|top_quarter|rides_under_1hr|percent_of_total|rides_1hr_or_more|percent_of_total|total_rides|
|---------------|---------------|---------------|-------|---------|-----------|---------------|----------------|-----------------|----------------|-----------|
|00:01:01|00:59:59|00:14:41|Tuesday|August|Q3|3605410|100.00|0|0.00|3605410|
        
Again, we'll export the table as a .csv.
Next, we'll create and pull two temporary tables one raw (unfiltered) and one filtered (for trips under 1 hour) telling us the average ride length per user with the following queries:
```sql
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
 ```
To see and compare this data side by side, we'll combine the columns of the two temporary tables using an `INNER JOIN` in the following query:
```sql
    SELECT r.usertype, r.avg_length_raw, f.avg_length_filtered, r.total_rides_raw, f.total_rides_filtered
    FROM raw_vs_filtered r
    JOIN filtered f ON r.usertype = f.usertype;
```
The output is as follows:
|usertype|avg_length_raw|avg_length_filtered|total_rides_raw|total_rides_filtered|
|--------|--------------|-------------------|---------------|--------------------|
|Subscriber|00:14:18|00:12:17|2901431|2889500|
|Customer|00:57:20|00:24:22|856985|715910|
    
Upon analysis, we've decided to continue down the road of focusing further analysis only on rides under 1 hour in duration. This overwhelmingly reflects normal usage and we don't have to deal with the headache of extreme outliers (ride durations of thousands of hours = malfunctions or abandoned bikes...maybe?) skewing subsequent analysis. We'll export this table as a .csv in case we need to justify our choice to stakeholders.

Next, we'll create and pull two temporary tables each one telling us the average ride length and total rides per day per customer, filtered for rides under 1 hour: 
```sql
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
```
Then we'll combine them with the `JOIN` function:
```sql
SELECT c.day_of_week, c.avg_customer_length, c.total_customer_rides, s.avg_subscriber_length, s.total_subscriber_rides
FROM length_cust_days c 
JOIN length_subs_days s ON c.day_of_week = s.day_of_week; 
```
|day_of_week|avg_customer_length|total_customer_rides|avg_subscriber_length|total_subscriber_rides|
|-----------|-------------------|--------------------|---------------------|----------------------|
|Tue|00:23:16|75525|00:12:03|495459|
|Wed|00:23:01|76897|00:12:06|492728|
|Thu|00:23:13|85102|00:12:02|480395|
|Fri|00:23:55|98238|00:11:56|442102|
|Sat|00:25:42|161286|00:13:24|274556|
|Sun|00:25:13|134532|00:13:16|246993|
|Mon|00:24:18|84330|00:12:05|457267|

And we'll export the table as a .csv. **note:** We later sorted this table in Excel to put the days of the week in order starting from Sunday. 

We'll do the same for average ride length and total rides per month per customer, filtered for rides under 1 hour. Note that `MONTH` is a functon in SQL so we chose another name (`fy19_month`) for the column with the months:
```sql
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
  ```
And join:
```sql
   SELECT c.fy19_month, c.avg_customer_length, c.num_customer_rides, s.avg_subscriber_length, s.num_subscriber_rides
   FROM length_cust_months c 
   JOIN length_subs_months s ON c.fy19_month  = s.fy19_month; 
```
|fy19_month|avg_customer_length|num_customer_rides|avg_subscriber_length|num_subscriber_rides|
|----------|-------------------|------------------|---------------------|--------------------|
|January|00:22:09|4020|00:10:29|98189|
|February|00:19:10|2393|00:10:14|93131|
|March|00:23:46|13786|00:10:48|149272|
|April|00:26:00|39017|00:11:53|216713|
|May|00:25:50|66408|00:12:32|284460|
|June|00:25:08|88323|00:13:09|307666|
|July|00:25:05|144160|00:13:36|379475|
|August|00:24:38|154888|00:13:17|401473|
|September|00:23:37|109631|00:12:41|362694|
|October|00:22:01|61810|00:11:33|299956|
|November|00:19:48|16961|00:10:37|158102|
|December|00:21:19|14513|00:10:33|138369|


Exporting this as well.
And finally, we'll do the same for average ride length and total rides per quarter per customer, filtered for rides under 1 hour
```sql
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
```
And combine using `JOIN`:
```sql
   SELECT c.period, c.avg_customer_length, c.num_customer_rides, s.avg_subscriber_length, s.num_subscriber_rides
   FROM length_cust_quarters c 
   JOIN length_subs_quarters s ON c.period  = s.period; -- here is the export
 ```
|period|avg_customer_length|num_customer_rides|avg_subscriber_length|num_subscriber_rides|
|------|-------------------|------------------|---------------------|--------------------|
|Q1|00:22:54|20199|00:10:33|340592|
|Q2|00:25:33|193748|00:12:35|808839|
|Q3|00:24:31|408679|00:13:12|1143642|
|Q4|00:21:30|93284|00:11:04|596427|
  
We export that...annd that's the end of this SeQueL! 😆 My final actions: saving and exporting these SQL script so we can repeat some or all of these queries in the future.  

   ---
   
## Appendix 

### Detour of importing, cleaning, and formating the raw .csv file of the Q3 dataset
Create the table for Q3 data with columns matching that of the .csv file
```sql
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
```    
Success. Load data from .csv file into table
```sql
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Divvy_Trips_2019_Q3.csv'
INTO TABLE q3_trips 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```
Success. Check columns for successful execution 
```sql
SELECT * from q3_trips
LIMIT 100;
```
Sucess. Check number of rows (trips) and datatype for each column. Number of trips should be 1640718:

```sql
SELECT COUNT(trip_id) AS num_of_trips
FROM q3_trips;

DESCRIBE q3_trips;
```
|         |num_of_trips| 
|---------|--------------|
|     |1640718| 

All columns imported successfully as per specified datatype. 

Next create a duplicate of the Q3 table and modify the duplicate by doing the following:
1. Adding four columns:
   - `period` (after `trip_id`, value= 'Q3')
   - `ride_length` (after `end_time`, value= time difference between `end_time` and `start_time`)
   - `day_of_week` ( after `ride_length`, value = `day` of `start_time`)
   - `category` (after `day_of_week`, value = 'Weekend' or 'Weekday')
2.  Removing the commas and decimals from the `tripduration` column and changing the datatype to `int` in addition to renaming the column to `trip_duration`.
3.  If all goes well, replace the original with the duplicate and rename it to match the original. 

Start with duplicating the table and checking it:
```sql
CREATE TABLE q3_cleaned AS
SELECT * FROM q3_trips;

SELECT * FROM q3_cleaned
LIMIT 1000;
``
Then we add our four columns: 
```sql
ALTER TABLE q3_cleaned
	ADD period VARCHAR(2) AFTER trip_id, 
	ADD ride_length TIME AFTER end_time,
    	ADD day_of_week DATE AFTER ride_length,
    	ADD category VARCHAR(7) AFTER day_of_week;
 ```
and set their values:
```sql
UPDATE q3_cleaned
SET
period = 'Q3',
ride_length = end_time - start_time,
day_of_week = DAYNAME(start_time);  
```
Working with dates, times, and datetimes can be tricky in MySQL. It often requires making sure the datatype is suitable: 
```sql
ALTER TABLE q3_cleaned
MODIFY COLUMN day_of_week VARCHAR(255);

SELECT DAYNAME(start_time) AS day_of_week
FROM q3_cleaned
LIMIT 100;

UPDATE q3_cleaned SET
day_of_week  = DAYNAME(start_time);
```
Using a logical statement to print 'Weekend' in the case where `day_of_week` column shows 'Saturday' or 'Sunday' as a value and to print 'Weekday' in all other cases:
```sql
UPDATE q3_cleaned
SET category =
CASE
WHEN day_of_week = 'Saturday' OR day_of_week = 'Sunday' THEN 'Weekend'
ELSE 'Weekday'
END;
``
Checking to see if the Weekend/Weekday logical statements worked.
```sql
SELECT DISTINCT category
FROM q3_cleaned;

SELECT day_of_week, category
FROM q3_cleaned
WHERE day_of_week = 'Friday'
LIMIT 100;
```
Looks good. Now on to formatting trip duration column by removing the commas and decimal points, changing the datatype, and renaming & replacing it: 
```sql
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
```
Everything looks good. Now time to replace and make a copy. Note that I like to take precautions when writing code and query that removes something. 
```sql
-- WARNING --
drop table q3_trips;
-- WARNING --
RENAME TABLE q3_cleaned TO q3_trips;

CREATE TABLE q3_trips_copy AS
SELECT * FROM q3_trips;

SELECT*
FROM q3_trips_copy;
```
and we're back on track. Detour over 🙂. You may now go back to where you left off by clicking [here](#6b-resetting)
   


    
   
