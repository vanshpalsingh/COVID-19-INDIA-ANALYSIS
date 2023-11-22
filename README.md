# COVID-19-INDIA-ANALYSIS
Charting India's COVID-19 History: Explore our detailed analysis of the pandemic's regional impact, providing insights into the past for future preparedness.

# Covid-19 India Analysis
![image](https://github.com/Fardin-Data/Covid-19-India-Analysis/assets/137788371/38c58620-1929-443b-b652-f49aa068b4dd)

## Introduction
The COVID-19 pandemic has had a profound impact on public health, and understanding the data is crucial for decision-making and resource allocation. This project, assigned by our training institution "Masai" with a tight 7-day deadline, aims to provide valuable insights and create a data-driven dashboard to aid in understanding the pandemic's progression and its effects on different regions of India.

## Problem Statement
- Extract COVID-19 data for India using Python and the `requests` module.
- Parse and clean the data, ensuring consistency and handling missing values.
- Perform SQL aggregations to create an Excel dashboard with the following insights:
    - Weekly evolution of confirmed cases, recoveries, deaths, and tests.
    - Categorize districts based on testing ratios and analyze deaths across categories.
    - Compare delta7 confirmed cases with vaccination data.
    - Create KPIs to assess case severity in different states.
    - Categorize total confirmed cases by month to identify the worst month for India.
  

## Process

`Data Retrieval`

Comprehensive Data Extraction Extracted a comprehensive dataset of COVID-19 information from an API using Python, ensuring data integrity.
<pre><code>
    #Making a Get Request to the Server:
    response=requests.get("https://data.covid19india.org/v4/min/timeseries.min.json")
</code></pre>

`Data Transformation`

Transformed the API's JSON-format data into a structured dataframe.
<pre><code>
    #Converting the response to Python DataStructure and Storing it to a Variable:
    data=response.json()

    #Making Empty DataFrame:
    df = pd.DataFrame()
    #Iterating through Each State:
    for state_code, state_data in data.items():
        #Getting All the Dates and Storing in a Variable:
        timeseries_data = state_data.get('dates', {})
        #Iterating through Each District of the State:
        for date, date_data in timeseries_data.items():
            #Flattening the Dictionary:
            date_df = pd.json_normalize(date_data)
            #Storing Dates in One Varaibel:
            date_df['Date'] = date
            #Storing Satate_Code in One Varaibel:
            date_df['State_Code'] = state_code
            #Concatinating Each Dates's Data
            df = pd.concat([df, date_df], ignore_index=True)
</code></pre>

`Data Cleaning & Processing`

Processed the dataset by handling null values, eliminating unwanted entries, and conducting outlier analysis. The cleaned data was then exported as a CSV file.
<pre><code>
    #Filling the Null Values with 0:
    for i in df:
        df[i]=df[i].fillna(0)
        #Changing The DataTypes:
        try:
            if i=="Date":
                df[i]=pd.to_datetime(df[i],format="%Y-%m-%d")
            else:    
                df[i]=df[i].astype(int)
        except:
            df[I]

    #Removing Outliers:
    for i in df.select_dtypes(include=int):
        q1=df[i].quantile(0.25)
        q3=df[i].quantile(0.75)
        iqr=q3-q1
        ul=df[i]+iqr*1.5
        ll=df[i]-iqr*1.5
        df=df[(df[i]>=ll)&(df[i]<=ul)]
</code></pre>

`Database Management with SQL`

Imported the CSV file into a database and employed SQL queries for data organization and transformation. This included creating structured tables for efficient data handling and categorizing data by testing ratios for further analysis.
<pre><code>
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
</code></pre>
                
`Data Analysis`

Employed pivot tables to summarize and aggregate the data, facilitating the creation of necessary charts and visualizations for the dashboard.

`Dashboard Creation`

Developed a dynamic Excel dashboard for effective data presentation. The dashboard featured various interactive elements, including slicers and bookmark features, allowing seamless switching between district and state-level analysis views.


## Dashboard
- The dashboard offers two views (state and district), allowing users to switch between them using bookmarks. 
- It includes various filters for exploring different scenarios.
  
![Screenshot 2023-09-09 155926](https://github.com/Fardin-Data/Covid-19-India-Analysis/assets/137788371/ce369b1c-d56b-40db-b96a-05e72c140200)

![Screenshot 2023-09-09 183418](https://github.com/Fardin-Data/Covid-19-India-Analysis/assets/137788371/5bf87ed5-aa93-42f9-9ea8-690a88dd5c5b)


## Key Insights

`Monthly Trend Analysis`

A consistent monthly trend emerged in each year, with a significant surge in confirmed cases observed in May. Prior to May, cases remained relatively low, gradually increasing. However, May saw an exponential rise in confirmed cases.

`Testing Ratio Impact`

Districts exhibiting the lowest testing ratios tended to experience higher numbers of cases and deaths. This suggests a potential correlation between testing efforts and case outcomes.

`Population Density Effect`

States with higher population density, such as Maharashtra, tended to report more cases and deaths. In contrast, regions with lower population density, like Lakshadweep, recorded the lowest numbers of confirmed cases.

`Seven-Day Moving Average`

An analysis of the seven-day moving average of confirmed cases revealed Kerala as a standout, demonstrating a substantial difference compared to other states. This indicates unique trends in the disease's progression in Kerala.


## Challenges Faced

`Data Extraction` 

We initially faced difficulties in getting data from the server, but we persevered and figured it out.

`Data Cleanup` 

Dealing with messy data, including missing values and confusing entries, was a challenge. We brainstormed and tried different methods to clean it up and make it useful.

`Data Visualization` 

Visualizing the data in a way that answered the project's questions was tough. We had to think creatively and work as a team to present the data effectively.

`Time Management`

Meeting project deadlines required good time management skills, and we learned to prioritize tasks efficiently.

## Learnings

`Persistence` 

We learned to keep trying when faced with data extraction problems.

`Data Cleaning` 

We improved our skills in making messy data useful through experimentation.

`Creative Problem-Solving` 

We found creative ways to visualize complex data through teamwork.

`Teamwork and Communication` 

Working with diverse viewpoints improved our communication and collaboration skills.

`Time Management`

Efficiently managing our time became crucial to meet project deadlines.


## Files Information
`Result`

- **Dashboard:** Excel file with sheets for state data, district data, pivot tables, and the dashboard.

`Data`
- **TimeSeries_Data:** Cleaned time series data exported from the web server after EDA.
- **District_Data:** Cleaned district data exported from the web server after EDA.

`Code`
- **Python Codes:** Contains codes used to extract, clean, and prepare data for analysis.
- **SQL Queries:** Contains SQL queries used for aggregation and creating tables for analysis and dashboard.


## Tech Stack
- `Python` Data extraction and EDA
- `MySQL` Aggregation for table creation
- `Excel` Dashboard creation and data presentation
- `Power Query` Minor data adjustments
- `API` Used API As a Data Source
- `Jupyter Notebook` Used Jupyter as IDE


## Data Sources
- [District Data](https://data.covid19india.org/v4/min/data.min.json)
- [Time Series Data](https://data.covid19india.org/v4/min/timeseries.min.json)


## Data Info
- [District Data Documentation](https://data.covid19india.org/documentation/v4_data.html)
- [Time Series Data Documentation](https://data.covid19india.org/documentation/timeseries.min.html)


## Project Presentation
- [View Project Presentation](https://www.canva.com/design/DAFt2HnMon8/pphQziAJYXAQuC90RBRqMw/view?utm_content=DAFt2HnMon8&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink#3)


## Team Members
- [Fardin khan](https://github.com/Fardin-Data)
- [Sachin Yadav](https://github.com/sachinyadav22)
- [Vanshpal Singh](https://github.com/vanshpalsingh?tab=following)
- [Vishwanath J](https://github.com/Vishwanath-J-25?tab=repositories)

## License
This project is licensed under the MIT License, allowing you to use, modify, and distribute the code and visuals while maintaining the original license terms.

---

For questions or feedback, please contact: fardinkhan.data@gmail.com

Enjoy exploring the project!
