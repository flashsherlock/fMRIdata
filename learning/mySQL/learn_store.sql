-- CROSS JOIN
SELECT * FROM shippers, products;
SELECT * FROM shippers CROSS JOIN products ORDER BY shippers.`name`;

-- UNION
SELECT order_id, order_date, 'Active' AS `status`
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT order_id, order_date, 'Archived' AS `s`
FROM orders
WHERE order_date < '2019-01-01';

SELECT customer_id,first_name,points, 'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT customer_id,first_name,points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT customer_id,first_name,points, 'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;

-- INSERT INTO insert rows
INSERT INTO products
VALUES (DEFAULT,'a',1,1),
			 (DEFAULT,'b',1,1),
			 (DEFAULT,'c',1,1);

-- LAST_INSERT_ID() return the ID
SELECT LAST_INSERT_ID();

CREATE TABLE order_archive AS
SELECT * FROM orders;

UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

UPDATE orders
SET comments = 'Gold Customers'
WHERE customer_id IN 
(SELECT customer_id FROM customers WHERE points >=3000);

-- DELETE rows
DELETE FROM customers
WHERE customer_id = 1;

-- HAVING clause
SELECT *,SUM(quantity * unit_price) AS total_pay FROM customers
JOIN orders USING (customer_id)
JOIN order_items USING (order_id)
WHERE state = 'VA'
GROUP BY customer_id
HAVING total_pay > 100;

SELECT * FROM products
WHERE unit_price > 
(SELECT unit_price FROM products WHERE product_id = 3);

SELECT 
customer_id,first_name,last_name 
FROM customers
WHERE customer_id IN (
	SELECT customer_id FROM orders WHERE order_id IN (
		SELECT order_id FROM order_items WHERE product_id = 3));
		
SELECT 
DISTINCT customer_id,first_name,last_name 
FROM customers
JOIN orders USING (customer_id)
JOIN order_items USING (order_id)
WHERE product_id = 3;

-- using EXISTS is more efficient when IN return a large dataset
SELECT * FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id FROM order_items
);

SELECT * FROM products p
WHERE NOT EXISTS (
	SELECT DISTINCT product_id FROM order_items
	WHERE product_id = p.product_id
);

-- string function
SELECT NOW();
SELECT EXTRACT(DAY FROM NOW());

SELECT * FROM orders
WHERE YEAR(order_date) = YEAR(NOW())-3;

SELECT DATE_FORMAT(NOW(),'%M %d %Y');
SELECT TIME_FORMAT(NOW(),'%h:%i %p');
SELECT DATE_ADD(NOW(),INTERVAL 1 DAY);
SELECT DATEDIFF(NOW(),'2022-01-02');
SELECT TIME_TO_SEC(NOW())-TIME_TO_SEC('9:00');

SELECT order_Id, IFNULL(shipper_id,'Not assigned') AS shipper
FROM orders;

SELECT order_Id, COALESCE(shipper_id,comments,'Not assigned') AS shipper
FROM orders;

SELECT CONCAT(first_name,' ',last_name) AS customer, IFNULL(phone,'Unknown') AS phone
FROM customers;

-- IF function
SELECT
product_id,
`name`,
(SELECT COUNT(*) FROM order_items WHERE product_id=p.product_id) AS orders,
IF((SELECT orders)=1,'Once','Many times') AS frequency
FROM products p
HAVING orders > 0;
-- another solution
SELECT
product_id,
`name`,
COUNT(*) AS orders,
IF(COUNT(*)=1,'Once','Many times') AS frequency
FROM products p
JOIN order_items oi USING (product_id)
GROUP BY product_id,`name`;

-- CASE
SELECT 
customer_id,
CONCAT(first_name,' ',last_name) AS customer,
points,
CASE
	WHEN points < 2000 THEN
		'Bronze'
	WHEN points > 3000 THEN
		'Gold'
	ELSE
		'Silver'
END AS type
FROM customers
ORDER BY first_name;

-- TRANSACTION
START TRANSACTION;
INSERT INTO orders (customer_id,order_date,`status`)
VALUES (1,'2019-01-01',1);
INSERT INTO order_items
VALUES (LAST_INSERT_ID(),1,1,1);
COMMIT;
-- mannually rollback
ROLLBACK;
-- insert update delete are commited automatically
SHOW VARIABLES LIKE 'autocommit';
SHOW VARIABLES LIKE 'transaction_isolation';
-- SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- index
EXPLAIN SELECT customer_id FROM customers WHERE state = 'VA';
CREATE INDEX idx_state ON customers (state);

EXPLAIN SELECT customer_id FROM customers WHERE points > 1000;
CREATE INDEX idx_points ON customers (points);

-- SHOW INDEXES IN customers;
SHOW INDEX FROM customers;
ANALYZE TABLE customers;
SHOW INDEX FROM orders;

-- prefix index for text
SELECT COUNT(DISTINCT LEFT(last_name,5)) FROM customers;
CREATE INDEX idx_lastname ON customers (last_name(5));

-- full-text index
USE sql_blog;
CREATE FULLTEXT INDEX idx_title_body ON posts (title,body);

SELECT *, MATCH(title,body) AGAINST ('react redux') FROM posts
WHERE MATCH(title,body) AGAINST ('react redux');
-- WHERE MATCH(title,body) AGAINST ('react -redux +form' IN BOOLEAN MODE);

-- composite indexes 
-- the order of columns is important
USE sql_store;
CREATE INDEX idx_state_points ON customers (state,points);
EXPLAIN SELECT customer_id FROM customers
WHERE state = 'CA' AND points > 1000;

-- use indexes to order data
EXPLAIN SELECT customer_id FROM customers ORDER BY state;

SHOW STATUS LIKE 'last_query_cost';

-- GA4 data
CREATE TEMP TABLE event_count AS
SELECT
  user_pseudo_id,
  COUNT(event_date) AS number
FROM (SELECT 
      user_pseudo_id,
      event_date
  FROM `learn-339408.analytics_353482307.events_*`
  WHERE event_name='page_view' )
GROUP BY 
  user_pseudo_id 
ORDER BY
  number;

SELECT 
    number,
    user_pseudo_id,
    event_date,
    device,
    geo,
    event_name,
    event_params,
    traffic_source
FROM `learn-339408.analytics_353482307.events_*`
JOIN event_count USING (user_pseudo_id)
WHERE event_name='page_view'
ORDER BY
  number DESC,
  user_pseudo_id,
  event_date;