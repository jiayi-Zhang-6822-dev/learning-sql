SELECT emp_no,hire_date,dept_no,
ROW_NUMBER() OVER (PARTITION BY  dept_no 		ORDER BY  hire_date) AS dept_hire_order
FROM employees;

SELECT e.dept_no,e.emp_no,s.salary,
RANK() OVER(PARTITION BY dept_no ORDER By salary DESC) AS rank_salary,
DENSE_RANK() OVER(PARTITION BY dept_no ORDER By salary DESC) AS dense_rank_salary
FROM employees e
join salaries s on s.emp_no=e.emp_no;

SELECT emp_no,salary,from_date,
LAG(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS lag_salary,
LEAD(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS lead_salary
FROM salaries;

SELECT e.emp_no,s.salary,e.dept_no,
SUM(salary) OVER (PARTITION BY dept_no ORDER BY emp_no) AS sum_salarys
FROM employees e
join salaries s on e.emp_no=s.emp_no;

SELECT emp_no,salary,from_date,
AVG(salary) OVER (PARTITION BY emp_no ORDER BY from_date DESC  ROWS 2 PRECEDING) AS avg_last3_salary
FROM salaries
ORDER BY emp_no,from_date DESC;	