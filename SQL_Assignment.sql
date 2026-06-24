-- ========================================================
-- SQL Practice: Employee & Department Analysis
-- Author: Soni Ankam
-- ========================================================

-- 1. Setup Table and Sample Data
DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
    emp_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    department TEXT,
    salary INTEGER,
    hire_date DATE
);

INSERT INTO Employees (emp_id, first_name, last_name, department, salary, hire_date) VALUES
(1, 'Soni', 'Ankam', 'IT', 85000, '2026-01-15'),
(2, 'Amit', 'Sharma', 'HR', 50000, '2025-11-10'),
(3, 'Rahul', 'Patil', 'IT', 95000, '2026-04-01'),
(4, 'Priya', 'Joshi', 'Finance', 75000, '2025-08-20'),
(5, 'Sneha', 'Kulkarni', 'HR', 48000, '2026-03-12'),
(6, 'Vijay', 'Shinde', 'Finance', 80000, '2025-05-15'),
(7, 'Aniket', 'Mane', 'IT', 95000, '2026-02-10');


-- Q1. Top 5 highest salary employees
SELECT * FROM Employees 
ORDER BY salary DESC 
LIMIT 5;

-- Q2. Department wise employee count
SELECT department, COUNT(*) AS total_employees 
FROM Employees 
GROUP BY department;

-- Q3. Find Second highest salary
SELECT MAX(salary) AS second_highest_salary 
FROM Employees 
WHERE salary < (SELECT MAX(salary) FROM Employees);

-- Q4. Employees whose salary > department average salary
SELECT * FROM Employees e
WHERE salary > (SELECT AVG(salary) FROM Employees WHERE department = e.department);

-- Q5. Inner Join (Programiz च्या Customers टेबल सोबत जोडणी)
SELECT Employees.emp_id, Employees.first_name, Customers.last_name
FROM Employees
INNER JOIN Customers ON Employees.emp_id = Customers.customer_id;

-- Q6. Left Join (Programiz च्या Customers टेबल सोबत जोडणी)
SELECT Employees.first_name, Customers.customer_id
FROM Employees
LEFT JOIN Customers ON Employees.emp_id = Customers.customer_id;

-- Q7. Group By with Having
SELECT department, AVG(salary) AS avg_salary 
FROM Employees 
GROUP BY department 
HAVING AVG(salary) > 50000;

-- Q8. Employees hired in last 6 months
SELECT * FROM Employees 
WHERE hire_date >= DATE('now', '-6 months');

-- Q9. Find the Duplicates records
SELECT first_name, COUNT(*) 
FROM Employees 
GROUP BY first_name 
HAVING COUNT(*) > 1;

-- Q10. How to remove the duplicates record
DELETE FROM Employees 
WHERE emp_id NOT IN (
    SELECT MIN(emp_id) 
    FROM Employees 
    GROUP BY first_name
);
