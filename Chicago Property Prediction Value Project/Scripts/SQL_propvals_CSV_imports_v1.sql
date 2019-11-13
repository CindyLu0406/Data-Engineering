
-- SCHOOLS DATA FRAME

 SET SQL_SAFE_UPDATES = 0;
 load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SchoolTable.csv' into table schools
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES
 (@col1, @col2, @col3, @col4, @col5,@col6, @col7)
 set school_id=@col1, school_name=@col2,school_level=@col3,lat=@col4,lon=@col5,zip_code=CAST(@col6 AS UNSIGNED),rating=@col7;

-- select *
-- from schools


-- GROCERIES DATA FRAME

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/GrocsTable.csv' into table groceries
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET grocery_id = @col1, store_name = @col2, license_id = @col3, zip_code = CAST(@col4 AS UNSIGNED), store_sqft = @col5, lat = @col6, lon = @col7;

-- SELECT *
-- FROM groceries;


-- BUSINESS LICENSES DATA FRAME
SET sql_mode = '';
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/BusinessTable.csv' into table businesses
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5, @col6)
SET business_id = @col1, license_id = @col2, zip_code = CAST(@col3 AS UNSIGNED), lat = @col4, lon = @col5, license_type = @col6;

-- select * 
-- from businesses;

-- CRIME DATA FRAME

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CrimeTable.csv' into table crimes
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5)
SET crime_id = @col1, lat = @col2, lon = @col3, crime_type = @col4, zip_code = @col5;

-- select *
-- from crimes

#ZIP LEVEL POPULATION DATA FRAME

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PopTable.csv' into table zipcode
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4)
SET zip_id = @col1, zip_code = @col2, population = @col3, aggpop = @col4;

-- select *
-- from zipcode;

#PROPERTY VALUES DATA FRAME

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PropertiesTable.csv' into table properties
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET address_id = @col1, address_num = @col2, address = @col3, property_value = CAST(@col4 AS UNSIGNED), zip_code = @col5, lat = @col6, lon = @col7;

-- select *
-- from properties;

#FACT TABLE

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/FactTable.csv' into table fact_values
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8)
SET Zip_code = @col1, predicted_aug_value = @col2, actual_aug_value = @col3, difference = @col4, count_groceries = @col5, crime_score = @col6, business_score = @col7, school_score = @col8;

-- select *
-- from fact_values;