-- UNION
SELECT
	'first half of 2019' AS date_range,
	SUM( invoice_total ) AS total_sales,
	SUM( payment_total ) AS total_payments,
	SUM( invoice_total - payment_total ) AS whate_we_expect 
FROM
	`invoices` 
WHERE
	invoice_date < '2019-07-01' UNION
SELECT
	'second half of 2019' AS date_range,
	SUM( invoice_total ) AS total_sales,
	SUM( payment_total ) AS total_payments,
	SUM( invoice_total - payment_total ) AS whate_we_expect 
FROM
	`invoices` 
WHERE
	invoice_date BETWEEN '2019-07-01' 
	AND '2019-12-01' UNION
SELECT
	'total' AS date_range,
	SUM( invoice_total ) AS total_sales,
	SUM( payment_total ) AS total_payments,
	SUM( invoice_total - payment_total ) AS whate_we_expect 
FROM
	`invoices`;

-- GROUP BY
SELECT
	client_id,
	SUM( invoice_total ) AS total_sales 
FROM
	`invoices` 
GROUP BY
	client_id 
ORDER BY
	total_sales DESC;

-- GROUP BY
SELECT
	date,
	pm.NAME AS payment_method,
	SUM( amount ) AS total_payments 
FROM
	payments p
	JOIN payment_methods pm ON p.payment_method = pm.payment_method_id 
GROUP BY
	p.date,
	p.payment_method 
ORDER BY
	p.date;

-- WITH ROLLUP
SELECT
	pm.`name`,
	SUM( p.amount ) AS total 
FROM
	payments p
	JOIN payment_methods pm ON p.payment_method = pm.payment_method_id 
GROUP BY
	pm.`name` WITH ROLLUP;

-- sub clause
SELECT
	client_id 
FROM
	clients 
WHERE
	client_id NOT IN ( SELECT DISTINCT client_id FROM invoices );

-- ALL
SELECT
	* 
FROM
	invoices 
WHERE
	invoice_total > ALL ( SELECT invoice_total FROM invoices WHERE client_id = 3 );
	
-- 子查询 subqueries
SELECT * FROM invoices i
WHERE invoice_total  > (
	SELECT AVG(invoice_total) FROM invoices
	WHERE client_id = i.client_id);

SELECT 
	invoice_id,
	invoice_total,
	(SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
	invoice_total - (SELECT invoice_average)
FROM invoices;

-- subqueries in SELECT clause
SELECT
	client_id,
	`name`,
	SUM(invoice_total) AS total_sales,
	(SELECT AVG(invoice_total) FROM invoices) AS average,
	SUM(invoice_total) - (SELECT average) AS difference
FROM invoices
RIGHT JOIN clients USING (client_id)
GROUP BY client_id;

-- subqueries in FROM clause
SELECT *
FROM (
	SELECT 
	client_id,
	`name`,
	(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
	(SELECT AVG(invoice_total) FROM invoices) AS average,
	(SELECT total_sales - average) AS difference
	FROM clients c
) AS sales_summary
WHERE total_sales IS NOT NULL ;

-- mySQL numeric function