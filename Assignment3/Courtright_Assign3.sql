/*
	ISAN 5355: Database Management Systems
    Assignment 3: Due 10/29
    Author: John Courtright
    Instructor: Dr. Zhao
*/

-- SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

/* 1) Display orderNumber, quantityOrdered, priceEach, productName
	for all orders */
SELECT od.orderNumber, od.quantityOrdered, od.priceEach, p.productName
FROM orderdetails as od
JOIN products as p USING(productCode);

/* 2) Modify the query in question 1 to use inline view to display 
	the orderNumber, cost per each order (using an alias ‘CostPerOrder’), 
    and the productName */
SELECT 
    sub.orderNumber, sub.CostPerOrder, p.productName
FROM (
    SELECT 
        orderNumber,
        productCode,
        (quantityOrdered * priceEach) AS CostPerOrder
    FROM orderdetails
) AS sub
JOIN products AS p USING (productCode);
 
/* 3) Display orderNumber, productName, orderDate for all orders 
	placed after May 30th, 2005 (orderDate > 2005-05-30) */
SELECT od.orderNumber, o.orderDate, p.productName
FROM orderdetails as od
INNER JOIN orders as o ON od.orderNumber = o.orderNumber
INNER JOIN products as p ON od.productCode = p.productCode
WHERE o.orderDate > '2005-05-30';

/* 4) Modify the query above to use a subquery to obtain the 
	same output only with the columns orderNumber, productName */
SELECT  od.orderNumber, p.productName
FROM orderdetails AS od
JOIN products AS p USING (productCode)
WHERE od.orderNumber IN (
    SELECT orderNumber
    FROM orders
    WHERE orderDate > '2005-05-30'
);

/* 5) Select the productName and compute the corresponding 
	TotalPerProduct (i.e., sum product of quantityOrdered and 
    priceEach), grouping the outcome by the productName, for 
    all the totals greater than 180,000 */
SELECT p.productName,
	SUM(od.quantityOrdered * od.priceEach) as TotalPerProduct
FROM products as p
JOIN orderdetails as od USING (productCode)
GROUP BY p.productName
HAVING SUM(od.quantityOrdered * od.priceEach) > 180000;

/* 6) Update the orderDate for order 10100 to be 
	3 days later than the current value. */
UPDATE orders
SET orderDate = DATE_ADD(orderDate, INTERVAL 3 DAY)
WHERE orderNumber = 10100;
-- View Row(s)
SELECT orderNumber, orderDate
FROM orders
WHERE orderNumber = 10100;

/* 7) Find all the orders that were placed in July */
SELECT *
FROM orders
WHERE MONTH(orderDate) = 7;

/* 8) Find all the orders that were placed on the 26th day 
	of any month in 2003 */
SELECT *
FROM orders
WHERE DAYOFMONTH(orderDate) = 26
	AND YEAR(orderDate) = 2003;
    
/* 9) Find the productName and TotalPerProduct for all products 
	whose names start with 1957, followed by a space, and 
    then a letter from A to G */
SELECT p.productName,
    SUM(od.quantityOrdered * od.priceEach) AS TotalPerProduct
FROM products AS p
JOIN orderdetails AS od USING (productCode)
WHERE p.productName REGEXP '^1957 [A-G]'
GROUP BY p.productName;

-- SET SQL_SAFE_UPDATES = 0;
/* 10) Convert all orderNumber from integers to 
	strings with a length of 10 characters */
-- Create new columns in orders and orderdetails
ALTER TABLE orders
ADD orderNumberChar Char(10);
ALTER TABLE orderdetails
ADD orderNumberChar Char(10);
-- Verify
SELECT orderNumberChar
FROM orders;
SELECT orderNumberChar
FROM orderdetails;
-- Add new values to columns
UPDATE orderdetails
SET orderNumberChar = LPAD(CONVERT(orderNumber, Char(10)), 10, 0);
UPDATE orders
SET orderNumberChar = LPAD(CONVERT(orderNumber, Char(10)), 10, 0);
-- Print both columns to verify
SELECT ordernumber, orderNumberChar
FROM orders;
SELECT ordernumber, orderNumberChar
FROM orderdetails;
