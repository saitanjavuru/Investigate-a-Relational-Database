/* Sai Abhiroop Tanjavuru Investigate a Relational Database Project Queries */

/* QUESTION SET 1 */

/* Question 1:

We want to understand more about the movies that families are watching. 
The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music. 
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out. */

SELECT 
    f.title AS film_title, 
    c.name AS category_name, 
    COUNT(r.rental_id) AS rental_count
FROM 
    category AS c
    JOIN film_category AS fc
    ON c.category_id = fc.category_id 
    JOIN film AS f
    ON fc.film_id = f.film_id
    JOIN inventory AS i
    ON f.film_id = i.film_id
    JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 
    1, 2
ORDER BY 
    2, 1;

/* Question 2:

Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. 
Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) 
based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? 
Make sure to also indicate the category that these family-friendly movies fall into.

THIS QUERY DOES NOT NEED AN AGGREGATION!

*/

SELECT 
    t1.title, 
    t1.name,
    t1.rental_duration,
    t1.standard_quartile
FROM
    (SELECT 
        f.title, 
        c.name, 
        f.rental_duration, 
        NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
    FROM 
        category AS c
        JOIN film_category AS fc
        ON c.category_id = fc.category_id 
        JOIN film AS f
        ON fc.film_id = f.film_id    
    ) AS t1
WHERE t1.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 3;

/* Question 3:

Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies 
within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:

Category
Rental length category
Count

*/

SELECT 
    t1.name, 
    t1.standard_quartile, 
    COUNT(t1.standard_quartile)
FROM
    (SELECT 
        f.title, 
        c.name, 
        f.rental_duration, 
        NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
     FROM category AS c
        JOIN film_category AS fc
        ON c.category_id = fc.category_id 
        JOIN film AS f
        ON fc.film_id = f.film_id
     WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) AS t1
GROUP BY 
    1, 2
ORDER BY 
    1, 2;

/* QUESTION SET 2 */

/* Question 1

We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. 
Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. 
our table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

*/

SELECT 
    DATE_PART('month', r.rental_date) AS rental_month,
    DATE_PART('year', r.rental_date) AS rental_year,
    store.store_id,
    COUNT(*) AS count_rentals
FROM store
    JOIN staff
    ON store.store_id = staff.store_id
    JOIN rental AS r
    ON r.staff_id = staff.staff_id
GROUP BY 
    1, 2, 3
ORDER BY 
    4 DESC;