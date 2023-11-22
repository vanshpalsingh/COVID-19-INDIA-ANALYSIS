#Creating dataBase and selecting it for further usage:
CREATE DATABASE Project;
USE Project;

#Making sure we have got right data:
SELECT * FROM District_data;
SELECT * FROM TimeSeries_data;

#Weekly evolution of number of confirmed cases, recovered cases, deaths, tests:
SELECT State,YEAR(Date) AS Year, MONTHNAME(Date) AS Month,
		CASE 
			WHEN DAY(date) BETWEEN 1 AND 7 THEN 'Week 1'
			WHEN DAY(date) BETWEEN 8 AND 14 THEN 'Week 2'
			WHEN DAY(date) BETWEEN 15 AND 21 THEN 'Week 3'
			WHEN DAY(date) BETWEEN 22 AND 28 THEN 'Week 4'
			ELSE 'Week 5' 
        END AS Week,
	sum(Total_Tested) AS Tested,
	sum(Total_Confirmed)  AS Confirmed,
	sum(Total_Recovered) AS Recovered, 
	sum(Total_Deceased) AS Deceased
  FROM TimeSeries_Data
  GROUP BY 1,2,3,4
  ORDER BY 1;

#Creating Categories based on Testing Ratio:
WITH cte as (SELECT *, IFNULL(Total_Tested/Population,0) AS Testing_Ratio FROM District_Data)
SELECT *,
	CASE
		WHEN  Testing_Ratio BETWEEN 0.05 AND 0.1 THEN 'Category A'
		WHEN  Testing_Ratio > 0.1 AND Testing_Ratio <= 0.3 THEN 'Category B'
		WHEN  Testing_Ratio > 0.3 AND Testing_Ratio <= 0.5 THEN 'Category C'
		WHEN  Testing_Ratio > 0.5 AND Testing_Ratio <= 0.75 THEN 'Category D'
		WHEN  Testing_Ratio > 0.75 AND Testing_Ratio <= 1 THEN 'Category E'
		ELSE '' 
	END AS Category 
FROM cte
ORDER BY State, District;

#Distric wise comparision of d7 cases with vaccination:
SELECT State, District,
		CAST(Delta7_Confirmed / (Delta7_Vaccinated1 + Delta7_Vaccinated2) AS DECIMAL (10,6)) AS "Cases By Vaccination"
FROM District_Data
WHERE Delta7_Vaccinated1 AND Delta7_Vaccinated2 <>0
ORDER BY 1,2;

#state wise comparision of d7 cases with vaccination 
SELECT
    State,
	CAST(SUM(Delta7_Confirmed) / SUM(Delta7_Vaccinated1 + Delta7_Vaccinated2) AS DECIMAL (10,5)) AS "Cases By Vaccination"
FROM District_Data
WHERE Delta7_Vaccinated1 AND Delta7_Vaccinated2 <>0
GROUP BY 1
ORDER BY 1;