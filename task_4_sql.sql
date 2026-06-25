-- ====================================================================================
-- TASK 4: SQL ADVANCED PRACTICE (RECORDS, WINDOW FUNCTIONS, VIEWS, TRIGGERS, CASE WHEN)
-- ====================================================================================

-- 1. Adding New Records into the Existing Table (Add Records)
INSERT INTO Employees (emp_id, first_name, last_name, department, salary, hire_date) VALUES
(8, 'Rohan', 'Deshmukh', 'IT', 88000, '2026-05-20'),
(9, 'Pooja', 'Sawant', 'HR', 52000, '2026-06-01');

/*
[EXPECTED OUTPUT / RESULT]
Query OK, 2 rows affected (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 0
*/


-- 2. Using Window Functions (Calculating Department-wise Total Salary and Salary Rank)
SELECT 
    emp_id, first_name, last_name, department, salary,
    SUM(salary) OVER (PARTITION BY department) AS department_total_salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank_in_dept
FROM Employees;

/*
[EXPECTED OUTPUT / RESULT]
+--------+------------+-----------+------------+--------+-------------------------+---------------------+
| emp_id | first_name | last_name | department | salary | department_total_salary | salary_rank_in_dept |
+--------+------------+-----------+------------+--------+-------------------------+---------------------+
|      4 | Priya      | Joshi     | Finance    |  75000 |                  155000 |                   2 |
|      6 | Vijay      | Shinde    | Finance    |  80000 |                  155000 |                   1 |
|      2 | Amit       | Sharma    | HR         |  50000 |                  150000 |                   2 |
|      5 | Sneha      | Kulkarni  | HR         |  48000 |                  150000 |                   3 |
|      9 | Pooja      | Sawant    | HR         |  52000 |                  150000 |                   1 |
|      1 | Soni       | Ankam     | IT         |  85000 |                  363000 |                   3 |
|      3 | Rahul      | Patil     | IT         |  95000 |                  363000 |                   1 |
|      7 | Aniket     | Mane      | IT         |  95000 |                  363000 |                   1 |
|      8 | Rohan      | Deshmukh  | IT         |  88000 |                  363000 |                   2 |
+--------+------------+-----------+------------+--------+-------------------------+---------------------+
*/


-- 3. Creating a View (Secure View for IT Department Employees)
CREATE VIEW v_it_employees AS
SELECT emp_id, first_name, last_name, salary, hire_date
FROM Employees
WHERE department = 'IT';

/*
[EXPECTED OUTPUT / RESULT]
Query OK, 0 rows affected (0.02 sec)

-- When you execute `SELECT * FROM v_it_employees;`, the output will look like this:
+--------+------------+-----------+--------+------------+
| emp_id | first_name | last_name | salary | hire_date  |
+--------+------------+-----------+--------+------------+
|      1 | Soni       | Ankam     |  85000 | 2026-01-15 |
|      3 | Rahul      | Patil     |  95000 | 2026-04-01 |
|      7 | Aniket     | Mane      |  95000 | 2026-02-10 |
|      8 | Rohan      | Deshmukh  |  88000 | 2026-05-20 |
+--------+------------+-----------+--------+------------+
*/


-- 4. Creating a Trigger (Automatically Log a Record into Audit Table on New Employee Insert)
CREATE TABLE emp_audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    msg VARCHAR(255),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_employee_insert
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO emp_audit_log (msg)
    VALUES (CONCAT('New Employee Added: ', NEW.first_name, ' ', NEW.last_name, ' (ID: ', NEW.emp_id, ')'));
END //
DELIMITER ;

/*
[EXPECTED OUTPUT / RESULT]
Query OK, 0 rows affected (0.03 sec)

-- Whenever a new INSERT happens from now on, the `emp_audit_log` table will automatically log a entry like this:
+--------+---------------------------------------------+---------------------+
| log_id | msg                                         | action_time         |
+--------+---------------------------------------------+---------------------+
|      1 | New Employee Added: Rohan Deshmukh (ID: 8)  | 2026-06-25 12:40:00 |
+--------+---------------------------------------------+---------------------+
*/


-- 5. Handling CASE WHEN (Categorizing Employee Grades Based on Salary)
SELECT first_name, last_name, salary,
    CASE 
        WHEN salary >= 90000 THEN 'Grade A'
        WHEN salary >= 70000 AND salary < 90000 THEN 'Grade B'
        ELSE 'Grade C'
    END AS employee_grade
FROM Employees;

/*
[EXPECTED OUTPUT / RESULT]
+------------+-----------+--------+----------------+
| first_name | last_name | salary | employee_grade |
+------------+-----------+--------+----------------+
| Soni       | Ankam     |  85000 | Grade B        |
| Amit       | Sharma    |  50000 | Grade C        |
| Rahul      | Patil     |  95000 | Grade A        |
| Priya      | Joshi     |  75000 | Grade B        |
| Sneha      | Kulkarni  |  48000 | Grade C        |
| Vijay      | Shinde    |  80000 | Grade B        |
| Aniket     | Mane      |  95000 | Grade A        |
| Rohan      | Deshmukh  |  88000 | Grade B        |
| Pooja      | Sawant    |  52000 | Grade C        |
+------------+-----------+--------+----------------+
*/