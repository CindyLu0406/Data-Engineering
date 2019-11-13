/***********************************************
** DATA ENGINEERING PLATFORMS (MSCA 31012)
** File: Session4-Module1.sql
** Desc: Combining Data (DML)
** Auth: Shreenidhi Bharadwaj
** Date: 1/27/2018
** Ref : http://www.mysqltutorial.org/
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/

# select database
USE classicmodels;

######################## ALIAS ########################
# allows SQL queries and the result set to be more readable

# column alias - customerName column & postalCode column
# table alias - customer table
SELECT
	customerNumber,
    customerName AS businessName,
    contactFirstName,
    contactLastName,
    postalCode AS postCode
FROM
    customers AS cust;

################################## JOINS  ###############################
# A join combines two or more tables to retrieve data from multiple tables
# INNER JOIN: Returns all rows when there is at least one match in BOTH tables
# Outer JOIN : 
# 	LEFT JOIN: Return all rows from the left table, and the matched rows from the right table
# 	RIGHT JOIN: Return all rows from the right table, and the matched rows from the left table
# 	FULL JOIN: Return all rows when there is a match in ONE of the tables
#   LEFT JOIN and RIGHT JOIN are shorthand for LEFT OUTER JOIN and RIGHT OUTER JOIN

######################## INNER JOIN OR EQUI JOINS ########################
# Returns all rows when there is at least one match in BOTH tables ( intersection )
# by joining two tables with a common column 

# old Syntax for inner joins
SELECT 
	c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.postalCode,
    o.orderNumber, 
    o.orderDate,
    o.status
FROM
    customers AS C,
    orders AS o
WHERE
	C.customerNumber = o.customerNumber;

# returns customers that have placed an order ( 2 tables )  
# with join - 326 rows
SELECT
	c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.postalCode,
    o.orderNumber, 
    o.orderDate,
    o.status
FROM
    customers c
        INNER JOIN
	orders o ON c.customerNumber = o.customerNumber;
    

#################### CROSS JOIN  OR The Cartesian Product ##################
# without the where clause - 122 consumer records * 326 order records = 39772
SELECT
	c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.postalCode,
    o.orderNumber, 
    o.orderDate,
    o.status
FROM
    customers c, orders o;

# Exercise : join customers and order tables using the CROSS JOIN keyword

    
# products customerNumber 119 brought and the status of each ( 3 tables )
SELECT
	c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.postalCode,
    o.customerNumber,
    o.orderNumber,
    o.orderDate,
    o.status,
    d.productCode
FROM
    customers c
        INNER JOIN
    orders o ON c.customerNumber = o.customerNumber
        INNER JOIN
    orderDetails d ON o.orderNumber = d.orderNumber
WHERE
    c.customerNumber = 119;
    
       
######################## NATURAL JOIN ########################
# A Natural Join is where 2 tables are joined on the basis of all common columns. 
# same as inner join but eliminates duplicate columns in the joining columns
# customerNumber duplicated on the first query - first column and the last column
SELECT 
    *
FROM
    customers c
        INNER JOIN
    orders o ON c.customerNumber = o.customerNumber;

# with natural join - No ON criteria match
SELECT 
    *
FROM
    customers
        NATURAL JOIN
    orders;
    
######################## LEFT JOIN ########################
# select rows from the both left and right tables that are matched, 
# plus all rows from the left table ( T1 ) even there is no match 
# found for them in the right table ( T2 ).
SELECT 
	c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.postalCode,
    orderNumber,
    o.orderDate,
    o.STATUS
FROM
    customers c
        LEFT JOIN
    orders o ON c.customerNumber = o.customerNumber

# rows in the left table that do not match with the rows in the right table
# customers who have not placed orders
WHERE
 orderNumber IS NULL;
 
# Exercise : products customerNumber 119 brought and the status of each ( 3 tables )
# HINT : USE LEFT JOINS on customers, orders and orderDetails tables

    
# list the offices where each employee works along with the office address
SELECT 
    e.employeeNumber,
    e.firstName,
    e.lastName,
    o.officeCode,
    o.city
FROM
    employees e
        LEFT OUTER JOIN
    offices o ON e.officecode = o.officecode;

# insert a record into the employees table
INSERT  INTO `employees` 
 (`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`, `jobTitle`) 
VALUES 
 (2045,'Doe','John','x5801','jdoe@classicmodelcars.com',7,NULL,'founder');

SELECT 
    e.employeeNumber,
    e.firstName,
    e.lastName,
    o.officeCode,
    o.city
FROM
    employees e
        LEFT OUTER JOIN
    offices o ON e.officecode = o.officecode;

# Exercise : delete employeeNumber 2045 record from the employee table



######################## RIGHT JOIN ########################
# The RIGHT JOIN keyword returns all the rows from the right table 
# even if there are no matches in the left table.
SELECT 
	c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.postalCode,
    orderNumber,
    o.orderDate,
    o.STATUS
FROM
    customers c
        RIGHT outer JOIN
    orders o ON c.customerNumber = o.customerNumber;

SELECT 
	c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.postalCode,
    o.orderNumber,
    o.orderDate,
    productCode,
    o.STATUS
FROM
    customers c
        RIGHT OUTER JOIN
    orders o ON c.customerNumber = o.customerNumber
        RIGHT OUTER JOIN
    orderDetails d ON o.orderNumber = d.orderNumber
WHERE
    c.customerNumber = 119;
    
# rows in the left table that do not match with the rows in the right table
# WHERE
#  c.customerNumber = 125; / * OR 168 */


######################## SELF JOIN ########################
# list of employees along with their managers and designation ( organization structure )
SELECT 
    e1.firstName  AS managerFirstName,
    e1.lastName   AS managerLastName,
    e1.jobTitle	  AS managerJobTitle,
    e2.firstName  AS empFirstName,
    e2.lastName   AS empLastName,
    e2.jobTitle   AS empJobTitle
FROM
    employees e1,
    employees e2
WHERE
    e1.employeeNumber = e2.reportsTo;

# same results as above using INNER JOIN    
SELECT 
    e1.firstName  AS managerFirstName,
    e1.lastName   AS managerLastName,
    e1.jobTitle	  AS managerJobTitle,
    e2.firstName  AS empFirstName,
    e2.lastName   AS empLastName,
    e2.jobTitle   AS empJobTitle
FROM
    employees e1
INNER JOIN
	employees e2
ON
    e1.employeeNumber = e2.reportsTo;    

    
# Additional Queries with GroupBy and Having
# Total revenue for each year for the products that were shipped ?
SELECT 
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orders
        INNER JOIN
    orderdetails USING (orderNumber)
WHERE
    status = 'Shipped'
GROUP BY YEAR(orderDate);


# Exercise : Find all the orders that were shipped with total sales greater than $1500


#### SET OPERATORS - UNION is the only compound operator supported in MySQL ####
# union on customers and offices based on location  
(SELECT 
    city,state,country
FROM
    customers) UNION (SELECT 
    city,state,country
FROM
    offices) 
ORDER BY 2 , 1;

# Remove states with NULL value
(SELECT 
    city,state,country
FROM
    customers
WHERE state is NOT NULL ) UNION (SELECT 
    city,state,country
FROM
    offices
WHERE state is NOT NULL) 
ORDER BY 2 , 1; 

# UNION ALL operator does not remove duplicates - check city San Francisco
(SELECT 
    city,state,country
FROM
    customers
WHERE state is NOT NULL ) UNION ALL (SELECT 
    city,state,country
FROM
    offices
WHERE state is NOT NULL) 
ORDER BY 2 , 1; 


# Full Outer Join - My SQL does not support Full Outer Joins
SELECT
	c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    c.postalCode,
    o.orderNumber, 
    o.orderDate,
    o.status
FROM
    customers c
        FULL OUTER JOIN
    orders o ON c.customerNumber = o.customerNumber;

# Below is the syntax to get to full join. The first query relating to Left Join returns 350 rows and second query relating to the Right Join returns 326 rows totalling 676 rows. Check for customer number 206 that exists in the customer table but not in orders table
SELECT * FROM customers
LEFT JOIN orders ON customers.customerNumber = orders.customerNumber
UNION ALL
SELECT * FROM customers
RIGHT JOIN orders ON customers.customerNumber = orders.customerNumber;

ref : http://www.mysqltutorial.org/