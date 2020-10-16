# Insight Data Engineering

# GEOTRACKER
### TRACING COVID-19

Covid Alliance is a non-profit organization composed of volunteering Data Engineers and Data Scientist building a PANDEMIC MANAGEMENT PLATFORM by integrating diverse datasets. Their first problem is that their Geolocation data is too large, to tackle this problem they created a clustering algorithm. Their second problem is that the clustering algorithm takes too long process data and 3% of the data is loss due to pings with duplicated times are dropped. My approach improved their clustering algorithm by taking one of the duplicates and at the same time reducing the running time.

![Algorithm Performance](./Images/Algorithm Performance)

It is not secret Covid-19 has changed the way we live, from mandatory social distancing rules and sometimes hitting our most loved ones. In this project I built data pipelines to process GEOLOCATION data to help researchers find HOTSTPOTS and investigate people gathering at large events.


The following [slides](https://docs.google.com/presentation/d/1e2P15HbtsJ3QiQXl0H0nv10ulYOfAeWvLBiVEU1aJ9k/edit#slide=id.g6b20e22304_0_78) show the methodology of how I improved a clustering algorithm to process geolocation data. After reducing the dimensions of the dataset from 77.5GB to 2.1GB form users in Phoenix Arizon from July 15th, 2020 to September 3rd, 2020. I created GEOTTACKER which visualizes the preclusters in Looker to facillitate the work of researchers.

![GEOTRACKER](./GEOTRACKER/GEOTRACKER.gif)

GEOTRACKER shows the nuber of people in a place. By specifying the date and  time researchers can identify people gathering at different places.
