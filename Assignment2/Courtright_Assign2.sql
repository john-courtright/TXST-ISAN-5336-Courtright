/*
	ISAN 5355: Database Management Systems
    Assignment 2
    Author: John Courtright
    Instructor: Dr. Zhao
    
    Working with the orderdetails and orders tables in the classicmodels schema
	Link: http://www.mysqltutorial.org/mysql-sample-database.aspx
*/

/* Question 1: Display a list with the order number, order date, 
the quantity ordered, and each price in ascending order by the quantity ordered */
SELECT orderdetails.orderNumber, 
	orders.orderDate, 
    orderdetails.quantityOrdered, 
    orderdetails.priceEach
FROM orderdetails
INNER JOIN orders ON orderdetails.orderNumber = orders.orderNumber
ORDER BY orderdetails.quantityOrdered ASC;

/* Question 2: Calculate total price per order */
SELECT orderNumber, quantityOrdered, priceEach, 
	(quantityOrdered * priceEach) as totalPrice
FROM orderdetails
ORDER BY orderNumber;

/* Question 3: Count the number of distinct orders */
SELECT COUNT(orderNumber)
FROM orderdetails;

/* Question 4: Create a cross joint query. How many rows are returned? */
SELECT *
FROM orderdetails CROSS JOIN orders;
-- 976,696 rows returned

/* Question 5: Calculate the total price value of all the orders */
SELECT SUM(order_total) AS totalValue
FROM (
    SELECT orderNumber, SUM(quantityOrdered * priceEach) AS order_total
    FROM orderDetails
    GROUP BY orderNumber
) AS sub;

/* (Bonus) Question 6: Calculate the average price of an order, then 
calculate the difference between each order’s total value and the average price */
-- Use CTE method instead of nested subqueries
-- 1) Calculate total per order
WITH order_totals AS (
    SELECT 
        orderNumber,
        SUM(quantityOrdered * priceEach) AS order_total
    FROM orderdetails
    GROUP BY orderNumber
),
-- 2) Calculate average total of all orders
avg_order AS (
    SELECT AVG(order_total) AS avg_total
    FROM order_totals
)
-- 3) Calculate deviation for each order
SELECT 
    o.orderNumber,
    o.order_total,
    ROUND(a.avg_total, 2) as avgValue,
    ROUND((o.order_total - a.avg_total), 2) AS deviation
FROM order_totals o
CROSS JOIN avg_order a;

/* Question 7: Calculate the total value of the orders by order status */
SELECT 
    o.status,
    SUM(od.quantityOrdered * od.priceEach) AS total_value
FROM orderdetails od
JOIN orders o
  ON od.orderNumber = o.orderNumber
GROUP BY o.status;

/* Question 8: Insert these records in the correct tables:
	orderNumber = 99999; orderDate = 2022-01-15; requiredDate = 2022-02-20; shippedDate = NULL; 
		status = “In Process”; comments = “Please expedite “; customerNumber = 201;
	orderNumber = 99999; productCode = S18_1749; quantityOrdered = 99; priceEach = 9; orderLineNumber = 1;
	orderNumber = 99999; productCode = S18_2248; quantityOrdered = 66; priceEach = 6; orderLineNumber = 2;
*/
-- Record 1
INSERT INTO orders 
    (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES 
    (99999, '2022-01-15', '2022-02-20', NULL, 'In Process', 'Please expedite', 201);
-- Check
SELECT *
FROM orders
WHERE orderNumber = 99999;

-- Record 2
INSERT INTO orderdetails
	(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES
	(99999, 'S18_1749', 99, 9, 1);
-- Record 3
INSERT INTO orderdetails
	(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES
	(99999, 'S18_2248', 66, 6, 2);
-- Check
SELECT *
FROM orderdetails
WHERE orderNumber = 99999;

/* Question 9: Modify the shippedDate for all the orders with 
a total value less than $1000 by adding three more days */
-- SET SQL_SAFE_UPDATES = 0;
WITH orderValue AS (
    SELECT 
        orderNumber,
        SUM(quantityOrdered * priceEach) AS order_total
    FROM orderdetails
    GROUP BY orderNumber
)
UPDATE orders o
JOIN orderValue ov
  ON o.orderNumber = ov.orderNumber
SET o.shippedDate = DATE_ADD(o.shippedDate, INTERVAL 3 DAY)
WHERE ov.order_total < 1000;
-- Print affected row
WITH orderValue AS (
    SELECT 
        orderNumber,
        SUM(quantityOrdered * priceEach) AS order_total
    FROM orderdetails
    GROUP BY orderNumber
)
SELECT 
    o.orderNumber,
    o.shippedDate,
    ov.order_total
FROM orders o
JOIN orderValue ov
  ON o.orderNumber = ov.orderNumber
WHERE ov.order_total < 1000;

/* Question 10: Delete the records inserted during question 8 */
-- Before
SELECT *
FROM orders
WHERE orderNumber = 99999;

SELECT *
FROM orderdetails
WHERE orderNumber = 99999;

-- Remove
DELETE FROM orderdetails 
WHERE orderNumber = 99999;

DELETE FROM orders
WHERE orderNumber = 99999;

-- After
SELECT *
FROM orders
WHERE orderNumber = 99999;

SELECT *
FROM orderdetails
WHERE orderNumber = 99999;
