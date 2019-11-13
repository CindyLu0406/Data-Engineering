/***********************************************
** DATA ENGINEERING PLATFORMS (MSCA 31012)
** File: Session4-Module5.sql
** Desc: Transactions, Admin & Misc functions
** Auth: Shreenidhi Bharadwaj
** Date: 1/27/2019
** Ref : http://www.mysqltutorial.org/
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/

# select database
USE classicmodels;

################### USER DEFINED VARIABLES ###################
# pass a value from an SQL statement to another SQL statement
# within a particular session

# set variable 
SET @buyPrice:= 90;

# show all variables

# validate
Select @buyPrice AS buyPrice;

SELECT 
    productName,
    ProductVendor,
    buyPrice,
    MSRP
FROM
    products
WHERE
    buyPrice > @buyPrice;

# Use MAX function 
SELECT 
    @msrp:=MAX(msrp) AS maxMSRP
FROM
    products;

# user defined variable used in where clause
SELECT 
    productCode, productName, productLine, msrp
FROM
    products
WHERE
    msrp = @msrp;

# List all user variables
SELECT 
    *
FROM
    performance_schema.user_variables_by_thread;


################### EXPORT file (CSV) ###################
# Check the value set for the secure_file_priv variable
SHOW VARIABLES LIKE 'secure_file_priv';

# export result set to a CSV file
SELECT 
    orderNumber, status, orderDate, requiredDate, comments
FROM
    orders
WHERE
    status = 'Cancelled' 
# INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/cancelled_orders.csv' 
INTO OUTFILE '~/Users/zhongyizhang/Desktop/cancelled_orders.csv'
FIELDS ENCLOSED BY '"' 
TERMINATED BY ';' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n';

# exporting the data with column headings
(SELECT 'Order Number','Order Date','Status')
UNION 
(SELECT orderNumber,orderDate, status
FROM orders
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/cancelled_orders_with_headers.csv'
FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"'
LINES TERMINATED BY '\r\n');


################### TRANSACTIONS ###################
# START TRANSACTION, COMMIT,and ROLLBACK

# force MySQL not to commit changes automatically
SET AUTOCOMMIT = 0;

# start a new transaction 
START TRANSACTION;

# list all offices
SELECT * FROM offices;

# insert data relating to new offices into offices table
INSERT INTO `offices`(`officeCode`,`city`,`phone`,`addressLine1`,`addressLine2`,`state`,`country`,`postalcode`, `territory`) values 
('8', 'Chicago', '+1 312 219 4782', '100 clinton Street', 'Suite 300', 'IL', 'USA', '60661', 'NA'),
('9', 'Austin', '+1 512 974 9315', '500 Rutherford Lane', 'Suite 100', 'TX', 'USA', '78754', 'NA');

# list the offices and make sure the additional entries are reflected
SELECT * FROM offices;

# rollback the updates
ROLLBACK;

# notice that on ROLLBACK additional offices are not reflected in the offices table
SELECT * FROM offices;

# insert data again relating to new offices into offices table
INSERT INTO `offices`(`officeCode`,`city`,`phone`,`addressLine1`,`addressLine2`,`state`,`country`,`postalcode`, `territory`) values 
('8', 'Chicago', '+1 312 219 4782', '100 clinton Street', 'Suite 300', 'IL', 'USA', '60661', 'NA'),
('9', 'Austin', '+1 512 974 9315', '500 Rutherford Lane', 'Suite 100', 'TX', 'USA', '78754', 'NA');

# commit the above transaction
COMMIT;

# notice that once committed the transaction takes place and we have additional offices reflected
SELECT * FROM offices;

# delete the records that were added
SET SQL_SAFE_UPDATES=0;
DELETE FROM offices 
WHERE
    officecode IN (8 , 9);


# Another example of a transaction
# Get the latest sales order number from the orders table, and use the next sales order number as the new sales order number.
# Insert a new sales order into the orders table for a given customer.
# Insert new sales order items into the orderdetails table.
# Get data from both table orders and orderdetails tables to confirm the changes
START transaction;
 
# get latest order number
SELECT 
    @orderNumber:=MAX(orderNUmber)
FROM
    orders;

# set new order number
set @orderNumber = @orderNumber + 1;
SELECT @orderNumber AS newOrderNumber;

 
# insert a new order for customer 145
insert into orders(orderNumber,
                   orderDate,
                   requiredDate,
                   shippedDate,
                   status,
                   customerNumber)
values(@orderNumber,
       now(),
       date_add(now(), INTERVAL 5 DAY),
       date_add(now(), INTERVAL 2 DAY),
       'In Process',
        145);
        
# insert 2 order line items
insert into orderdetails(orderNumber,
                         productCode,
                         quantityOrdered,
                         priceEach,
                         orderLineNumber)
values(@orderNumber,'S18_1749', 30, '136', 1),
      (@orderNumber,'S18_2248', 50, '55.09', 2); 
   
# commit changes    
COMMIT;

# get the new inserted order
SELECT 
    *
FROM
    orders a
        INNER JOIN
    orderdetails b ON a.ordernumber = b.ordernumber
WHERE
    a.ordernumber = @ordernumber;

# delete added records
DELETE FROM orderdetails 
WHERE
    ordernumber = '10426';

DELETE FROM orders 
WHERE
    orderNumber = '10426';


# enable the default autocommit
SET autocommit = 1;


################### SINGLE TABLE/DATA BACKUPS ######################
CREATE TABLE classicmodels.offices_bkup LIKE classicmodels.offices;
INSERT INTO classicmodels.offices_bkup (SELECT * FROM classicmodels.offices);

# alternatively
CREATE TABLE IF NOT EXISTS offices_bkup 
SELECT 
	* 
FROM
	offices;

select * from offices_bkup;

# compare 2 tables to make sure the backup and the original tables are the same
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        offices UNION ALL SELECT 
        *
    FROM
        offices_bkup) tbl
GROUP BY officeCode, city
HAVING COUNT(*) = 1
ORDER BY officeCode;

# Insert additional data into the original table
INSERT INTO 
OFFICES 
(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory ) 
VALUES 
('11', 'Paris', '+33 14 723 5555', '43 Rue Jouffroy D\'abbans', NULL, NULL, 'France', '75017', 'EMEA' );

# compare 2 tables to make sure the new record is reflected.
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        offices UNION ALL SELECT 
        *
    FROM
        offices_bkup) tbl
GROUP BY officeCode, city
HAVING COUNT(*) = 1
ORDER BY officeCode;

# delete the data inserted.
SET SQL_SAFE_UPDATES=0;
DELETE FROM offices 
WHERE
    officecode=11;

# drop the backup table    
DROP table offices_bkup;

################### Temp tables ###################
# Temporary table is a special type of table that allows you to store a temporary result set, which you can reuse several times in a single session.

# Top 10 customers by revenue
CREATE TEMPORARY TABLE top10customers
SELECT p.customerNumber, 
       c.customerName, 
       FORMAT(SUM(p.amount),2) total
FROM payments p
INNER JOIN customers c ON c.customerNumber = p.customerNumber
GROUP BY p.customerNumber
ORDER BY total DESC
LIMIT 10;

# retrieve data from the temp table top10customers
SELECT * FROM top10customers;

# Drop the temporary table
DROP TEMPORARY TABLE top10customers;

################### DB ADMINISTRATION ###################
# DBA - managing user accounts, roles, privileges, and profiles 

# A consultant is hired and he/she needs access to the Orders table to solve a business problem. Access can be given based on the 
# requirements and once the work is complete the access rights to the table can be revoked.
CREATE USER 'manager'@'localhost' IDENTIFIED BY 'manager';
CREATE USER 'salesrep'@'localhost' IDENTIFIED BY 'sales';

# grant user salesrep all privileges to the orders tables */
GRANT ALL ON orders TO 'salesrep'@'localhost';

# grant execute the SELECT, INSERT and UPDATE statements against the classicmodels database
GRANT SELECT, INSERT, UPDATE, DELETE ON  classicmodels.* TO 'manager'@'localhost';

# update password for user salesrep
SET PASSWORD FOR 'salesrep'@'localhost' ='salesrep';

# now login as 'salesrep'@'localhost' and manager'@'localhost
# run the below insert statement and make sure it succeeds for manager and not for salesrep user.
INSERT INTO 
OFFICES 
(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory ) 
VALUES 
('11', 'Paris', '+33 14 723 5555', '43 Rue Jouffroy D\'abbans', NULL, NULL, 'France', '75017', 'EMEA' );


# revoke all privileges from the orders table for user manager & salesrep 
REVOKE ALL ON orders FROM 'manager'@'localhost';
REVOKE SELECT, UPDATE, DELETE ON classicmodels.* FROM 'salesrep'@'localhost';

DROP USER 'manager'@'localhost';
DROP USER 'salesrep'@'localhost';

# LOCK / UNLOCK
# client session to acquire a table lock explicitly for preventing other sessions from accessing the table offices during a specific period.
LOCK TABLE offices READ;

# try inserting data into the offices table
INSERT INTO 
OFFICES 
(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory ) 
VALUES 
('11', 'Paris', '+33 14 723 5555', '43 Rue Jouffroy D\'abbans', NULL, NULL, 'France', '75017', 'EMEA' );

# will get an error. unlock all tables.
UNLOCK TABLES;

# try insert a record after the unlock.
INSERT INTO 
OFFICES 
(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory ) 
VALUES 
('11', 'Paris', '+33 14 723 5555', '43 Rue Jouffroy D\'abbans', NULL, NULL, 'France', '75017', 'EMEA' );

# check to see if the data is inserted in the office table
select * from offices;

# delete the data inserted.
SET SQL_SAFE_UPDATES=0;
DELETE FROM offices 
WHERE
    officecode=11;
	

# Visual Explain Plan
# https://dev.mysql.com/doc/workbench/en/wb-tutorial-visual-explain-dbt3.html
use sakila;
SELECT CONCAT(customer.last_name, ', ', customer.first_name) AS customer, address.phone, film.title
FROM rental
INNER JOIN customer ON rental.customer_id = customer.customer_id
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date IS NULL
AND rental_date + INTERVAL film.rental_duration DAY < CURRENT_DATE()
LIMIT 5;


# MySQL Sequence
#  trainee_no column is an AUTO_INCREMENT colum
CREATE TABLE trainees (
    trainee_no INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

# Insert sample data
INSERT INTO trainees(first_name,last_name)
VALUES('John','Doe'),
      ('Mary','Jane');

# Validate
SELECT 
    *
FROM
    trainees;
    
# delete the second trainee whose trainee_no is 2
DELETE FROM trainees 
WHERE
    trainee_no = 2;


# Validate
SELECT 
    *
FROM
    trainees;
    
# Insert new trainee
INSERT INTO trainees(first_name,last_name)
VALUES('Jack','Lee');

# Validate
SELECT 
    *
FROM
    trainees;
    
# update an existing trainee with trainee_no 3 to 1
UPDATE trainees 
SET 
    first_name = 'Joe',
    trainee_no = 1
WHERE
    trainee_no = 3;
    
# Duplicate entry, lets fix it
UPDATE trainees 
SET 
    first_name = 'Joe',
    trainee_no = 5
WHERE
    trainee_no = 3;
    
# Validate
SELECT 
    *
FROM
    trainees;

# insert a new trainee
INSERT INTO trainees(first_name,last_name)
VALUES('Wang','Lee');

# Validate
SELECT 
    *
FROM
    trainees;
    
# insert a new trainee
INSERT INTO trainees(first_name,last_name)
VALUES('Shree','Bharadwaj');

# Validate
SELECT 
    *
FROM
    trainees;

# drop trainees table
drop table trainees;

#ref : http://www.mysqltutorial.org/
	