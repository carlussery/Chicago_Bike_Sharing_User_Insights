# Case Study: Chicago Bike Sharing User Insights

## Table of Contents

- [Case Study Overview](#case-study-overview)
- [The Question](#the-question)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning/Preparation](#data-cleaningpreparation)
- [Limitations](#limitations)
- [Data Analysis](#data-analysis)
- [Results/Findings](#resultsfindings)
- [Recommendations](#recommendations)

### Case Study Overview

This data analysis project aims to provide insights into how different riders use a Chicago-based bike-sharing company's services over a year. Through analysis of various aspects of the trip data, we seek to identify usage trends that differentiate subscribers to the service ("annual members") from pay-per-trip riders ("casual riders"). This allows us to make data-driven recommendations to the company to aid them in their goal of converting more casual riders into annual members.

### The Question

The question we're answering is the following: **How do annual members and casual riders use the company's bikes differently?**

### Data Sources

- The data used was acquired from Divvy and made available to the public. 
  - [Link to datasets](https://divvy-tripdata.s3.amazonaws.com/index.html)
  - [License for public use](https://divvybikes.com/data-license-agreement) 

- 2019 Trip data: The primary datasets used for this analysis are the following:
  - Divvy_Trips_2019_Q1.csv
  - Divvy_Trips_2019_Q2.csv
  - Divvy_Trips_2019_Q3.csv
  - Divvy_Trips_2019_Q4.csv

### Tools

- [Excel](https://www.office.com/?auth=1): Data Cleaning, Data Analyis
- [MySQL](https://www.mysql.com/): Data Cleaning, Data Merging, Data Analysis
- [Tableau Public](https://public.tableau.com/app/discover): Creating a dashboard

### Data Cleaning/Preparation
In the initial data preparation phase, we performed the following tasks:
1. Data loading and inspection.
2. Data cleaning and formatting
3. Data merging

For detailed documentation of the cleaning and preparation phase see the following:
- Project Change log
  - [here](Cyclistic_Bike_Users.docx)
- SQL Cleaning and analysis log
  - [here](SQL_Analysis.md)

### Limitations

**Upon initial analysis, it was determined to limit further analysis to trips under 1 hour in duration.** This is because a) the vast majority of trips (96%) are under 1 hour in duration. We believe this most accurately reflects actual common usage on behalf of both annual members and casual riders. b) There were a number of extreme outliers (trip durations in the hundreds and even thousands of hours) which greatly skewed the average duration results. 

### Data Analysis 

1. Based on the data we had in the datasets, we conducted an initial exploratory analysis to answer key questions such as:
   - How many bike trips were taken in 2019? How many were taken by annual members? Casual riders?
   - When did these trips most frequently happen?
   - What was the average trip duration?
2. We looked at the number of trips and average trip duration per user type for the entire year in addition to looking at each on a per day, per month, and per quarter basis. Our aim was to identify any trends in ride frequency and duration and how they differ between annual members and casual riders.

Below is the query we ran to look at this on a per-month basis: 
```sql
CREATE TEMPORARY TABLE length_cust_months
	SELECT
		MONTHNAME(start_time) AS fy19_month,
		SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_customer_length,
		COUNT(trip_id) AS num_customer_rides
	FROM
		fy19_usage 
	WHERE
		usertype = 'Customer' AND trip_duration <3600
	GROUP BY
		MONTHNAME(start_time)
	ORDER BY
		start_time; 
```
```sql
CREATE TEMPORARY TABLE length_subs_months
	SELECT
		MONTHNAME(start_time) AS fy19_month,
		SEC_TO_TIME(FLOOR(AVG(trip_duration))) AS avg_subscriber_length,
		COUNT(trip_id) AS num_subscriber_rides
	FROM
		fy19_usage 
	WHERE
		usertype = 'Subscriber' AND trip_duration <3600
	GROUP BY
		MONTHNAME(start_time)
    	ORDER BY
		start_time;
  ```
And now using the `JOIN` function to combine the two tables:
```sql
SELECT
	c.fy19_month,
	c.avg_customer_length,
	c.num_customer_rides,
	s.avg_subscriber_length,
	s.num_subscriber_rides
FROM
	length_cust_months c 
JOIN
	length_subs_months s
ON
	c.fy19_month  = s.fy19_month; 
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


### Results/Findings

The analysis results are summarized as follows:

![data_per_quarter](https://github.com/carlussery/Chicago_Bike_Sharing_User_Insights/assets/153660397/a7d973b5-9c8f-4279-ab8d-4b5278ab701d)



1. **Casual riders take longer trips:** On average, the trip duration of casual riders is twice as long as that of annual members.
   
![Trips_per_Week](https://github.com/carlussery/Chicago_Bike_Sharing_User_Insights/assets/153660397/ef58079f-85ac-4077-9197-228bd7ad06f6)

   
2. **Annual members ride most frequently on weekdays and least frequently on weekends:** Annual member trips peaked on Tuesdays and Wednesdays while reaching lows on Saturdays and Sundays. Our hunch is that annual members are more likely to use the bikes to commute to work/school. Of course, further analysis is required to confirm this. 
3. **Casual riders ride most frequently on weekends and least frequently on weekdays:** For casual riders, it's just the opposite. Trips peaked on Saturdays and Sundays reaching lows on Tuesdays and Wednesdays. Our hunch is that casual riders are looking to ride for leisurely purposes especially when you take the much longer average ride duration into consideration (I'm a poet and I know it 😃).

To view the entire dashboard on Tableau click [here]([https://public.tableau.com/app/profile/carl.ussery/viz/Bikeshare_Capstone/BikeShare2019CasualvsSubscriber](https://public.tableau.com/app/profile/carl.ussery/viz/Bikeshare_Capstone/BikeShareDashboard))

### Recommendations

Based on the results of the analysis we recommend the following actions:
- Collect data on both annual members and casual riders to find out why they use bike sharing.
- Segment casual riders whose reasons align mostly with that of annual members and offer them the value of becoming a subscriber. 





