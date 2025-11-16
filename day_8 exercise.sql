/*任务一：数据类型认知（字符串与日期）
查询员工表，显示员工编号、姓名和入职日期（ hire_date ），并将入职日期格式化为  'YYYY-MM-DD'  的字符串形式显示。
提示：使用  DATE_FORMAT(hire_date, '%Y-%m-%d')  函数。体会日期类型和格式化后字符串类型的区别。

任务二：空值（NULL）检查
查询员工表，找出所有尚未分配部门（即 dept_no 为NULL）的员工名单。
提示：使用  IS NULL  进行判断。

任务三：空值处理（COALESCE应用）
查询员工表，显示员工编号、姓名和部门编号。对于未分配部门的员工，在其部门编号字段显示为 '暂未分配'。
提示：使用  COALESCE(dept_no, '暂未分配') 。

任务四：查询性能意识（避免全表扫描）
查询2020年1月1日之后入职的员工。请尝试写出两种写法：
高效写法：在 hire_date 字段上不使用函数。
低效写法：在 hire_date 字段上使用函数（如 YEAR 函数）。
关键思考：为什么第一种写法更高效？

任务五：综合挑战（数据类型转换与条件判断）
查询薪资表，将每位员工的薪资（ salary ）转换为带千位分隔符的字符串格式（例如： 80,000 ），并判断其薪资水平：
高薪资（>= 80000）
中薪资（60000 ~ 79999）
低薪资（< 60000）
提示：使用 FORMAT(salary, 0) 实现千位分隔，并结合 CASE WHEN 进行判断。*/

SELECT emp_no,CONCAT(first_name,' ',last_name) AS name,DATE_FORMAT(hire_date,'%Y-%m-%d') AS DATE,hire_date
FROM employees;

SELECT emp_no,CONCAT(first_name,' ',last_name) AS name
FROM employees
WHERE dept_no is NULL;

SELECT emp_no,CONCAT(first_name,' ',last_name) AS name,
COALESCE(dept_no,'暂未分配') AS department
FROM employees;

SELECT *
FROM employees
where YEAR(hire_date)>2020;/*用EXPLAIN显示filtered是100,type是ALL,是低效的方法*/

SELECT *
FROM employees
where hire_date>'2020-01-01';/*用EXPLAIN显示filtered是33.333...,type是ALL，是高效的方法*/

SELECT FORMAT(salary,0),employees.emp_no,CONCAT(first_name,' ',last_name) AS name,
CASE 
	WHEN salary>=80000 THEN '高薪资'
	WHEN salary BETWEEN 60000 AND 79999 THEN '中薪资'
	WHEN salary<60000 THEN '低薪资'
	ELSE '未知'
END AS salary_level
FROM salaries 
join employees on salaries.emp_no=employees.emp_no;