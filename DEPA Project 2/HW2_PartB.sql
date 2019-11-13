/***********************************************
** File: Assignment2-PartB.sql
** Desc: Manipulating, Categorizing, Sorting and Grouping & Summarizing Data
** Author: Qianhui Ma
** Date: 4/30/2019
************************************************/ 

############################### QUESTION 1 ###############################
# a) Show the list of databases.
SHOW DATABASES;
# b) Select sakila database.
USE sakila;
# c) Show all tables in the sakila database.
SHOW TABLES;
# d) Show each of the columns along with their data types for the actor table.
SELECT 
    *
FROM
    actor;
DESCRIBE actor;
# e) Show the total number of records in the actor table.
SELECT 
    COUNT(*)
FROM
    actor;
# f) What is the first name and last name of all the actors in the actor table ?
SELECT 
    first_name, last_name
FROM
    actor;
# g) Insert your first name and middle initial ( in the last name column ) into the actors table.
INSERT INTO `actor`
	(`actor_id`,`first_name`,`last_name`,`last_update`)  
VALUES 
('201','Qianhui','N/A','2019-04-29 12:58:10');
# h) Update your middle initial with your last name in the actors table.
SET SQL_SAFE_UPDATES = 0;

UPDATE actor 
SET 
    last_name = 'Ma'
WHERE
    last_name = 'N/A';

SELECT 
    *
FROM
    actor
WHERE
    actor_id = 201;
# i) Delete the record from the actor table where the first name matches your first name.


# j) Create a table payment_type with the following specifications and appropriate data types
# Table Name : “Payment_type”
# Primary Key: "payment_type_id”
# Column: “Type”
# Insert following rows in to the table: 1, “Credit Card” ; 2, “Cash”; 3, “Paypal” ; 4 , “Cheque” 

DROP TABLE IF EXISTS `Payment_type`;
CREATE TABLE `Payment_type` (
    `payment_type_id` SMALLINT(5) NOT NULL,
    `Type` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`payment_type_id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

INSERT INTO `Payment_type`
	(`payment_type_id`,`Type`) 
VALUES 
('1','Credit Card'),
('2','Cash'),
('3','Paypal'),
('4','Cheque');

# k) Rename table payment_type to payment_types
RENAME TABLE payment_type TO payment_types;

# l) Drop the table payment_types.
DROP TABLE payment_type;

############################### QUESTION 2 ###############################

# a) List all the movies ( title & description ) that are rated PG-13 ?
SELECT 
    title, description
FROM
    film
WHERE
    rating = 'PG-13';

# b) List all movies that are either PG OR PG-13 using IN operator ?
SELECT 
    *
FROM
    film
WHERE
    rating IN ('PG' , 'PG-13');
    
# c) Report all payments greater than and equal to 2$ and Less than equal to 7$ ?
# Note : write 2 separate queries conditional operator and BETWEEN keyword
SELECT 
    *
FROM
    payment
WHERE
    amount >= 2 AND amount <= 7;

SELECT 
     *
FROM
    payment
WHERE
    amount BETWEEN 2 AND 7;

# d) List all addresses that have phone number that contain digits 589, start with 140 or end with 589
# Note : write 3 different queries
SELECT
     *
FROM
     address
WHERE
     phone LIKE '%589%';

SELECT
     *
FROM
     address
WHERE
     phone LIKE '140%';
     
SELECT
     *
FROM
     address
WHERE
     phone LIKE '%589';

# e) List all staff members ( first name, last name, email ) whose password is NULL ?
SELECT
      first_name, last_name, email
FROM 
      staff
WHERE
      password is NULL;

# f) Select all films that have title names like ZOO and rental duration greater than or equal to 4
SELECT 
    *
FROM
    film
WHERE
    title LIKE '%ZOO%'
        AND rental_duration >= 4;
        
        
# g) What is the cost of renting the movie ACADEMY DINOSAUR for 2 weeks ?
# Note : use of column alias
SELECT 
    *, (rental_rate * 14) AS rentalCost
FROM
    film
WHERE
    title LIKE 'ACADEMY D%';

# h) List all unique districts where the customers, staff, and stores are located
# Note : check for NOT NULL values
SELECT DISTINCT
    district
FROM
    address
WHERE
    district IS NOT NULL;

# i) List the top 10 newest customers across all stores
SELECT 
    *
FROM
    customer
ORDER BY create_date DESC
LIMIT 10;

############################### QUESTION 3 ###############################
# a) Show total number of movies
SELECT
     COUNT(DISTINCT(film_id)) AS numberofmovies
FROM
     film;
     
# b) What is the minimum payment received and max payment received across all transactions ?
SELECT 
      MIN(amount) as MinRecieved
FROM 
      payment;

SELECT 
      MAX(amount) as MaxRecieved
FROM 
      payment;
      
# c) Number of customers that rented movies between Feb-2005 & May-2005 ( based on paymentDate ).
SELECT 
    COUNT(DISTINCT (customer_id)) AS TotalCustomers
FROM
    payment
WHERE
    payment_date >= '2005-02-01'
        AND payment_date < '2005-05-31';
        
# d) List all movies where replacement_cost is greater than 15$ or rental_duration is between 6 & 10 days
SELECT 
    *
FROM
    film
WHERE
    replacement_cost > 15
        OR rental_duration BETWEEN 6 AND 10;
        
# e) What is the total amount spent by customers for movies in the year 2005 ?
SELECT 
    SUM(amount) AS totalAmountSpent
FROM
    payment
WHERE
    payment_date BETWEEN '2005-01-01' AND '2005-12-31';

# f) What is the average replacement cost across all movies ?
SELECT 
    AVG(replacement_cost) AS AvgReplacementCost
FROM
    film;
    
# g) What is the standard deviation of rental rate across all movies ?
SELECT
    STD(rental_rate) AS StdRentalRate
FROM
    film;

# h) What is the midrange of the rental duration for all movies
SELECT 
    (MAX(rental_duration) + MIN(rental_duration)) / 2 AS MidRange
FROM
    film;
    
    
############################### QUESTION 4 ###############################
# a) Customers sorted by first Name and last name in ascending order.
SELECT 
    *
FROM
    customer
ORDER BY first_name , last_name ASC;

# b) Count of movies that are either G/NC-17/PG-13/PG/R grouped by rating.
SELECT 
    rating, COUNT(film_id) AS NumberOfMovies
FROM
    film
WHERE
    rating IN ('G' , 'NC-17', 'PG-13', 'PG', 'R')
GROUP BY rating;

# c) Number of addresses in each district.
SELECT
	 COUNT(address_id)
FROM 
	 address
GROUP BY
	 district;
     
# d) Find the movies where rental rate is greater than 1$ and order result set by descending order.
SELECT DISTINCT
    film_id, title, rental_rate
FROM
    film
HAVING rental_rate > 1
ORDER BY rental_rate ASC;

# e) Top 2 movies that are rated R with the highest replacement cost ?
SELECT DISTINCT
    film_id, title, replacement_cost, rating
FROM
    film
WHERE
    rating = 'R'
ORDER BY replacement_cost DESC
LIMIT 2;

# f) Find the most frequently occurring (mode) rental rate across products. 
SELECT 
	rental_rate, COUNT(rental_rate) AS RentalRateMode
FROM
    film
ORDER BY RentalRateMode DESC
LIMIT 1;

# g) Find the top 2 movies with movie length greater than 50mins and which has commentaries as a special features.
SELECT DISTINCT
    film_id, title, length, special_features
FROM
    film
WHERE
    length > 50
HAVING special_features LIKE '%commentaries%'
ORDER BY length DESC
LIMIT 2;

# h) List the years with more than 2 movies released.
SELECT 
     release_year, COUNT(DISTINCT film_id) as NumberOfMovies
FROM
     film
HAVING 
	NumberOfMovies > 2
ORDER BY release_year;



