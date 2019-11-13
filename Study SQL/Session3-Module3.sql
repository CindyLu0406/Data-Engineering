/***********************************************
** DATA ENGINEERING PLATFORMS (MSCA 31012)
** File: Session3-Module3.sql
** Desc: Summarizing Data (DML)
** Auth: Shreenidhi Bharadwaj
** Date: 1/21/2018
** Ref : http://www.mysqltutorial.org/
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/
# select database
USE classicmodels;

########################## COUNT ##########################
# COUNT function used to count rows that do not contain a NULL value.

# number of employees in the employees table    
SELECT 
    COUNT(addressLine2) AS numberOfEmployees
FROM
    customers;

# count on single column - employeeNumber
SELECT 
    COUNT(employeeNumber) AS numberOfEmployees
FROM
    employees;
    
# count on column 1 
SELECT
    COUNT(1) AS numberOfEmployees
FROM
    employees;

# use keyword ALL  
SELECT 
    COUNT(ALL addressLine2) AS numberOfCustomers
FROM
    customers;
    
SELECT 
    COUNT(ALL status) AS diffStatus
FROM
    orders;
    
# add columns ahead of the COUNT function to showcase varied results
# incorrect use - the results do not make sense
# the first row is returned with the count results   
SELECT 
    *, 
    COUNT(employeeNumber) AS numberOfEmployees
FROM
    employees;
  
# find all total number of unique offices from employees table
SELECT 
    COUNT(DISTINCT officeCode) AS numberOfOffices
FROM
    employees;

# find all total number of offices from employees table
SELECT 
    COUNT(officeCode) AS numberOfOffices
FROM
    employees;

# Count ignores null values 
# number of sales representatives in the customer table 
SELECT 
    COUNT(salesRepEmployeeNumber) AS numberOfSalesReps
FROM
    customers;

# total number of rows in the customer table    
SELECT 
    COUNT(*) AS numberOfCustomers
FROM
    customers;    

################## COUNT with WHERE clause #################

# number of orders that were placed by customers with id 103 and 114.
SELECT 
    COUNT(*) AS ordersPlaced
FROM
    orders
WHERE
    customerNumber = 103
        OR customerNumber = 114;
        
# count of customers living in Auckland or Brickhaven
SELECT 
    COUNT(customerNumber) 
FROM
    customers
WHERE
    city = 'Auckland' OR city = 'Brickhaven';
        
# number of customers who made payments in 2015 
SELECT 
    DISTINCT(COUNT(customerNumber)) AS totalCustomers
FROM
    payments
WHERE
    paymentDate >= '2015-01-01'
    AND paymentDate < '2016-01-01';
    
SELECT 
    COUNT(DISTINCT customerNumber) AS totalCustomers
FROM
    payments
WHERE
    paymentDate >= '2015-01-01'
    AND paymentDate < '2016-01-01';

SELECT 
    COUNT(customerNumber) AS totalCustomers
FROM
    payments
WHERE
    paymentDate >= '2015-01-01'
    AND paymentDate < '2016-01-01';
    
# number of employees working at the Boston office (without joining employee and office tables - not recommended, join is perferred)
#step1: find out the office code of the Boston office
SELECT 
    officeCode
FROM
    offices
WHERE 
	city = 'Boston';

#step2: find the employees at the Boston location
SELECT 
    COUNT(employeeNumber) AS numberOfEmployees
FROM
    employees
WHERE
    officeCode = 2;
	
############## AGGREGATES - SUM, MIN, MAX ####################
        
# SUM - returns a total on the values of a column for a group of rows. NULL values are ignored
# total quantity ordered by customers 
SELECT 
    SUM(quantityOrdered) AS totalQuantityOrdered
FROM
    orderdetails;
   
# MIN - returns the minimum value of a column for a group of rows. NULL values are ignored
# minimum units for any order
SELECT  
    MIN(quantityOrdered) AS minQuantityOrdered
FROM
    orderdetails;

# MAX - returns the maximum value of a column for a group of rows. NULL values are ignored.
# maximum units for any order
SELECT 
    MAX(quantityOrdered) AS maxQuantityOrdered
FROM
    orderdetails;

############## AGGREGATES - STATISTICAL  ##################

# Arithmetic mean - the average of a set of numerical values, calculated by adding them together and dividing by the number of terms in the set.
# AVG - return a total on the values of a column for a group of rows

# arithmetic mean of the buyPrice for all products 
SELECT 
    SUM(priceEach) / COUNT(priceEach) AS avgPrice,
    AVG(priceEach) AS avgPrice
FROM	
    orderdetails;

# STD - population standard deviation
# standard deviation of units across all orders 
SELECT 
    STD(quantityOrdered) AS stdQuantityOrdered
FROM
    orderdetails;
    
# VARIANCE - population standard variance 
# variance of units across all orders 
SELECT 
    VARIANCE(quantityOrdered) AS varQuantityOrdered
FROM
    orderdetails;

# Weighted average - an average resulting from the multiplication of each component by a factor reflecting its importance.
# weighted average of the buyPrice ( number of units * price ) for all products 
SELECT 
    SUM(quantityOrdered * priceEach) / SUM(priceEach) AS weightedAverage
FROM
    orderdetails;
    
# Geometric mean - indicates the central tendency of a set of numbers by using the product of their values 
# geometric mean of the buyPrice for all products
SELECT 
    EXP(SUM(LOG(priceEach)) / COUNT(priceEach)) AS geometricMean
FROM
    orderdetails;
    
# midrange - arithmetic mean of the maximum and minimum values in a data set
# midrange of the buyPrice for all products
SELECT 
    (MAX(priceEach) + MIN(priceEach)) / 2 AS midRange
FROM
    orderdetails;

# combining aggregates in a single row 
# some statistics on the ordersdetails table
SELECT 
    COUNT(DISTINCT orderNumber),
    MIN(quantityOrdered) AS minQuantityOrdered,
    MAX(quantityOrdered),
    AVG(quantityOrdered),
    SUM(quantityOrdered),
    MAX(priceEach),
	MIN(priceEach),
    STD(priceEach)
FROM
    orderdetails;

############## AGGREGATES with WHERE clause ##################

# sum of inventory in stock with buy price between 50$ and 100$
SELECT 
    SUM(quantityInStock) AS totalQuantityInStock
FROM
    products
WHERE
    buyPrice BETWEEN 50 AND 100;
    
# sum of inventory ( other than motorcycles ) in stock with buy price between 50$ and 100$ 
SELECT 
    SUM(quantityInStock) AS totalQuantityInStock
FROM
    Products
WHERE
    (buyPrice BETWEEN 50 AND 100)
        AND NOT productLine IN ('Motorcycles');

# Validate
SELECT 
    SUM(quantityInStock) AS totalQuantityInStock
FROM
    Products
WHERE
	productLine='Motorcycles' AND (buyPrice BETWEEN 50 AND 100);
    
# average credit limit of customers living in USA or FRANCE and with 
# creditLimit > 100000
SELECT 
    AVG(creditLimit) AS avgCreditLimit
FROM
    customers
WHERE
    (country = 'USA' OR country = 'France')
        AND creditlimit > 100000;
                
# minimum MSRP for the list of products that are not Harley Davidson 
SELECT 
    MIN(MSRP) AS minMSRP
FROM
    products
WHERE
    productName NOT LIKE '%Harley%';        

# total amount spent by customers for the year 2016        
SELECT 
    COUNT(DISTINCT(customerNumber)) AS totalCustomers, 
    SUM(amount) AS totalAmountSpent
FROM
    payments
WHERE
    paymentDate BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-12-31' AS DATE);
    
# total orders that have been shipped or cancelled
SELECT 
    SUM(IF(status = 'Shipped', 1, 0)) AS Shipped,
    SUM(IF(status = 'Cancelled', 1, 0)) AS Cancelled
FROM
    orders;    

# total orders by each status using IF condition
SELECT
	COUNT(IF(status = 'Shipped', 1, NULL)) 'Shipped',
    COUNT(IF(status = 'On Hold', 1, NULL)) 'On Hold',
    COUNT(IF(status = 'In Process', 1, NULL)) 'In Process',
    COUNT(IF(status = 'Resolved', 1, NULL)) 'Resolved',
    COUNT(IF(status = 'Cancelled', 1, NULL)) 'Cancelled',
    COUNT(IF(status = 'Disputed', 1, NULL)) 'Disputed',
    COUNT(*) AS Total
FROM
    orders;

# total orders by each status using CASE statements
SELECT 
    SUM(CASE
        WHEN status = 'Shipped' THEN 1
        ELSE 0
    END) AS 'Shipped',
    SUM(CASE
        WHEN status = 'On Hold' THEN 1
        ELSE 0
    END) AS 'On Hold',
    SUM(CASE
        WHEN status = 'In Process' THEN 1
        ELSE 0
    END) AS 'In Process',
    SUM(CASE
        WHEN status = 'Resolved' THEN 1
        ELSE 0
    END) AS 'Resolved',
    SUM(CASE
        WHEN status = 'Cancelled' THEN 1
        ELSE 0
    END) AS 'Cancelled',
    SUM(CASE
        WHEN status = 'Disputed' THEN 1
        ELSE 0
    END) AS 'Disputed',
    COUNT(*) AS Total
FROM
    orders;
	
#ref : http://www.mysqltutorial.org/