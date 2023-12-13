SELECT *
FROM fy19_bikes.fy19_usage
ORDER BY trip_duration DESC
LIMIT 1000;

-- Trying to solve the issue of the time limit in SQL being 858:59:59. We can calculate duration with the trip_duration column which lists duration in seconds. Simple math and concat can display the hh:mm:ss. 
SELECT trip_id, period, start_time, CONCAT(FLOOR(trip_duration/3600),':',FLOOR((trip_duration%3600)/60),':',(trip_duration%3600)%60) as true_ride_length
FROM fy19_usage
WHERE period = 'Q4'
order by FLOOR(trip_duration/3600) DESC
LIMIT 1000;

-- Had to specify the calculation in the order by because the CONCAT function gives the output as a string (i.e. 98:00:00 is longer than 857:00:00). The order matches our spreadsheet. Now let's test max and min on this.
SELECT trip_id, period, start_time, CONCAT(FLOOR(trip_duration/3600),':',FLOOR((trip_duration%3600)/60),':',(trip_duration%3600)%60) as max_ride_length
FROM fy19_usage
order by FLOOR(trip_duration/3600) DESC
LIMIT 1;

SELECT trip_id, period, start_time, CONCAT(FLOOR(trip_duration/3600),':',FLOOR((trip_duration%3600)/60),':',(trip_duration%3600)%60) as min_ride_length
FROM fy19_usage
order by FLOOR(trip_duration/3600) 
LIMIT 1;

-- It's working but there is very slight formatting issues (the max and min have a missing leading and trailing zero respectively). At this point, the juice isn't worth the squeeze. I'll just use raw trip duration and divide by floor 3600 to get hours for max. 
-- No need to be precise with hours, minutes, and seconds. 
-- instead of trying to be cute and write a complicated query to spit the mode of the instances of each day_of_week, I'm going to just summarize the number of rides per day of the week, note the top instance, and manually print that in summary report. 
-- Let's do the most popular quarters and months while we are at it. 

-- Raw summary
SELECT day_of_week, COUNT(*) as number_of_rides
FROM fy19_usage
GROUP BY day_of_week
ORDER BY number_of_rides DESC;  

-- Filtered summary
SELECT day_of_week, COUNT(*) as number_of_rides
FROM fy19_usage
WHERE trip_duration < 3600
GROUP BY day_of_week
ORDER BY number_of_rides DESC; 

-- raw summary
SELECT period, COUNT(*) as number_of_rides
FROM fy19_usage
GROUP BY period
ORDER BY number_of_rides DESC;

-- filtered summary
SELECT period, COUNT(*) as number_of_rides
FROM fy19_usage
WHERE trip_duration < 3600
GROUP BY period
ORDER BY number_of_rides DESC;

-- raw summary
SELECT MONTHNAME(start_time), COUNT(*) as number_of_rides
FROM fy19_usage
GROUP BY MONTHNAME(start_time)
ORDER BY number_of_rides DESC;

-- filtered summary
SELECT MONTHNAME(start_time), COUNT(*) as number_of_rides
FROM fy19_usage
WHERE trip_duration < 3600
GROUP BY MONTHNAME(start_time)
ORDER BY number_of_rides DESC;

-- The days of the week are not formatted uniformly. Let's fix that. 
SELECT DISTINCT day_of_week
FROM fy19_usage
WHERE period IN('Q1','Q2','Q4'); -- The culprit is Q3. 

UPDATE fy19_usage
SET day_of_week = SUBSTR(day_of_week,1,3)
WHERE period = 'Q3';

SELECT DISTINCT day_of_week
FROM fy19_usage;

SELECT
usertype, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_length_filtered,  COUNT(trip_id) AS total_rides_filtered
FROM fy19_usage 
WHERE trip_duration < 3600
GROUP BY usertype; 
           
SELECT day_of_week, SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_customer_length,  COUNT(trip_id) AS total_customer_rides
FROM fy19_usage 
WHERE usertype = 'Customer' AND trip_duration <3600
GROUP BY day_of_week;
