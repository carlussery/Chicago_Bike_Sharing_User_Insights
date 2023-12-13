SELECT * FROM fy19_bikes.q1_trips;
-- Let's check our row count.
Select count(*)
from q1_trips;
-- All rows imported successfully
SELECT *
FROM q1_trips
LIMIT 10;

SELECT birth_year
FROM q1_trips_copy
WHERE row = 20;

DESCRIBE q1_trips

SELECT ride_length
FROM q1_trips
ORDER BY ride_length DESC;

SELECT CAST(ride_length AS TIME)
FROM q1_trips
ORDER BY CAST(ride_length AS TIME) DESC;

SELECT CAST(ride_length AS TIME)
FROM q1_trips
WHERE CAST(ride_length AS TIME) <= '00:59:59'
ORDER BY CAST(ride_length AS TIME) DESC;

SELECT str_to_date(start_time,'%m/%d/%Y %h:%m')
FROM q1_trips;
