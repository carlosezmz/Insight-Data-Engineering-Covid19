# Insight Data Engineering

# GEOTRACKER
## TRACING COVID-19

### Business Problem

Covid Alliance is a non-profit organization composed of volunteering Data Engineers and Data Scientist building a PANDEMIC MANAGEMENT PLATFORM by integrating diverse datasets. Their first problem is that their Geolocation data is messy and large (over 30TB). To tackle this problem they created a clustering algorithm which reduces the number of rows of the raw data. To understand how the clustering algorithm works, please direct your attention to iage below. Let's assume you have three individuals at the given location. The blue pings represent the exact location and time of all every individual. Those blue pings can be reduced into three rows (red pings) which details the time of arrival, time of departure, mean latittude, mean longitude, and how far they have gone from the mean location. Their second problem is that the clustering algorithm takes too long process data and 3% of the data is loss due to pings with duplicated times are dropped. 
   
   
<p align="center">
  <img width="500" height="450" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Clustering%20Pings.png">
</p>


### Clustering Algorithm Improvements

My approach improved their clustering algorithm and at the same time decreased the running time. The following image shows the result of my approach compared to the old clustering algorithm where a sample of the data of 77.5 GB was reduced to 2.1 GB having 497,000 users in Phoenix Arizon from July 15 to September 3. By taking one of the duplicated pings and prioritizing the first ping per user the number of raw pings to be clustered increased to approximately 1.4%. In return the number of clustered produced also increased close to 1%. Despite more data was being processed my approach took 81% fo the time as compared to old clustering algorithm.


<p align="center">
  <img width="1000" height="600" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Algorithm%20Performance.png">
</p>


In addition, to facillitate the work of researchers to find hotspots and study gathering in large events I created GEOTRACKER. GEOTRACKER visualizes users who are not at their home. By specifying the date and time researchers can find cluster of people. A demo of how GEOTRACKER works is shown below.


![GEOTRACKER](./GEOTRACKER/GEOTRACKER.gif)


### Data Pipeline

The tech stack used by Covid Alliance are Snowflake, Pachyderm, Looker, and Kubernetes. [Snowflake](https://www.snowflake.com/) is a SaaS cloud data warehouse built on top of AWS. More deatils of Snowflake can be found [here](https://medium.com/hashmapinc/snowflakes-cloud-data-warehouse-what-i-learned-and-why-i-m-rethinking-the-data-warehouse-75a5daad271c). [Pachyderm](https://www.pachyderm.com/) is the Git version of data pipeline orchestration to have reproducible results. [Reasons to use Pachyderm](https://medium.com/bigdatarepublic/pachyderm-for-data-scientists-d1d1dff3a2fa): having a group of data scientist working with same datasets using different models reproducing different resulst can be tracked by the repositories each data scientist is using. [Looker](https://looker.com/) is a visualization tool used to create dashboards to help end users make faster and smarter decisions. [Benefits](https://blog.aptitive.com/power-bi-vs-looker-vs-tableau-a-ctos-guide-to-selecting-an-analytics-bi-platform-5edc519f2d12) of using Looker include: collaborative data sharing, and create metrics without adding multiple versions of slightly different metric to you tables.


<p align="center">
  <img width="1000" height="400" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Pipeline.png">
</p>


How does the data pipeline work? The raw pings are stored in Snowflake and the SQL scripts live in Pachyderm repos. Every time a researcher wants to create clusters, it will need to send file to Pachyderm with the following parameters: the name of the table that contains the raw pings, the name of the table where the pre-clusters will be saved, the start-date and end-date. The raw pings will be extracted from Snowflake, transformed, and the pre-clusters will be saved into Snowflake. Later the new created pre-cluster can then be visualized in Looker.


### Engineering Challenge

#### Data Loss Vs Reproducible Results Vs Running Time

The first challenge was to reduce the data loss and having reproducible results. My first approach consisted on marking every row partitioned by user ID and timestamp of the ping. The data was then spllitted into a table that were marked with a row as 1 and another table where rows were marked greater than 1. The table with rows above 1 was processed using a Z score of the distance of neighboring points as a way to remove outliers and then averaging pings that were inside of 95% confidence interval. Then the averaged table was joint with the table with rows marked as 1. The main problem was that using this method for the same input data was producing different results every time the query was run. After realizing that in some rare case there were more than two duplicates, I decided not to do the Z score as a way to save an step in the process, but the final output was not reproducible.


<p align="center">
  <img width="900" height="320" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Z%20Score%20Approach.png">
</p>


<p align="center">
  <img width="900" height="320" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Row%20Averaging%20Approach.png">
</p>


The first approach was not giving reproducible for two reasons. First, one of the dupicated pings was also marked as 1. Second, some duplicated pings had the same speed. In other words, some duplicated pings were marked as 1 randomly and most pings marked above 1 were being averaged just by itself. To actually average duplicated pings, my second approach was to count and select the pings with a count greater than 1. Then the table with duplicated pings was averaged and joint with the table with a count of only 1 for user ID and timestamp.


<p align="center">
  <img width="900" height="320" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Averaging%20Approach.png">
</p>


Despite separating and averaging duplicated pings produced consistent results, the steps taken to group duplicated pings then filtering non-duplicates increased the running time of the process by approximately 25% compared to the old clustering algorithm. To reduce the running time and at the same time reduce the data loss, my final approach was numerating the rows by user ID and timestamp ordered by speed, latittude and longitude. Then selecting the rows that were numbered as 1. This method ensured the duplicated ping chosen was not picked at random. In other worlds, from the duplicated pings I picked the ping with lowest speed, lowest latittude and lowest longitude. This strategy cut the number of steps before clustering pings and at the same time decreased the running time by approximately 19%.


<p align="center">
  <img width="900" height="350" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Workable%20Approach.png">
</p>


### Miscellaneous

A detailed presentation of this project can be found  here, [Google Slides](https://docs.google.com/presentation/d/1e2P15HbtsJ3QiQXl0H0nv10ulYOfAeWvLBiVEU1aJ9k/edit#slide=id.g72416fa8cc_1_884).
