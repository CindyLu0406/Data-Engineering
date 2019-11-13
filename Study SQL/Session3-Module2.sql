/***********************************************
** DATA ENGINEERING PLATFORMS (MSCA 31012)
** File: Session3-Module2.sql
** Desc: Categorizing Data (DML)
** Auth: Shreenidhi Bharadwaj
** Date: 1/21/2019
** Ref : http://www.mysqltutorial.org/
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/
# select database
USE classicmodels;

# list all customers and all available information
SELECT 
    *
FROM
    customers;
    
# SELECT * FROM customers;

# list all customers and some information
SELECT 
    customerNumber, customername, phone, country
FROM
    customers;

# select customers who are located in USA or France 
SELECT 
    customerNumber, customername, phone, country
FROM
    customers
WHERE
#	country = 'USA' OR country = 'France';
	country = 'USA' OR country = 'France' OR country='Japan';
    
    
# select customers who are located in USA or France - IN Operator   
SELECT 
    customerNumber, customername, phone, country
FROM
    customers
WHERE
#    country IN ('USA' , 'France');
 	country IN ('USA' , 'France' , 'Japan');
    
# select customers who are located in USA or France and have a credit limit > $100,000
SELECT 
    customerNumber, customername, country, creditLimit
FROM
    customers
WHERE
    country = 'USA' OR country = 'France'
        AND creditlimit > 100000;
    
/* Due to operator precedence the query returns the customers located 
 * in USA OR customers France with the credit limit > 100000 rather than 
 * those who are from USA or France AND have a credit limit > 100000
 */
SELECT 
    customerNumber, customername, country, creditLimit
FROM
    customers
WHERE
    (country = 'USA' OR country = 'France')
        AND creditlimit > 100000;
    
    
#Find all the orders that are inprocess or have been shipped 
SELECT 
    orderNumber, orderDate, requiredDate, customerNumber, status
FROM
    orders
WHERE
    (status = 'In Process'
        OR status = 'shipped');
    
# Find all the orders have been placed but not shipped or cancelled.
# Note the 2 seperate operator aliases which indicate the same thing - Not Equal To
# The != operator is converted to be <> by the compiler/interpreter during execution 

SELECT 
    orderNumber, orderDate, requiredDate, customerNumber, status
FROM
    orders
WHERE
    status <> 'shipped'
        AND status != 'cancelled';
        
#list all customers that are not assigned to a sales rep - is Null
SELECT 
    *
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL;
        
               
# list all products with buyPrice between 50$ and 100$ 

SELECT 
	productCode,
	productName,
    productLine,
    productDescription,
    quantityInStock,
    buyPrice
FROM
    products
WHERE
    buyPrice BETWEEN 50 AND 100;
    
# list all products with buyPrice between 50$ and 100$ 
SELECT 
	productCode,
	productName,
    productLine,
    productDescription,
    quantityInStock,
    buyPrice
FROM
    products
WHERE
    buyPrice > 50 AND 
    buyPrice < 100;

# list all customers along with their resident state and country 
# return N/A if the state is NULL using if statement 
SELECT 
    customerNumber,
    customerName,
    IF(state IS NULL, 'N/A', state) AS state,
    country
FROM
    customers;
    
# using case statement 
SELECT
	customerNumber,
    customerName,
    (CASE WHEN state IS NULL 
		THEN 'N/A' ELSE state END) 
	AS state,
    country
FROM
    customers;

# list all customers from Japan
# searching on Japa<single character wildcard>
SELECT 
	*
FROM
    customers
WHERE
    country LIKE 'Japa_';

# list all customers from San Francisco
# searching on San<wildcard> 
SELECT 
	*
FROM
    customers
WHERE
    city LIKE 'San%';
#   city LIKE 'San F%';

# list all products from Harley Davidson - partial match
SELECT 
    productCode, 
    productName, 
    productLine, 
    productDescription, 
    quantityInStock, 
    buyPrice, 
    MSRP
FROM
    products
WHERE
    productName LIKE '%Harley%';
    
# details of products that are not from Harley Davidson
SELECT
	productCode,
	productName,
    productLine,
    productDescription,
    quantityInStock,
    buyPrice,
    MSRP
FROM
    products
WHERE
    productName NOT LIKE '%Harley%';
     
# What is the cost of inventory for Harley Davidson's products
# Use of column alias
SELECT
	productCode,
	productName,
    productLine,
    productDescription,
    quantityInStock,
    buyPrice,
    (quantityInStock * buyPrice) AS totalAmount
FROM
    products
WHERE
    productName LIKE '%Harley%';

# what is the profit per product for Harley Davidson's products
SELECT
	productCode,
	productName,
    productLine,
    productDescription,
    quantityInStock,
    buyPrice,
    (MSRP - buyPrice) AS productProfit
FROM
    products
WHERE
    productName LIKE '%Harley%';

# if we want to wholesale Harley Davidson products in packs of 50, 
# how many units can we sell to another retailer and how many would be left over 

SELECT 
	productCode,
	productName,
    productLine,
    productDescription,
    quantityInStock,
    buyPrice,
    MSRP,
    FLOOR(quantityInStock / 50) AS numberOfPacks,
    (quantityInStock % 50) AS remainderQuantityInStock
FROM
    products
WHERE
    productName LIKE '%Harley%';

######################## DISTINCT  ########################

# DISTINCT - returns only distinct (unique) values
# what are the states where our customers are located ?
# only one NULL value will be returned 

SELECT DISTINCT
    state
FROM
    customers;
    
# what are the cities and states where our customers are located ?
# using DISTINCT gives unique combination of city and state .
SELECT DISTINCT
    city, state 
FROM
    customers
WHERE
    state IS NOT NULL;
    
# adding customerName to DISTINCT is same as SELECT all  
SELECT DISTINCT
   customerName, state, city
# SELECT customerName, state, city
FROM
    customers
WHERE
    state IS NOT NULL;

######################## LIMIT  ########################
# LIMIT - constrain the number of rows in a result set
# Useful to sample large result sets and to see top or bottom results

# first 10 customers in the customers table based on customerNumber
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city,
	creditLimit
FROM
    customers
LIMIT 10;

#ref : http://www.mysqltutorial.org/