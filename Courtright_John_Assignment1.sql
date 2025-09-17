/* Question 1: Display a list with customerName and phone in ascending order by the customerName */
SELECT customerName, phone
FROM customers
ORDER BY customerName ASC;

/* Question 2: Display a list with the number of customerName for each country. */
SELECT country, COUNT(*) as totalCustomers
FROM customers
GROUP BY country
ORDER BY totalCustomers DESC;

/* Question 3: What is the total credit limit in the customer table */
SELECT SUM(creditLimit) as totalCreditLimit
FROM customers;

/* Question 4: Display a list with the average credit limit 
by country in alphabetical order */
SELECT country, AVG(creditLimit) as averageCreditLimit
FROM customers
GROUP BY country
ORDER BY country ASC;

/* Question 5: How many distinct countries are in the customers table */
SELECT COUNT(DISTINCT country) as distinctCountries
FROM customers;

/* Question 6: Display a list with customerName and countries for 'USA' and 'France'
with countries in alphabetical order */
SELECT customerName, country
FROM customers
WHERE country IN ('USA', 'France') -- Alternatively, WHERE country == 'USA' OR country == 'France'
ORDER BY country ASC;

/* Question 7: Display a list with customerName, country, and creditLimit
for 'USA' and 'France' with creditLimit greater than 80.000
with countries in alphabetical order */
SELECT customerName, country, creditLimit
FROM customers
WHERE country IN ('USA', 'France') AND creditLimit > 80.000
ORDER BY country ASC;

/* Question 8: Display a list with customerName, city, and country
order by country ascending */
SELECT customerName, city, country
FROM customers
WHERE country IN ('Belgium', 'Canada', 'Denmark', 'Finland', 'France')
ORDER BY country ASC, city ASC;

/* Question 9: Insert a new record into the cusomters table with this information: */
INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, city, country, creditLimit)
VALUES (999, 'Texas State University', 'Courtright', 'John', '512-245-1111', '601 Univ Dr', 'San Marcos', 'USA', 150000);

SELECT *
FROM customers
WHERE customerNumber = 999;

/* Question 10: Insert another record into the customers table with this information: */
INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, city, country, creditLimit)
VALUES (998, 'Texas State University', 'Zhao', 'Fred', '512-245-222', '601 Univ Dr', 'San Marcos', 'USA', 111111);

SELECT *
FROM customers
WHERE customerNumber = 998;

/* Question 11: Update the contactFirstName to 'Edward' from 'Tony' 
and country to 'USA' from 'New Zealand' for customerNumber 496 */
UPDATE customers
SET contactFirstName = 'Edward', country = 'USA'
WHERE customerNumber = 496;

SELECT contactFirstName, country
FROM customers
WHERE customerNumber = 496;

/* Question 12: Update all the USA country records to 'United States of America' */
UPDATE customers
SET country = 'United States of America'
WHERE country = 'USA' AND customerNumber > 0;

SELECT customerNumber, country
FROM customers
WHERE country = 'United States of America';

/* Question 13: Select all the records with a city name starting with 'M' */
SELECT *
FROM customers
WHERE city REGEXP '^M';

/* Before Deleting Records */
SELECT * 
FROM customers
WHERE customerNumber IN (996, 997, 998, 999, 1000);

/* Question 14: Delete the record inserted at question 9 */
DELETE
FROM customers
WHERE customerNumber = 999;
/* Question 15: Delete the reocrd inserted at question 10 */
DELETE
FROM customers
WHERE customerNumber = 998;

/* AFTER Deleting Records */
SELECT * 
FROM customers
WHERE customerNumber IN (996, 997, 998, 999, 1000);