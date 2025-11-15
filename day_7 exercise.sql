/*任务一：基础条件逻辑（ CASE WHEN ）
查询员工表，显示员工编号、姓名和性别，并将性别显示为更直观的文字：
如果  gender  为 'M'，显示为 '男'
如果  gender  为 'F'，显示为 '女'
提示：使用  CASE WHEN  实现条件判断。
任务二：多条件分类
查询员工表，根据入职年限对员工进行分类：
入职10年以上：'老员工'入职5-10年：'中级员工'入职5年以下：'新员工'
提示：需要计算当前日期与入职日期的差值，可以使用  TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) 。
任务三：处理空值（ COALESCE ）
查询员工表，显示员工编号、姓名和部门编号。如果部门编号为NULL，则显示为 '未分配'。
提示：使用  COALESCE  函数处理可能的空值。
任务四：字符串处理（ SUBSTRING ）
查询员工表，显示员工编号、姓名，以及名字的首字母（提取first_name的第一个字符）。
提示：使用  SUBSTRING(first_name, 1, 1) 。
任务五：综合挑战
查询薪资表，为每个员工的最新薪资记录添加绩效评级：
薪资 > 80000：'优秀'薪资 60000-80000：'良好'薪资 < 60000：'待提升'
提示：需要先找出每个员工的最新薪资记录，可能需要用到子查询或窗口函数。*/
SELECT 	dept_no,CONCAT(first_name,' ',last_name) AS name,
	CASE 
			WHEN gender='M' THEN '男性'
			WHEN gender='W' THEN '女性'
			ELSE  '未知'
	END AS gender_Chinese
FROM employees;

SELECT TIMESTAMPDIFF(YEAR,hire_date,CURDATE()) AS work_year,CONCAT(first_name,' ',last_name) AS name,gender,emp_no,birth_date,dept_no,
CASE
		WHEN TIMESTAMPDIFF(YEAR,hire_date,CURDATE())>10 THEN '老员工'
		WHEN 5<=TIMESTAMPDIFF(YEAR,hire_date,CURDATE())<=10 THEN '中级员工'
		WHEN TIMESTAMPDIFF(YEAR,hire_date,CURDATE())<5 THEN '新员工'
		ELSE '未知'
END AS Employee_Classifiction
FROM employees;

SELECT work_year,name,gender,emp_no,birth_date,dept_no,
CASE
		WHEN work_year>10 THEN '老员工'
		WHEN 5<=work_year AND work_year<=10 THEN '中级员工'
		WHEN work_year<5 THEN '新员工'
		ELSE '未知'
END AS Employee_Classifiction
from(
select emp_no,TIMESTAMPDIFF(YEAR,hire_date,CURDATE()) AS work_year,CONCAT(first_name,' ',last_name) AS name,birth_date,dept_no,gender
from employees)
AS t;

SELECT emp_no,CONCAT(first_name,' ',last_name) AS name,
COALESCE(dept_no,'未分配') AS depertment
from employees;

SELECT emp_no,CONCAT(first_name,' ',last_name) AS name,
SUBSTRING(first_name,1,1)
FROM employees;

SELECT latest_salaries.salary,latest_salaries.emp_no,
CASE
		WHEN latest_salaries.salary>80000 THEN '优秀'
		WHEN latest_salaries.salary BETWEEN 60000 AND 80000 THEN '良好'/*一开始忘记了between and 的使用，而是使用了数学区间*/
		WHEN latest_salaries.salary<60000 THEN '待提升'
    ELSE '未知'
END AS PerformanceRating
FROM (
	SELECT s.emp_no,s.salary,s.from_date
	FROM  salaries s
	join (
		SELECT emp_no,MAX(from_date) AS latest_date
		from salaries 
		GROUP BY emp_no
				)emplyee_latest_date
	on emplyee_latest_date.emp_no=s.emp_no and emplyee_latest_date.latest_date=s.from_date
			)latest_salaries
/*一开始并没有办法去使用子查询以及派生表来解决问题*/