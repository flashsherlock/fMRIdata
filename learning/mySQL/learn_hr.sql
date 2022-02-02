SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 相关子查询
SELECT * FROM employees e
WHERE salary > (
	SELECT AVG(salary) FROM employees
	WHERE office_id = e.office_id
);