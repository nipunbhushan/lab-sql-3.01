USE sakila;

-- Drop column picture from staff.
ALTER TABLE staff
  DROP COLUMN picture;

-- A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
INSERT INTO staff
            (first_name,
             last_name,
             address_id,
             email,
             store_id,
             active,
             username)
SELECT first_name,
       last_name,
       address_id,
       email,
       store_id,
       active,
       Lower(first_name)
FROM   customer
WHERE  first_name = 'Tammy'
       AND last_name = 'Sanders';

-- Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1.
INSERT INTO rental
            (rental_date,
             inventory_id,
             customer_id,
             return_date,
             staff_id,
             last_update)
SELECT CURRENT_TIMESTAMP(),
       (SELECT inventory_id
        FROM   inventory
        WHERE  film_id = (SELECT film_id
                          FROM   film
                          WHERE  title = 'Academy Dinosaur')
               AND store_id = 1
        ORDER  BY last_update
        LIMIT  1) AS
       inventory_id,
       (SELECT customer_id
        FROM   customer
        WHERE  first_name = 'Charlotte'
               AND last_name = 'Hunter') AS
       customer_id,
       ( Adddate(CURRENT_TIMESTAMP(), INTERVAL (SELECT Floor(Avg(Datediff(
                                      return_date,
                                        rental_date))) FROM rental) day) ) AS
       return_date,
       (SELECT staff_id
        FROM   staff
        WHERE  first_name = 'Mike'
               AND last_name = 'Hillyer') AS
       staff_id,
       CURRENT_TIMESTAMP() AS
       last_update; 