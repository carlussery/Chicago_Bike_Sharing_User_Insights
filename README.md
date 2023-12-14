# Case Study: Chicago Bike Sharing User Insights

### Overview

This data analysis project aims to provide insights into how different riders use a Chicago-based bike sharing company's services over the span of a year. Through analysis of various aspects of the trip data, we seek to identify usage trends which differentiate subscribers to the service ("annual members") from pay-per-trip riders ("casual riders"). This allows us to make data-driven recommendations to the company to aid them in thier goal of converting more casual riders into annual members.

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

### Data Cleaning / Preparation
In the initial data preparation phase, we performed the following tasks:
1. Data loading and inspection.
2. Data cleaning and formating
3. Data merging

Upon initial analysis, it was determined to limit further analysis to trips under 1 hour in duration. This is because a) the vast majority of trips (96%) are under 1 hour in duration. We believe this most accurately reflects actual common usage on behalf of both annual members and casual riders. b) There were a number of extreme outliers (trip durations in the hundreds and even thousands of hours) which greatly skewed the average duration results. 

For detailed documentation of the cleaning and preparation phase see the following:
- Project Change log
  - [here](Cyclistic_Bike_Users.docx)
- SQL Cleaning and analysis log
  - [here](SQL_Analysis.md) 

### Data Analysis 

1. Based on the data we had in the datasets, we conducted an initial exploratory analysis to answer key questions such as:
   - How many bike trips were taken in 2019? How many were taken by annual members? Casual riders?
   - When did these trips most frequently happen?
   - What was the average trip duration?
2. 
