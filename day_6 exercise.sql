/*
任务一：子查询入门（WHERE + 子查询）
查询所有与“John Doe”在同一个部门的员工信息（员工编号、姓名、部门编号）。
（子查询）先查出“John Doe”的部门编号。
（外部查询）再从员工表中查找部门编号等于子查询结果的员工。
任务二：子查询与聚合函数结合
查询工资高于公司平均工资的员工信息（员工编号、工资）。
（子查询）先计算公司的平均工资。
（外部查询）再从工资表中查找工资大于子查询结果的记录。
提示：需要用到  AVG  函数。
任务三： IN  操作符与子查询
查询所有职位名称（ title ）为“Senior Engineer”或“Manager”的员工信息。
（子查询）先从职位表中查出所有职位是“Senior Engineer”或“Manager”的员工编号。
（外部查询）再从员工表中查找员工编号在子查询结果列表中的员工。
提示：使用  WHERE column IN (subquery) 。
任务四： NOT IN  操作符与子查询
查询从未担任过“Manager”职位的员工信息。
与任务三相反，查找员工编号不在“Manager”员工编号列表中的员工。
任务五：综合挑战
查询每个部门中工资最高的员工信息（显示部门名称、员工姓名、工资）。
提示：需要结合 GROUP BY 、 JOIN 和子查询。可以尝试先按部门分组找出最高工资，再将结果与员工表和部门表连接。
*/
SELECT emp_no,CONCAT(first_name,' ',last_name) AS name,dept_name
FROM employees e
join departments d on e.dept_no=d.dept_no
where e.dept_no=
(SELECT dept_no
FROM employees
where first_name='John' and last_name='Doe');
/*第五行是e.dept_no时结果出来的并不是预期的只包含和那个人部门名相同的人的信息，而是都出来了
但是如果第五行是dept_no答案却是想要的 这是为什么呢？y 由此，为了防止模糊，什么时候表前需要e.emp_no?
因为子查询内部我没有给employees这个表起别名e,因此这里用的实际是外表，构成了关联子查询，而我本身是非关联子查询，因此，造成了错误*/

SELECT dept_no,salary
FROM employees e
join salaries s on e.emp_no=s.emp_no
where s.salary>(
SELECT AVG(salary) AS avg_salary
FROM salaries);

SELECT e.emp_no,CONCAT(first_name,' ',last_name) AS name,hire_date,dept_no,title,gender,birth_date
FROM employees e
join titles  t on e.emp_no=t.emp_no
where title in("Senior Engineer","Manager");

SELECT e.emp_no,CONCAT(first_name,' ',last_name) AS name,hire_date,dept_no,title,gender,birth_date
FROM titles t
join employees e on e.emp_no=t.emp_no
where title not in("Manager");

SELECT d.dept_name,CONCAT(first_name,' ',last_name) AS name ,s.salary
FROM employees e
join departments d on d.dept_no=e.dept_no
join salaries s on s.emp_no=e.emp_no
join(
SELECT e.dept_no,AVG(s.salary) AS avg_salary
FROM employees e
join salaries s on s.emp_no=e.emp_no
GROUP BY e.dept_no
) AS dept_avg on dept_avg.dept_no=e.dept_no
where s.salary> dept_avg.avg_salary;
