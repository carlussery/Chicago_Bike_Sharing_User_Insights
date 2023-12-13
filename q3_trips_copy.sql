SELECT * FROM fy19_bikes.q3_trips_copy
LIMIT 1000;
 -- Task: Change Q3 day_of_week to abreviated ddd to match other three tables
 DESCRIBE q3_trips_copy;
 
SELECT DISTINCT SUBSTR(day_of_week, 1,3) as trimmed_days
FROM q3_trips_copy;