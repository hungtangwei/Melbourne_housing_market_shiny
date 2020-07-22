## Melbourne_housing_market_shiny

Melbourne, the most liveable and beautiful city in the, attracts millions of tourists, thousands of students, immigrant, real estate investors from all over the world. Therefore, the house market in Victoria becomes up for grabs for every who want to settle down in this beautiful city, Melbourne. 

The intended audience in this narrative visualization project will be the any people who want to purchase the house in Victoria or who want to invest the real estate in Melbourne. 

In this project, I will focus on three main questions. The first one is what’s the houses distribution in Victoria. Second is what’s the Top 10 suburb in Victoria. The final is how to compare two suburbs. To finish these questions, I will design an interactive narrative visualization by using the five design sheets and implement the visualization as a web-based presentation by using shiny with css in R.

## Analysis code

Key elements of the analysis code are as follows:
- *Wrangling.ipynb* - a Python script use to wrangling the data. In this script, delete the null data and calculate some features, such as the travel time from house to CBD from original data and then ouput the file as housing_final.csv.
- *VIC_LOCALITY_POLYGON_shp* – The VIC Suburb/Locality Boundaries.
- *server.R/ui.R* - an R script used to render the Shiny app. This consists of several plotting functions as well as the ui (user interface) and server code required to render the Shiny app. The script has become more complex over time as a growing number of interactive features has been added.
- *housing_final.csv* - a csv file containing the housing market information from 2016 to 2018 in Victoria.

## Other resources

Several resources proved invaluable when building this app, including:
- 1. Melbourne Housing Data from 2016 to 2018 (34858 rows x 21columns) (URL: https://www.kaggle.com/anthonypino/melbourne-housing-market)
- 2. Victoria crime incident data from 2009 to 2018(284098 rows x 7 columns) (URL: https://www.crimestatistics.vic.gov.au/crime-statistics/historical-crime-data/year-ending-31-december-2018/download-data)
- 3. PTV timetable and Geographic Information (GTFS format)
(URL: https://discover.data.vic.gov.au/dataset/ptv-timetable-and-geographic-information-2015-gtfs)
- 4. Victoria State Boundary (shapefile)
(URL: https://data.gov.au/data/dataset/vic-suburb-locality-boundaries-psma-administrative-boundaries/resource/4d6ec8bb-1039-4fef-aa58-6a14438f29b1)

## Authors

Tangwei, Hung

## Contact
hung.tangwei@gmail.com
