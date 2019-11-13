/***********************************************
** DATA ENGINEERING PLATFORMS (MSCA 31012)
** File: Session4-Module8.sql
** Desc: Full-Text Search & JSON Support
** Auth: Shreenidhi Bharadwaj
** Date: 1/27/2018
** Ref : http://www.mysqltutorial.org/
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/

# select database
USE classicmodels;

################### Introduction to MySQL JSON data type  ###################
# Track visitors & actions on website. Some visitors may just view the pages and other may view the pages and buy the products. 
# Insert data onto the events table 
# id - uniquely identifies the event. 
# event_name - An event also has a name e.g., pageview, purchase, etc., 
# visitor - used to store the visitor information.
# properties - store properties of an event 
# browser - specification of the browser that visitors use to browse the website.
CREATE TABLE events( 
  id int auto_increment primary key, 
  event_name varchar(255), 
  visitor varchar(255), 
  properties json, 
  browser json
);


# Insert sample event data
INSERT INTO events(event_name, visitor,properties, browser) 
VALUES (
  'pageview', 
   '1',
   '{ "page": "/" }',
   '{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'
),
('pageview', 
  '2',
  '{ "page": "/contact" }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 2560, "y": 1600 } }'
),
(
  'pageview', 
  '1',
  '{ "page": "/products" }',
  '{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'
),
(
  'purchase', 
   '3',
  '{ "amount": 200 }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1600, "y": 900 } }'
),
(
  'purchase', 
   '4',
  '{ "amount": 150 }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1280, "y": 800 } }'
),
(
  'purchase', 
  '4',
  '{ "amount": 500 }',
  '{ "name": "Chrome", "os": "Windows", "resolution": { "x": 1680, "y": 1050 } }'
);


# validate
SELECT 
    *
FROM
    events;


# Which browser was used the most ? pull the data from the JSON blob
SELECT 
	id, 
    browser->'$.name' browser
FROM 
	events;


# to remove the quotes from the string use the inline path operator (->>)
SELECT 
	id, 
    browser->>'$.name' browser
FROM 
	events;


# Find the browser usage
SELECT 
	browser->>'$.name' browser, 
    count(browser)
FROM 
	events
GROUP BY 
	browser->>'$.name';
    

# calculate the total revenue by the visitor
SELECT 
	visitor, 
    SUM(properties->>'$.amount') revenue
FROM 
	events
WHERE 
	properties->>'$.amount' > 0
GROUP BY 
	visitor;
    

################### Introduction to MySQL Full-Text Search  ###################
# Natural Language Full-Text Searches
# Rows or documents that are relevant to the free-text natural human language query

# For natural-language full-text searches, it is a requirement that the columns named in the MATCH() function be the same columns included in FULLTEXT  index in your table. 
# https://dev.mysql.com/doc/refman/8.0/en/fulltext-search.html 
ALTER TABLE products ADD FULLTEXT(productline);
ALTER TABLE products ADD FULLTEXT index_name(productName);

# Search for products whose product lines contain the term Classic
SELECT 
    productName, productline
FROM
    products
WHERE
    MATCH (productline) AGAINST ('Classic' );
    
# search for product whose product line contains Classic or Vintage term
SELECT 
    productName, productline
FROM
    products
WHERE
    MATCH (productline) AGAINST ('Classic,Vintage' IN NATURAL LANGUAGE MODE);
    
# Search for products whose names contain  Ford  and/or  1932 using the following query:
SELECT 
    productName, productline
FROM
    products
WHERE
    MATCH (productName) AGAINST ('1932,Ford' );

# Boolean Full-Text Searches : Perform a full-text search based on very complex queries in the Boolean mode along with Boolean operators.

# Search for a product whose product name contains the Truck word.
SELECT 
    productName, productline
FROM
    products
WHERE
    MATCH (productName) AGAINST ('Truck' IN BOOLEAN MODE);


# find the product whose product names contain the   Truck word but not any rows that contain  Pickup
# use the exclude Boolean operator ( - )
SELECT 
    productName, productline
FROM
    products
WHERE
    MATCH (productName) AGAINST ('Truck -Pickup' IN BOOLEAN MODE)
