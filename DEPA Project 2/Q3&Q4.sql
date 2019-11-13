######## QUESTION 3 ######## – { 10 Points }
# a) Show total number of movies
SELECT COUNT(film_id) AS total_number
FROM sakila.film;

# b) What is the minimum payment received and max payment received across all transactions ?
SELECT MIN(amount) AS min_payment, MAX(amount) AS max_payment
FROM sakila.payment;
# c) Number of customers that rented movies between Feb-2005 & May-2005 ( based on paymentDate ).
SELECT COUNT(customer_id) AS num_of_cus
FROM sakila.payment
WHERE payment_date BETWEEN '2005-02-01' AND '2005-05-31';

# d) List all movies where replacement_cost is greater than 15$ or rental_duration is between 6 & 10 days
SELECT title
FROM sakila.film
WHERE replacement_cost > 15 OR rental_duration BETWEEN 6 AND 10;
# e) What is the total amount spent by customers for movies in the year 2005 ? 
SELECT SUM(amount)
FROM sakila.payment
WHERE payment_date BETWEEN '2005-01-01' AND '2005-12-31';

# f) What is the average replacement cost across all movies ?
SELECT AVG(replacement_cost)
FROM sakila.film;
# g) What is the standard deviation of rental rate across all movies ?
SELECT STD(rental_rate)
FROM sakila.film;
# h) What is the midrange of the rental duration for all movies
SELECT (MAX(rental_duration) + MIN(rental_duration))/2 AS midrange
FROM sakila.film;


######## QUESTION 4 ######## – { 10 Points }
# a) Customers sorted by first Name and last name in ascending order.
SELECT *
FROM customer
ORDER BY first_name, last_name;
# b) Count of movies that are either G/NC-17/PG-13/PG/R grouped by rating.
SELECT COUNT(film_id) AS movies, rating
FROM film
WHERE rating ='G' OR rating ='NC-17' OR rating ='PG-13' OR rating ='PG' OR rating ='R'
GROUP BY rating;

# c) Number of addresses in each district.
SELECT COUNT(address_id), district
FROM address
GROUP BY district
ORDER BY district;
# d) Find the movies where rental rate is greater than 1$ and order result set by descending order.
SELECT title
FROM film
WHERE rental_rate > 1
ORDER BY rental_rate DESC;
# e) Top 2 movies that are rated R with the highest replacement cost ?
SELECT title
FROM film
WHERE rating = 'R' 
ORDER BY replacement_cost DESC
LIMIT 2;
# f) Find the most frequently occurring (mode) rental rate across products.
SELECT COUNT(title), rental_rate
FROM film
GROUP BY rental_rate
ORDER BY COUNT(title) DESC
LIMIT 1;

# g) Find the top 2 movies with movie length greater than 50mins and which has commentaries as a special features.
SELECT title
FROM film
WHERE length > 50 AND special_features LIKE '%Commentaries%';
# h) List the years which has more than 2 movies released.
SELECT release_year
FROM film
GROUP BY release_year
HAVING COUNT(film_id) > 2;

# Part C (Individual): Combining Data, Nested Queries, Views and Indexes, Transforming Data
/***********************************************
** File: Assignment2-PartC.sql
** Desc: Combining Data, Nested Queries, Views and Indexes, Transforming Data 
** Author:
** Date:
************************************************/
######## QUESTION 1 ######## – { 20 Points } 
# a) List the actors (firstName, lastName) who acted in more then 25 movies.
# Note: Also show the count of movies against each actor
SELECT a.first_name AS firstName, a.last_name , COUNT(f.film_id) AS count_movies
FROM actor a
RIGHT JOIN film_actor f
ON f.actor_id = a.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(f.film_id) > 25
ORDER BY a.first_name, a.last_name;
# b) List the actors who have worked in the German language movies.
# Note: Please execute the below SQL before answering this question.
SET SQL_SAFE_UPDATES=0;
UPDATE film SET language_id=6 WHERE title LIKE "%ACADEMY%";


SELECT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
LEFT JOIN film f
ON fa.film_id = f.film_id
LEFT JOIN language l
ON f.language_id = l.language_id
WHERE l.name = 'German';


# c) List the actors who acted in horror movies.
# Note: Show the count of movies against each actor in the result set.
SELECT a.first_name, a.last_name, COUNT(f.film_id)
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
LEFT JOIN film f
ON fa.film_id = f.film_id
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'horror'
GROUP BY a.first_name, a.last_name;
# d) List all customers who rented more than 3 horror movies.
SELECT c.first_name, c.last_name
FROM customer c
RIGHT JOIN rental r
ON c.customer_id = r.customer_id
LEFT JOIN inventory i
ON r.inventory_id = i.inventory_id
LEFT JOIN film_category fc
ON i.film_id = fc.film_id
LEFT JOIN category ca
ON fc.category_id = ca.category_id
WHERE ca.name = 'horror'
GROUP BY c.first_name, c.last_name
HAVING COUNT(fc.film_id) > 3;
# e) List all customers who rented the movie which starred SCARLETT BENING
SELECT c.first_name, c.last_name
FROM customer c
RIGHT JOIN rental r
ON c.customer_id = r.customer_id
LEFT JOIN inventory i
ON r.inventory_id = i.inventory_id
LEFT JOIN film_actor fa
ON i.film_id = fa.film_id
LEFT JOIN actor a
ON fa.actor_id = a.actor_id
WHERE a.first_name = 'SCARLETT' AND a.last_name = 'BENING';

# f) Which customers residing at postal code 62703 rented movies that were Documentaries.
SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN address a
ON c.address_id = a.address_id
RIGHT JOIN rental r
ON c.customer_id = r.customer_id
LEFT JOIN inventory i
ON r.inventory_id = i.inventory_id
LEFT JOIN film_category fc
ON i.film_id = fc.film_id
LEFT JOIN category ca
ON fc.category_id = ca.category_id
WHERE ca.name = 'Documentaries' AND a.postal_code = '62703';

# g) Find all the addresses where the second address line is not empty (i.e., contains some text), and return these second addresses sorted.
#奇怪
SELECT *
FROM address
WHERE address2 IS NOT NULL
ORDER BY address2;

# h) How many films involve a “Crocodile” and a “Shark” based on film description ?
SELECT COUNT(film_id)
FROM film
WHERE description LIKE '%Crocodile%' AND description LIKE '%Shark%';

# i) List the actors who played in a film involving a “Crocodile” and a “Shark”, along with the release year of the movie, sorted by the actors’ last names.
SELECT a.first_name, a.last_name, f.release_year
FROM film_actor fa
LEFT JOIN actor a
ON fa.actor_id = a.actor_id
LEFT JOIN film f
ON fa.film_id = f.film_id
WHERE f.description LIKE '%Crocodile%' AND f.description LIKE '%Shark%'
ORDER BY a.last_name;
# j) Find all the film categories in which there are between 55 and 65 films. Return the names of categories and the number of films per category, sorted from highest to lowest by the number of films.
SELECT c.name, COUNT(fc.film_id) AS num_films
FROM film_category fc
LEFT JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.name
HAVING COUNT(fc.film_id) BETWEEN 55 AND 65
ORDER BY COUNT(fc.film_id) DESC;

# k) In which of the film categories is the average difference between the film replacement cost and the rental rate larger than 17$?
SELECT cg_name
FROM
(SELECT c.name AS cg_name, AVG(f.replacement_cost) AS ave_replace, AVG(f.rental_rate) AS ave_rate
FROM film_category fc
LEFT JOIN category c
ON fc.category_id = c.category_id
LEFT JOIN film f
ON fc.film_id = f.film_id
GROUP BY C.name) AS T1
WHERE ave_replace - ave_rate >17;

# l) Many DVD stores produce a daily list of overdue rentals so that customers can be contacted 
# and asked to return their overdue DVDs. To create such a list, search the rental table for films 
# with a return date that is NULL and where the rental date is further in the past than the 
# rental duration specified in the film table. If so, the film is overdue and we should produce 
# the name of the film along with the customer name and phone number.
SELECT *
FROM rental
WHERE return_date IS NULL;

# m) Find the list of all customers and staff given a store id # Note : use a set operator, do not remove duplicates

SELECT store_id, first_name, last_name 
FROM customer
UNION ALL
SELECT store_id, first_name, last_name
FROM staff
ORDER BY store_id;
######## QUESTION 2 ######## – { 10 Points } 
# a) List actors and customers whose first name is the same as the first name of the actor with ID 8.
#method1
SELECT a.first_name AS actfirst, a.last_name AS actlast, cusfirstname, cuslastname
FROM actor a
JOIN 
(SELECT first_name AS cusfirstname, last_name AS cuslastname
FROM customer
WHERE first_name = (SELECT first_name
FROM actor
WHERE actor_id = 8)) AS t1
ON a.first_name = t1.cusfirstname;

#method2
SELECT first_name, last_name, 'customer' AS people
FROM customer
WHERE first_name = (SELECT first_name
FROM actor
WHERE actor_id = 8)
UNION ALL
SELECT first_name, last_name, 'actor' AS people
FROM actor
WHERE first_name = (SELECT first_name
FROM actor
WHERE actor_id = 8);

# b) List customers and payment amounts, with payments greater than average the payment amount
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount)
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1,2,3
HAVING SUM(p.amount) > (SELECT SUM(amount)/COUNT(DISTINCT customer_id) AS ave_pay FROM payment);

# c) List customers who have rented movies atleast once # Note: use IN clause
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (SELECT DISTINCT customer_id FROM rental);

# d) Find the floor of the maximum, minimum and average payment amount
SELECT MAX(amount), MIN(amount), AVG(amount)
FROM payment;

######## QUESTION 3 ######## – { 5 Points } 
# a) Create a view called actors_portfolio which contains information about actors and films ( including titles and category).
#DROP VIEW actors_portfolio;
CREATE OR REPLACE VIEW actors_portfolio AS
SELECT CONCAT(a.first_name,' ',a.last_name) AS actor, f.title AS title, c.name AS category
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
LEFT JOIN film f
ON fa.film_id = f.film_id
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id;
# b) Describe the structure of the view and query the view to get information on the actor ADAM GRANT
SELECT *
FROM actors_portfolio
WHERE actor = 'ADAM GRANT';
# c) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT
#???
INSERT INTO actors_portfolio (actor, title, category)
VALUES('ADAM GRANT','Data Hero','Sci-Fi');


######## QUESTION 4 ######## – { 5 Points } 
# a) Extract the street number ( characters 1 through 4 ) from customer addressLine1
SELECT SUBSTRING(address,1,4) AS StreetNumber
FROM address;

# b) Find out actors whose last name starts with character A, B or C.
SELECT *
FROM actor
WHERE last_name LIKE 'A%' OR last_name LIKE 'B%' OR last_name LIKE 'C%';
# c) Find film titles that contains exactly 10 characters
SELECT title
FROM film
WHERE CHAR_LENGTH(title) = 10;

SELECT title
FROM film
WHERE title REGEXP '^.{10}$';
# d) Format a payment_date using the following format e.g "22/1/2016"
SELECT DATE_FORMAT(payment_date, '%d-%m-%Y') AS Newformat
FROM payment;
# e) Find the number of days between two date values rental_date & return_date
SELECT DATEDIFF(return_date, rental_date) AS numberofDays
FROM rental;
######## QUESTION 5 ######## – { 20 Points } 
# Provide 5 additional queries and indicate the specific business use cases they address.

