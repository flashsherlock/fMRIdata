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

