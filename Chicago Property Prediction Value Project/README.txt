Overview: In this project, the team gathered data from the city of Chicago on business licenses, crime, schools, and grocery stores.
That was combined with property level data from Zillow in order to predict average property values at the Zip Code level.
The end goal was to identify undervalued and overvalued zip codes in the city.


Contents:
Data: 
This folder contains 3 subfolders:
1. Original Data - contains original CSVs downloaded from City of Chicago, ACS
2. Final Data - Cleaned/updated data loaded into DB
   1. FactTable.csv - Final fact table data
   2. PropertiesTable.csv - Final properties table data
   3. SchoolTable.CSV - Final School table data
   4. BusinessTable.CSV - Final business table data
   5. PopTable.csv - Final zipcode table data
   6. GrocsTable.csv - Final groceries table data
   7. CrimeTable.csv - Final Crime table Data
1. Reference File
   1. -city_of_chicago-sample-Zillow-v2.xlsx - contains the results of the Zillow API for 26k addresses in the Chicago Area
   2. Chicago_Values_Zillow_Clean.xlsx - contains the cleaned version of the Zillow data with zip code and zestimate (property value from Zillow) extracted
   3. Zip Property Values.csv - contains the average property values from Zillow aggregated at the zip code level
   4. CrimeScores.csv - contains our crime score value for each crime type based on severity of crime on a 1-5 scale
   5. Grocery_scores.csv -  output of the grocery store count per capita and total square foot per capita in each zip code used for scoring. Only square foot per capita was used.
   6. School_scores_final.csv - output of the average school rating per school and average school rating per capita.
   7. Zip Crime Scores v2.csv - contains the sum of the crime scores for each crime in a zip code normalized by population for the zip
   8. Business License Codes to Use.csv - List of business licenses of interest (good/bad for neighborhood)
   9. Zip Code Biz License Scores - output of Business license scoring process, used to populate fact table for business_score






Scripts: This folder contains the code scripts used to transform, load, and analyze the data
1. Zillow XML Parsing.pdf - contains the python script used to extract the Zip Code and Zestimate from the Zillow API's XML
2. SQL_propvals_DDL_v1.sql - contains the SQL script to create the database schema
3. R_cleanCSVs_scripts_v1.Rmd - contains the R script used to clean the Chicago csv's
4. Zip_Property_Scores.pdf - contains the R script used to calculate the average property value aggregated at the Zip level
5. Zip_Business_Scores.pdf - contains the R script used to calculate the business scores aggregated at the Zip level
6. Zip_Crime_Scores.pdf - contains the R script used to calculate the crime scores aggregated at the Zip level
7. grocery_stores.pdf - contain the Python script used to calculate count of grocery stores per capita and total square footage of grocery stores per capita in each zip code.
8. School_scores.pdf - contains the Python script used to calculate average school rating per school and average school rating per capita. 
9. fact_table_scores_preds.R - contains the R script used to combine the dimension scores into one table and run the linear model to find our predicted property values
10. SQL_propvals_CSV_imports_v1.sql - contains the SQL script used to load the data into the MySQL database


Presentation: This folder contains our final products
DEPA Property Values.twbx - contains an extracted Tableau workbook with the zip level dashboard showing the top zips and a heatmap by difference in values or dimensional scoring
Business_Case_DEPA_FP_Assign3_8-2019.pdf - contains the final presentation detailing the entire end to end process