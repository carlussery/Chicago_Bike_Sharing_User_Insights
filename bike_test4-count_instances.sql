SELECT * FROM testdb.bike_test4;
SELECT MONTHNAME(start_day) AS month_only, DAY(start_day) AS day_only, YEAR(start_day) AS year_only
FROM bike_test4;

SELECT * FROM bike_test4;

-- Counts instances of each day of the week. There are 3 sundays. 
SELECT day_of_week, COUNT(*) as cnt
FROM bike_test4
GROUP BY day_of_week
ORDER BY cnt DESC;

-- Trying now to display the top instance as a result
