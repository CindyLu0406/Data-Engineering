SHOW DATABASES;
USE sakila;
SHOW TABLES;

-- Q1
SELECT c.first_name, c.last_name, COUNT(r.rental_id)
FROM customer AS c
INNER JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY  c.first_name, c.last_name
ORDER BY 3 DESC
LIMIT 10;


-- Q2
SELECT EXTRACT(year FROM r.rental_date) AS whichYear, c.name AS categoryNAME, COUNT(*) AS num
FROM rental r
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id INNER JOIN film f
ON i.film_id = f.film_id
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id GROUP BY 1,2
ORDER BY 1, 3 DESC;

-- Q3
SELECT
c.first_name,
c.last_name,
ad.phone,
f.title,
DATEDIFF(r.return_date, r.rental_date) AS actualrentalduration
FROM customer c
LEFT JOIN
rental r ON r.customer_id = c.customer_id
LEFT JOIN
address ad ON c.address_id = ad.address_id
LEFT JOIN
inventory i ON i.inventory_id = r.inventory_id
LEFT JOIN
film f ON f.film_id = i.film_id
WHERE
DATEDIFF(r.return_date, r.rental_date) > 7
OR r.return_date IS NULL;

-- Q4
SELECT CONCAT(first_name, ' ', last_name) as actor_name
from actor

-- Q5
select title from film where title like '%\a'

-- Q6

-- Run for test with errors. Ignore this section please
-- select c.cutomer_id, c.first_name, c.last_name, COUNT(r.rental_id)
-- FROM customer AS c
-- INNER JOIN rental AS r
-- ON c.customer_id = r.customer_id
-- GROUP BY  c.first_name, c.last_name
-- where count(r.rental_id) = 0

-- 1.
SELECT customer_id, first_name, last_name
FROM sakila.customer
WHERE customer_id NOT IN
(SELECT DISTINCT customer_id 
FROM sakila.rental)

-- 2.
select c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id)
FROM sakila.customer AS c
INNER JOIN sakila.rental AS r
ON c.customer_id = r.customer_id
GROUP BY  c.customer_id, c.first_name, c.last_name
HAVING count(r.rental_id) = 0;

-- Q7
SELECT
rating, count(distinct(title))
FROM film
WHERE
rating = 'PG-13' or rating = 'PG'
group by rating;

-- Q8
select 
c.customer_id, c.first_name, c.last_name
from customer c 
inner join address a on c.address_id = a.address_id
inner join city on a.city_id = city.city_id
inner join country on city.country_id = country.country_id
where country = 'Nepal'

-- Q9
SELECT s.staff_id, SUM(DATEDIFF(r.return_date, r.rental_date) * f.rental_rate) AS revenue
FROM sakila.staff AS s
INNER JOIN sakila.rental AS r
ON s.staff_id = r.staff_id
INNER JOIN sakila.inventory AS i
ON r.inventory_id = i.inventory_id
INNER JOIN sakila.film AS f
ON i.film_id = f.film_id
GROUP BY s.staff_id;

-- Q10
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS available
FROM sakila.film AS f
INNER JOIN sakila.inventory AS i
ON f.film_id = i.film_id
GROUP BY 1,2;
