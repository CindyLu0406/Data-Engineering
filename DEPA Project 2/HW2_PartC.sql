/***********************************************
** File: Assignment2-PartC.sql
** Desc: Combining Data, Nested Queries, Views and Indexes, Transforming Data
** Author: Qianhui Ma
** Date: 2019-05-01
************************************************/

############################### QUESTION 1 ###############################
# a) List the actors (firstName, lastName) who acted in more then 25 movies.
# Note: Also show the count of movies against each actor
SELECT 
    a.first_name,
    a.last_name,
    COUNT(DISTINCT f.film_id) AS TotalNumberOfMovies
FROM
    film_actor f
        INNER JOIN
    actor a USING (actor_id)
GROUP BY a.actor_id 
HAVING totalNumberOfMovies > 25
ORDER BY a.actor_id;

# b) List the actors who have worked in the German language movies.
# Note: Please execute the below SQL before answering this question.
SET SQL_SAFE_UPDATES=0;
UPDATE film SET language_id=6 WHERE title LIKE "%ACADEMY%";

SELECT 
    l.language_id, l.name, a.actor_id, a.first_name, a.last_name
FROM
    language l
        INNER JOIN
    film f ON l.language_id = f.language_id
        INNER JOIN
    film_actor fa ON f.film_id = fa.film_id
        INNER JOIN
    actor a ON fa.actor_id = a.actor_id
WHERE
    l.language_id = 6;

# c) List the actors who acted in horror movies.
SELECT 
    c.name, a.first_name, a.last_name
FROM
    category c
        INNER JOIN
    film_category fc ON c.category_id = fc.category_id
        INNER JOIN
    film_actor fa ON fc.film_id = fa.film_id
        INNER JOIN
    actor a ON fa.actor_id = a.actor_id
WHERE
    c.name = 'horror';
 
 # d) List all customers who rented more than 3 horror movies.
# Note: Show the count of movies against each actor in the result set.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(fc.film_id) AS NumberOfHorrorMovies,
    a.first_name,
    a.last_name
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
        INNER JOIN
    inventory i ON i.inventory_id = r.inventory_id
        INNER JOIN
    film_category fc ON fc.film_id = i.film_id
        INNER JOIN
    category ca ON ca.category_id = fc.category_id
        INNER JOIN
    film_actor fa ON fc.film_id = fa.film_id
        INNER JOIN
    actor a ON fa.actor_id = a.actor_id
WHERE
    ca.name = 'Horror'
GROUP BY c.customer_id
HAVING NumberOfHorrorMovies > 3; 

# e) List all customers who rented the movie which starred SCARLETT BENING
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name,
    fa.film_id,
    a.first_name,
    a.last_name
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
        INNER JOIN
    inventory i ON i.inventory_id = r.inventory_id
        INNER JOIN
    film_actor fa ON fa.film_id = i.film_id
        INNER JOIN
    actor a ON a.actor_id = fa.actor_id
WHERE
    a.first_name = 'SCARLETT'
        AND a.last_name = 'BENING';
        
# f) Which customers residing at postal code 62703 rented movies that were Documentaries.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    ad.address,
    ad.address2,
    ad.postal_code,
    ca.name
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
        INNER JOIN
    inventory i ON i.inventory_id = r.inventory_id
        INNER JOIN
    film_category fc ON fc.film_id = i.film_id
        INNER JOIN
    category ca ON ca.category_id = fc.category_id
        INNER JOIN
    address ad ON ad.address_id = c.address_id
WHERE
    ca.name = 'Documentary'
        AND ad.postal_code = '62703';

# g) Find all the addresses where the second address line is not empty (i.e., contains some text), and return these second addresses sorted.
SELECT 
    address, address2
FROM
    address
WHERE
    TRIM(address2) IS NOT NULL
ORDER BY address2;

# h) How many films involve a “Crocodile” and a “Shark” based on film description?
SELECT 
    COUNT(distinct film_id) AS NumberOfFilms
FROM
    film
WHERE
    description LIKE '%Crocodile%'
        AND description LIKE '%Shark%';

# i) List the actors who played in a film involving a “Crocodile” and a “Shark”, along with the release year of the movie, sorted by the actors’ last names.
SELECT DISTINCT
    a.first_name,
    a.last_name,
    f.title,
    f.description,
    f.release_year
FROM
    film f
        INNER JOIN
    film_actor fa ON f.film_id = fa.film_id
        INNER JOIN
    actor a ON a.actor_id = fa.actor_id
WHERE
    description LIKE '%Crocodile%'
        AND description LIKE '%Shark%'
ORDER BY a.last_name;

# j) Find all the film categories in which there are between 55 and 65 films. Return the names of categories and the number of films per category, sorted from highest to lowest by the number of films.
SELECT 
    fc.category_id,
    COUNT(DISTINCT f.film_id) AS NumberOfFilmsPerCategory
FROM
    category c
        INNER JOIN
    film_category fc ON c.category_id = fc.category_id
        INNER JOIN
    film f ON f.film_id = fc.category_id
GROUP BY fc.category_id
HAVING NumberOfFilmsPerCategory BETWEEN 55 AND 65
ORDER BY NumberOfFilmsPerCategory DESC;

# k) In which of the film categories is the average difference between the film replacement cost and the rental rate larger than 17$?
SELECT 
    c.name,
    AVG(f.replacement_cost) AS avgReplacementCost,
    AVG(f.rental_rate) AS avgRentalRate,
    ABS(AVG(f.replacement_cost) - AVG(f.rental_rate)) AS avgDifference
FROM
    category c
        INNER JOIN
    film_category fc ON c.category_id = fc.category_id
        INNER JOIN
    film f ON f.film_id = fc.film_id
GROUP BY c.name
HAVING avgDifference > 17;

# l) Many DVD stores produce a daily list of overdue rentals so that customers can be contacted and asked to return their overdue DVDs.
#To create such a list, search the rental table for films with a return date that is NULL and where the rental date is further in the past than the rental duration specified in the film table.
#If so, the film is overdue and we should produce the name of the film along with the customer name and phone number.
SELECT 
    c.first_name,
    c.last_name,
    ad.phone,
    f.title,
    r.rental_date,
    r.return_date,
    f.rental_duration,
    DATEDIFF(r.return_date, r.rental_date) AS actualrentalduration
FROM
    customer c
        LEFT JOIN
    rental r ON r.customer_id = c.customer_id
        LEFT JOIN
    address ad ON c.address_id = ad.address_id
        LEFT JOIN
    inventory i ON i.inventory_id = r.inventory_id
        LEFT JOIN
    film f ON f.film_id = i.film_id
WHERE
    DATEDIFF(r.return_date, r.rental_date) > f.rental_duration
        OR r.return_date IS NULL;

# m) Find the list of all customers and staff given a store id
# Note : use a set operator, do not remove duplicates





############################### QUESTION 2 ###############################
# a) List actors and customers whose first name is the same as the first name of the actor with ID 8.
SELECT
	a.actor_id,
    a.first_name,
    a.last_name,
    c.first_name,
    c.last_name
FROM
	actor AS a, customer AS c
WHERE
	a.first_name = c.first_name AND a.actor_id = 8;

# b) List customers and payment amounts, with payments greater than average the payment amount
SELECT 
    c.customer_id, c.first_name, c.last_name, p.amount
FROM
    customer c,
    payment p
WHERE
    p.amount > (SELECT 
            AVG(amount)
        FROM
            payment);

# c) List customers who have rented movies at least once
# Note: use IN clause
SELECT 
    first_name, last_name, customer_id
FROM
    customer
WHERE
    customer_id IN (SELECT DISTINCT
            customer_id
        FROM
            rental);

# d) Find the floor of the maximum, minimum and average payment amount
SELECT
    FLOOR(MAX(amount)) AS avgMaxPayment,
	FLOOR(MIN(amount)) AS avgMinPayment,
    FLOOR(AVG(amount)) AS avgMinPayment
FROM 
	payment;

############################### QUESTION 3 ###############################
# a) Create a view called actors_portfolio which contains information about actors and films ( including titles and category).
DROP VIEW IF EXISTS actors_portfolio;
CREATE VIEW actors_portfolio AS
    SELECT 
        a.actor_id,
        a.first_name,
        a.last_name,
        f.film_id,
        f.title,
        f.description,
        f.release_year,
        f.language_id,
        f.original_language_id,
        f.rental_duration,
        f.rental_rate,
        f.length,
        f.replacement_cost,
        f.rating,
        f.special_features,
        c.name AS category_name
    FROM
        actor a
            LEFT JOIN
        film_actor fa ON a.actor_id = fa.actor_id
            LEFT JOIN
        film f ON f.film_id = fa.film_id
            LEFT JOIN
        film_category fc ON fc.film_id = f.film_id
            LEFT JOIN
        category c ON c.category_id = fc.category_id;

# b) Describe the structure of the view and query the view to get information on the actor ADAM GRANT
DESCRIBE actors_portfolio;
SELECT 
    *
FROM
    actors_portfolio
WHERE
    first_name = 'ADAM'
        AND last_name = 'GRANT';

# c) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT




############################### QUESTION 4 ###############################
# a) Extract the street number ( characters 1 through 4 ) from customer addressLine1
SELECT 
    cu.first_name,
    cu.last_name,
    SUBSTRING(address, 1, 4) AS streetNumber
FROM
    customer AS cu
        INNER JOIN
    address USING (address_id);

# b) Find out actors whose last name starts with character A, B or C.
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name REGEXP '^[ABC].*$'
ORDER BY last_name;

# c) Find film titles that contains exactly 10 characters
SELECT 
    title
FROM
    film
WHERE
    title REGEXP '^.{10}$';  

# d) Format a payment_date using the following format e.g "22/1/2016"
SELECT 
    DATE_FORMAT(payment_date, '%d/%m/%y') AS 'NewPayment_Date'
FROM
    payment;

# e) Find the number of days between two date values rental_date & return_date
SELECT 
    rental_date,
    return_date,
    DATEDIFF(return_date, rental_date) AS NumberOfDays
FROM
    rental
ORDER BY rental_date DESC;

############################### QUESTION 5 ###############################
# Provide five additional queries and indicate the specific business use cases they address.
# 1) List the number of movies ( title & description ) that are rated PG-13 ?
SELECT 
    COUNT(DISTINCT title)
FROM
    film
WHERE
    rating = 'PG-13';

# 2) Top 2 movies that are rated PG-13 with the highest replacement cost ?
SELECT 
    film_id, title, replacement_cost, rating
FROM
    film
WHERE
    rating = 'PG-13'
GROUP BY film_id
ORDER BY replacement_cost DESC
LIMIT 5;

# 3) Find rental rate freqence across products in descending order
SELECT 
    rental_rate, COUNT(rental_rate) AS RentalRateMode
FROM
    film
GROUP BY rental_rate
ORDER BY RentalRateMode DESC;

# 4) List movies with movie length shorter than 50mins.
SELECT DISTINCT
    film_id, title, length, special_features
FROM
    film
WHERE
    length < 50
GROUP BY film_id DESC
ORDER BY length DESC;

# 5) Find the movies where rental rate is greater than 5$ and order result set by descending order.
SELECT DISTINCT
    film_id, title, rental_rate
FROM
    film
GROUP BY film_id ASC
HAVING rental_rate > 5
ORDER BY rental_rate DESC;


SELECT 
	p.customer_id,
    count(p.customer_id) as n_of_payment,
    count(r.rental_id) as n_of_rental
FROM
     rental r INNER JOIN 
     payment p ON r.customer_id = p.customer_id;
    
SELECT distinct
	p.customer_id,
    count(p.customer_id) as n_of_payment,
    count(r.customer_id) as n_of_rental
FROM
	rental r RIGHT JOIN 
    payment p ON r.customer_id = p.customer_id
Group by r.customer_id
ORDER BY n_of_payment DESC;



