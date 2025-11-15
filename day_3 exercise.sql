/*
任务一：基础计数
统计公司员工总人数。

任务二：单字段分组
统计每个部门（ dept_no ）的员工人数。

任务三：分组后使用聚合函数
计算每个部门的员工平均工资（需要连接  salaries  表，使用  AVG(salary) ）。提示：需要用到  JOIN 。

任务四： HAVING  过滤（重点！）
找出员工平均工资高于70000的部门编号和其平均工资。

任务五：综合挑战
找出员工人数超过1人的部门，并列出这些部门的编号、员工人数和平均工资。
*/
SELECT count(DISTINCT emp_no)
FROM  employees;

SELECT count(DISTINCT emp_no),dept_no
From employees
GROUP BY dept_no;

SELECT AVG(salary),dept_no
From employees 
join salaries on employees.emp_no=salaries.emp_no
GROUP BY dept_no;

SELECT dept_no,AVG(salary)
from employees 
join salaries on employees.emp_no=salaries.emp_no
GROUP BY dept_no
HAVING AVG(salary)>70000;

SELECT e.dept_no,count(DISTINCT e.emp_no) AS employee_count,AVG(salary) AS avg_salary
FROM employees e
join salaries  s on e.emp_no=s.emp_no
GROUP BY dept_no
HAVING count(DISTINCT e.emp_no)>1;
