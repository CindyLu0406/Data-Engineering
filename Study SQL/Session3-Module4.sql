/***********************************************
** DATA ENGINEERING PLATFORMS (MSCA 31012)
** File: Session3-Module4.sql
** Desc: Sorting and Grouping Data (DML)
** Auth: Shreenidhi Bharadwaj
** Date: 1/21/2018
** Ref : http://www.mysqltutorial.org/
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/
# select database
USE classicmodels;

######################## ORDER BY ########################
# ORDER BY - used to sort the result set

# customers sorted ( single column ) by last name in ascending order
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city
FROM
    customers
ORDER BY contactLastname;

# use ASC keyword and compare results from previous query. results should be the same
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city
FROM
    customers
ORDER BY contactLastname ASC;

# customers sorted by last name in descending order
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city
FROM
    customers
ORDER BY contactLastname DESC;

# same as above but ordered using column number (integer)
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city
FROM
    customers
ORDER BY 1 DESC;

# customers sorted by state and city ( multiple columns )
# sort the state column first in descending order and then sort the 
# city within each state in ascending order.

SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city
FROM
    customers
ORDER BY state DESC, city ASC;

# remove null state values
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY state DESC , city ASC;

######################## GROUP BY ########################
# GROUP BY - arrange identical data into groups 
# generally not necessary unless using aggregate functions
##########################################################

# count of order status ( single column ) that were either cancelled/Disputed/Resolved/Shipped
SELECT 
    status, COUNT(*) AS numberOfOrders
FROM
    orders
GROUP BY status; #group by is used for aggregation

# use ASC keyword and compare results from previous query. results should be the same
SELECT 
    status, COUNT(*) AS numberOfOrders
FROM
    orders
GROUP BY status; # GROUP BY status ASC; will give an error. ascending doesn't work anymore. New version doesn't support ascending/Descending

# order status in descending order
SELECT 
    status, COUNT(*) AS numberOfOrders
FROM
    orders
GROUP BY status; #GROUP BY status DESC;

# same example as above but ordered by using an integer to represent the column name
SELECT 
    status, COUNT(*) AS numberOfOrders
FROM
    orders
GROUP BY 1;  #GROUP BY 1 DESC;

# customers grouped by customer number and status ( multiple columns )
# group the first in descending order and then sort the city within each state
# in ascending order. (note customer 328 or 119 )
SELECT 
    customerNumber, status, COUNT(*) AS numberOfOrders
FROM
    orders
GROUP BY customerNumber , status;  #GROUP BY customerNumber ASC , status DESC;

# Basket value of each order
SELECT 
    orderNumber,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orderdetails
GROUP BY orderNumber ;  #GROUP BY orderNumber DESC ; Combine by end all together. Group by first

######################## GROUP BY and ORDER BY  ########################
# GROUP BY clause is always placed before ORDER BY clause
########################################################################

# number of orders and status of order per each customer
SELECT 
    customerNumber, 
    status, 
    COUNT(*) AS numberOfOrders
FROM
    orders
GROUP BY customerNumber , status
ORDER BY numberOfOrders DESC;

# number of customers in each city
SELECT 
    city, 
    COUNT(*) AS numberOfCustomers
FROM
    CUSTOMERS
GROUP BY city
ORDER BY 2 DESC, 1;

######################## HAVING  ########################
# HAVING - filter condition for groups of rows or aggregates
# HAVING is to GROUP BY as WHERE is to SELECT
#########################################################
# find orders where quantity ordered >100 
SELECT 
    ordernumber,
    SUM(quantityOrdered) AS totalQuantity
FROM
    orderdetails
GROUP BY ordernumber
HAVING totalQuantity > 100; # give the 
 
# find the products where total price sold is greater than 10000 
# order by total price sold
SELECT
    productCode,
    SUM(quantityOrdered) as totalQuantity, 
    SUM(quantityOrdered*priceEach) as totalPrice
FROM
    orderdetails
GROUP BY productCode
HAVING totalPrice > 10000
ORDER BY totalPrice DESC;

/* 
The difference between the WHERE & HAVING is in the relationship to the GROUP BY clause:
- WHERE comes before GROUP BY; SQL evaluates the WHERE clause before it groups records.
- HAVING comes after GROUP BY; SQL evaluates HAVING after it groups records.
- HAVING clause applies the filter condition to each group of rows, while the WHERE 
  clause applies the filter condition to each individual row.
*/
# List all products that matches a pattern ( string )
SELECT
    productCode, 
    SUM(quantityOrdered) as totalQuantity, 
    SUM(quantityOrdered*priceEach) as totalPrice
FROM
    orderdetails
WHERE productCode like 'S18%'
GROUP BY productCode
HAVING totalPrice > 10000
ORDER BY totalPrice DESC;

SELECT
    productCode, 
    SUM(quantityOrdered) as totalQuantity, 
    SUM(quantityOrdered*priceEach) as totalPrice
FROM
    orderdetails
GROUP BY productCode
HAVING productCode like 'S18%' AND totalPrice > 10000
ORDER BY totalPrice DESC;

######################## LIMIT  ########################
# Top 5 customers with highest credit limit
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city,
    creditLimit
FROM
    customers
ORDER BY creditlimit DESC
LIMIT 5;

# 5 customers who have the lowest credit limit
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city,
    creditLimit
FROM
    customers
WHERE creditLimit > 0
ORDER BY creditlimit ASC
LIMIT 5;

# Return only the customer with 2nd highest credit limit 
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city,
    creditLimit
FROM
    customers
ORDER BY creditlimit DESC
LIMIT 1 , 1; # After the first one, gives the second one.

# Staring from the 5th highest credit limit, get the next 7 customers
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city,
    creditLimit
FROM
    customers
ORDER BY creditlimit DESC
LIMIT 5 ,7;

# Staring from the 3rd highest credit limit, get the next 5 customers
SELECT 
    contactLastname,
    contactFirstname,
    customerNumber,
    state,
    city,
    creditLimit
FROM
    customers
ORDER BY creditlimit DESC
LIMIT 5 OFFSET 3;
#LIMIT 3, 5;

# Combine all the clauses - WHERE + GROUPBY + HAVING + ORDER BY + LIMIT
# Find the top 2 cities in california with the highest Average Credit Limit for customers

SELECT 
    city, AVG(creditLimit) as AvgCreditLimit
FROM
    customers
WHERE
    state like "CA"
GROUP BY city DESC
HAVING city like "San%"
ORDER BY AvgCreditLimit DESC
LIMIT 2;

#################### STATISTICAL FUNCTION ####################
# find the most frequently occuring (mode) buyPrice across products
SELECT
    buyPrice AS buyPriceMode,
    productName
FROM
    products
GROUP BY 1,2
ORDER BY COUNT(1) DESC
LIMIT 1;


#ref : http://www.mysqltutorial.org/