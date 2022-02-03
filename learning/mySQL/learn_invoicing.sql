-- CREATE TABLE
CREATE TABLE invoices_archived AS
SELECT *
FROM invoices
JOIN clients USING (client_id)
WHERE payment_date IS NOT NULL;

-- UPDATE table
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-03'
WHERE client_id = 3;
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
SELECT TRUNCATE(3.1425,2);

-- CREATE VIEW name AS commands (do not save data)
CREATE VIEW clients_balance AS
SELECT
client_id,
`name`,
SUM(invoice_total)-	SUM(payment_total) AS balance
FROM clients
JOIN invoices USING (client_id)
GROUP BY client_id,`name`;

-- CREATE OR REPLACE VIEW clients_balance AS
-- DROP PROCEDURE IF EXISTS clients_balance
-- WITH CHECK OPTION

-- PROCEDURE FUNCTION
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
	SELECT
	*,
	invoice_total-payment_total AS balance
	FROM invoices
	HAVING balance > 0;
END$$
DELIMITER ;
CALL get_invoices_with_balance();

-- PROCEDURE with parameters
DROP PROCEDURE IF EXISTS get_invoices_by_client;
DELIMITER $$
CREATE PROCEDURE get_invoices_by_client(client_id INT)
BEGIN
	IF client_id IS NULL THEN
		SET client_id = 1;
	END IF;
	SELECT
	*
	FROM invoices i
	WHERE i.client_id = client_id;
END$$
DELIMITER ;
CALL get_invoices_by_client(1);
CALL get_invoices_by_client(NULL);

-- IFNULL(state,c.state)
DROP PROCEDURE IF EXISTS get_invoices_by_staten;
DELIMITER $$
CREATE PROCEDURE get_invoices_by_staten(state CHAR(2))
BEGIN
	SELECT
	*
	FROM clients c
	WHERE c.state COLLATE utf8mb4_unicode_ci = IFNULL(state,c.state);
END$$
DELIMITER ;
CALL get_invoices_by_staten(NULL);

DELIMITER $$
DROP PROCEDURE IF EXISTS get_invoices_by_clientname;
CREATE PROCEDURE get_invoices_by_clientname(client VARCHAR(10))
BEGIN
	SELECT
	*
	FROM invoices i
	JOIN clients USING (client_id)
	WHERE `name` COLLATE utf8mb4_unicode_ci = client;
END$$
DELIMITER ;
CALL get_invoices_by_clientname('Vinte');

-- two parameters (place holder)
DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments(
client_id INT,
payment_method_id TINYINT)
BEGIN
-- 	deal with error
	IF client_id <=0 THEN
		SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid ID';
	END IF;
	SELECT * FROM payments p
	WHERE p.client_id = IFNULL(client_id,p.client_id) 
	AND p.payment_method = IFNULL(payment_method_id,p.payment_method);
END$$
DELIMITER ;
CALL get_payments(0,1);

-- our parameters
DROP PROCEDURE IF EXISTS get_unpay;
DELIMITER $$
CREATE PROCEDURE get_unpay(
	client_id INT,
	OUT invoices_count INT,
	OUT invoices_total DECIMAL(9,2)
)
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
	INTO invoices_count,invoices_total
	FROM invoices i
	WHERE i.client_id = client_id AND payment_total = 0;	
END$$
DELIMITER ;

SET @invoices_count = 0;
SET @invoices_total = 0;
CALL get_unpay(1,@invoices_count,@invoices_total);
SELECT @invoices_count,@invoices_total;

-- create FUNCTION
DELIMITER $$
CREATE FUNCTION risk(client_id INT)
RETURNS INTEGER
READS SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
	DECLARE invoices_total DECIMAL(9,2);
	DECLARE invoices_count INT;
	
	SELECT COUNT(*),SUM(invoice_total)
	INTO invoices_count, invoices_total
	FROM invoices i
	WHERE i.client_id = client_id;
	
	SET risk_factor = invoices_total/invoices_count * 5;
	RETURN risk_factor;
END$$
DELIMITER ;

-- TRIGGER
DROP TRIGGER IF EXISTS payments_after_insert;
DELIMITER $$
CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
	FOR EACH ROW
BEGIN
	UPDATE invoices
	SET payment_total = payment_total + NEW.amount
	WHERE invoice_id = NEW.invoice_id;
			
	INSERT INTO payments_audit
	VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW());
END$$
DELIMITER ;

INSERT INTO payments
VALUES (DEFAULT, 5,3,'2019-01-01',10,1);

-- trigger after DELETE data
DROP TRIGGER IF EXISTS payments_after_delete;
DELIMITER $$
CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
	FOR EACH ROW
BEGIN
	UPDATE invoices
	SET payment_total = payment_total - OLD.amount
	WHERE invoice_id = OLD.invoice_id;
	
	INSERT INTO payments_audit
	VALUES (OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW());
END$$
DELIMITER ;

DELETE FROM payments
WHERE payment_id = 12;
-- view TRIGGERS
SHOW TRIGGERS LIKE 'payment%';

-- create EVENT
SHOW VARIABLES LIKE 'event%';
SET GLOBAL event_scheduler = OFF;

DELIMITER $$
CREATE EVENT yearly_delete_audit_rows
ON SCHEDULE
-- 	AT '2019-05-01'
	EVERY 1 YEAR STARTS '2019-05-01' ENDS '2029-05-01'
DO BEGIN
	DELETE FROM payments_audit
	WHERE action_date < NOW() - INTERVAL 1 YEAR;
-- 	DATE_ADD(NOW(),INTERVAL -1 YEAR)
END$$
DELIMITER ;
-- show events
SHOW EVENTS;
ALTER EVENT yearly_delete_audit_rows DISABLE;