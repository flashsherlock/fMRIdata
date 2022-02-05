SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 相关子查询
SELECT * FROM employees e
WHERE salary > (
	SELECT AVG(salary) FROM employees
	WHERE office_id = e.office_id
);

-- CREATE DATABASE and TABLE
DROP DATABASE IF EXISTS sql_store2;
CREATE DATABASE IF NOT EXISTS sql_store2;
USE sql_store2;
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers
(
	customer_id INT	PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50) NOT NULL,
	points INT NOT NULL DEFAULT 0,
	email VARCHAR(255) NOT NULL UNIQUE
);

-- change tables
ALTER TABLE customers
	ADD last_name VARCHAR(50) NOT NULL AFTER first_name,
	MODIFY COLUMN first_name VARCHAR(55) DEFAULT '',
	DROP points;

-- create relationships
DROP TABLE IF EXISTS orders;
CREATE TABLE orders
(
	order_id INT PRIMARY KEY,
	customer_id INT NOT NULL,
	FOREIGN KEY fk_orders_customers (customer_id)
		REFERENCES customers (customer_id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
);

-- alter keys
ALTER TABLE orders
	DROP FOREIGN KEY orders_ibfk_2,
	ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
		REFERENCES customers (customer_id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT;
		
-- charset
SHOW CHARSET LIKE 'utf8%';
-- change charset
ALTER DATABASE `sql_school`
	CHARACTER SET 'utf8mb4'
	COLLATE 'utf8mb4_general_ci';
	
-- change storage engine
SHOW ENGINES;
ALTER TABLE customers ENGINE = InnoDB;

-- manage database
-- CREATE USER sherlock@localhost IDENTIFIED BY 'strong_password';
-- DROP USER sherlock@localhost;
-- SET PASSWORD FOR sherlock@localhost = 'strong_password';
-- PRIVILEGE
-- GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE
-- ON sql_hr.*
-- TO sherlock@localhost;
-- 
-- GRANT ALL ON *.* TO sherlock@localhost;
-- REVOKE ALL ON *.* FROM sherlock@localhost;

SELECT * FROM mysql.`user`;
SHOW GRANTS FOR root;