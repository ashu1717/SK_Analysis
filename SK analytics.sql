-- Create a table for the analytics data
Create table analytics (
			date date,
	Unique_Viewers INT,
	Unique_Viewers_Subscribers INT,
	Unique_Viewers_Non_Subscribers INT,
	Unique_Viewers_13_17 INT,
	Unique_Viewers_18_20 INT,
	Unique_Viewers_21_24 INT,
	Unique_Viewers_25_34 INT,
	Unique_Viewers_35_plus INT,
	Unique_Viewers_Age_Unknown INT,
	Unique_Viewers_Male INT,
	Unique_Viewers_Female INT,
	Unique_Viewers_Gender_Unknown INT,
	Total_Time_Viewed decimal,
	Total_Subscribers decimal
);

-- Create a table for the revenue data
CREATE TABLE revenue (
    title VARCHAR(255),
    revenue_type VARCHAR(100),
    launch_date text,
    earned_date text,
    revenue NUMERIC,
    country VARCHAR(100),
    impressions INT,
    ecpm NUMERIC
);

-- Load data into the revenue table
COPY revenue (title, revenue_type, launch_date, earned_date, revenue, country, impressions, ecpm)
FROM 'D:/DATA-ANALYST-INTERNSHIP/SK Lifestyle-revenue.csv'
DELIMITER ','
CSV HEADER;

-- Load data into the analytics table
COPY analytics (date, unique_viewers, unique_viewers_subscribers, unique_viewers_non_subscribers, unique_viewers_13_17, unique_viewers_18_20, unique_viewers_21_24, unique_viewers_25_34, unique_viewers_35_plus,Unique_Viewers_Age_Unknown,
	Unique_Viewers_Male ,
	Unique_Viewers_Female,
	Unique_Viewers_Gender_Unknown, total_time_viewed, total_subscribers)
FROM 'D:/DATA-ANALYST-INTERNSHIP/SK Lifestyle-analytics.csv'
DELIMITER ','
CSV HEADER;


-- Revenue Analysis


-- Total Revenue, Total Impressions, Average ecpm by Video Title
Select title, Sum(revenue) As Total_Revenue, Sum(impressions) As Total_impressions, Avg(ecpm) as Average_ecpm
from revenue
group by title
order by 2 Desc;

-- Correlation Between Revenue and Impressions
Select CORR(revenue,impressions) from revenue;

-- Correlation Between Revenue and eCPM
Select CORR(revenue,ecpm) from revenue;

-- Top 10 Videos with Highest eCPM:
SELECT title, 
       AVG(ecpm) AS avg_ecpm, 
       SUM(revenue) AS total_revenue
FROM revenue
GROUP BY title
ORDER BY avg_ecpm DESC
LIMIT 10;

-- Revemue by country
SELECT country, 
       SUM(revenue) AS total_revenue
FROM revenue
GROUP BY country
ORDER BY total_revenue DESC;


-- Analytics file analysis

-- Correlation Between Unique Viewers and Total Time Viewed
Select CORR(Unique_Viewers, Total_Time_Viewed) from analytics;

-- Correlation Between Unique Viewers Non-Subscribers vs Total Time Viewed:
Select CORR(Unique_Viewers_non_subscribers, Total_Time_Viewed) from analytics;

-- Correlation Between Total Subscribers and Unique Viewers
Select CORR(Total_subscribers, Unique_Viewers) from analytics;

--  Total Viewership by Subscriber Status
SELECT 
    SUM(unique_viewers_subscribers) AS total_subscriber_viewers, 
    SUM(unique_viewers_non_subscribers) AS total_non_subscriber_viewers
FROM analytics;

--Viewership Breakdown by Age Groups and their percentages

SELECT 
    SUM(unique_viewers_18_20) AS viewers_18_20, 
    SUM(unique_viewers_21_24) AS viewers_21_24, 
    SUM(unique_viewers_25_34) AS viewers_25_34, 
    SUM(unique_viewers_35_plus) AS viewers_35_plus,
	SUM(unique_viewers_age_unknown) AS age_unknown_viewers
FROM analytics

Union all

SELECT 
    SUM(unique_viewers_18_20)*1.0/ SUM(Unique_Viewers)*1.0 * 100.0 AS viewers_18_20, 
    SUM(unique_viewers_21_24)*1.0/ SUM(Unique_Viewers)*1.0 * 100.0 AS viewers_21_24, 
    SUM(unique_viewers_25_34)*1.0/ SUM(Unique_Viewers)*1.0 * 100.0 AS viewers_25_34, 
    SUM(unique_viewers_35_plus)*1.0/ SUM(Unique_Viewers)*1.0 * 100.0 AS viewers_35_plus,
	SUM(unique_viewers_age_unknown)*1.0/ SUM(Unique_Viewers)*1.0 * 100.0 AS age_unknown_viewers
FROM analytics;

--Unique Viewers Trend Over Time
SELECT 
    DATE AS view_date, 
    SUM(unique_viewers) AS total_unique_viewers
FROM analytics
GROUP BY view_date
ORDER BY view_date;

--Gender Based Viewership
SELECT 
    SUM(unique_viewers_male) AS male_viewers, 
    SUM(unique_viewers_female) AS female_viewers, 
    SUM(unique_viewers_gender_unknown) AS gender_unknown_viewers
FROM analytics;

--Total Time Viewed vs Unique Viewers
SELECT 
    SUM(unique_viewers) AS total_unique_viewers, 
    SUM(total_time_viewed) AS total_time_viewed
FROM analytics;

--Engagement by Age Group (Watch Time)
SELECT 
    SUM(unique_viewers_13_17) AS viewers_13_17, 
    SUM(unique_viewers_18_20) AS viewers_18_20, 
    SUM(unique_viewers_21_24) AS viewers_21_24, 
    SUM(unique_viewers_25_34) AS viewers_25_34, 
    SUM(unique_viewers_35_plus) AS viewers_35_plus,
    SUM(total_time_viewed) AS total_watch_time
FROM analytics
GROUP BY unique_viewers_13_17, unique_viewers_18_20, unique_viewers_21_24, unique_viewers_25_34, unique_viewers_35_plus;

--Subscriber Growth Over Time
SELECT 
    DATE AS view_date, 
    SUM(total_subscribers) AS total_subscribers
FROM analytics
GROUP BY view_date
ORDER BY view_date;

--Daily Engagement (Watch Time per Day)
SELECT 
    DATE AS view_date, 
    SUM(total_time_viewed) AS total_watch_time
FROM analytics
GROUP BY view_date
ORDER BY view_date;

--Gender-Based Watch Time
SELECT 
    SUM(total_time_viewed) AS total_watch_time, 
    SUM(unique_viewers_male) AS male_watch_time, 
    SUM(unique_viewers_female) AS female_watch_time
FROM analytics;


