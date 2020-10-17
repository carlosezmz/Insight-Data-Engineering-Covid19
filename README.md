# Insight Data Engineering

# GEOTRACKER
### TRACING COVID-19

#### Business Problem
Covid Alliance is a non-profit organization composed of volunteering Data Engineers and Data Scientist building a PANDEMIC MANAGEMENT PLATFORM by integrating diverse datasets. Their first problem is that their Geolocation data is messy and large (over 30TB). To tackle this problem they created a clustering algorithm which reduces the number of rows of the raw data. To inderstand how the clustering algorithm works, please direct your attention to iage below. Let's assume you have three individuals at the given location. The blue pings represent the exact location and time of all every individual. Those blue pings can be reduced into three rows (red pings) which details the time of arrival, time of departure, mean latittude, mean longitude, and how far they have gone from the mean location. Their second problem is that the clustering algorithm takes too long process data and 3% of the data is loss due to pings with duplicated times are dropped. 
   
<p align="center">
  <img width="500" height="450" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Clustering%20Pings.png">
</p>

#### CLustering Algorithm Improvements
My approach improved their clustering algorithm and at the same time decreased the running time. The following image shows the result of my approach compared to the old clustering algorithm where a sample of the data of 77.5 GB was reduced to 2.1 GB having 497,000 users in Phoenix Arizon from July to September 3. By taking one of the duplicated pings and prioritizing the first ping per user the number of raw pings to be clustered increased to approximately 1.4%. In return the number of clustered produced also increased close to 1%. Despite more data was being processed my approach took 81% fo the time as compared to old clustering algorithm.

<p align="center">
  <img width="1000" height="600" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Algorithm%20Performance.png">
</p>

In addition, to facillitate the work of researchers to find hotspots and study gathering in large events I created GEOTRACKER. GEOTRACKER visualizes users who are not at their home. By specifying the date and time researchers can find cluster of people. A demo of how GEOTRACKER works is shown below.

![GEOTRACKER](./GEOTRACKER/GEOTRACKER.gif)

#### Data Pipeline
The tech stack used by Covid Alliance are Snowflake, Pachyderm, and Looker.

<p align="center">
  <img width="1000" height="400" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Pipeline.png">
</p>


#### Engineering Challenge

<p align="center">
  <img width="500" height="450" src="https://github.com/carlosezmz/Insight-Data-Engineering-Covid19/blob/master/Images/Clustering%20Pings.png">
</p>
