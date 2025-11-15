/*
任务一：基础内连接
查询所有员工的员工编号（ emp_no ）、姓名（ first_name ,  last_name ）以及他们所在的部门名称（ dept_name ）。
提示：需要连接  employees  表和  departments  表，连接键是  dept_no 。

任务二：三表连接
查询所有员工的员工编号、姓名、职位名称（ title ）以及部门名称。
提示：需要连接  employees 、 titles  和  departments  三张表。注意  employees  和  titles  表通过  emp_no  连接。

任务三：带过滤的连接
查询在“Development”部门（ dept_name ）工作的所有员工的姓名和职位。
提示：在任务二的基础上，增加一个 WHERE 条件来过滤部门名称。

任务四：连接与聚合的结合
统计每个部门（ dept_name ）的员工人数。
提示：需要连接  employees  和  departments  表，然后使用  GROUP BY  和  COUNT 。

任务五（综合挑战）：
查询员工“John Doe”的工资（ salary ）历史记录。
提示：需要连接  employees  和  salaries  表，并通过 WHERE 条件过滤出姓名为“John Doe”的员工。
*/
SELECT emp_no,CONCAT(first_name,",",last_name) AS NAME,dept_name
FROM employees e
inner join 
departments s on s.dept_no=e.dept_no;

SELECT e.emp_no,CONCAT(first_name,',',last_name) AS NAME,title,d.dept_name
FROM employees e
join titles t on e.emp_no=t.emp_no
join departments d on  e.dept_no=d.dept_no;

SELECT CONCAT(first_name,',',last_name) AS NAME,title
FROM employees e
join titles t on e.emp_no=t.emp_no
join departments d on  e.dept_no=d.dept_no
where d.dept_name="Development";

SELECT COUNT(DISTINCT  e.emp_no) AS number,d.dept_name
FROM employees e
inner join departments d on e.dept_no=d.dept_no
GROUP BY dept_name;

SELECT salary,CONCAT(first_name,' ',last_name) AS name
FROM employees e
inner join salaries s on s.emp_no=e.emp_no
where first_name="John" and last_name= "Doe";
