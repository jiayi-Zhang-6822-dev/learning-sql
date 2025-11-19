/*
 任务一：NTILE函数 - 数据分桶
将公司所有员工按工资高低分为4个等级（Quartile），显示员工编号、工资及所属等级。
提示： NTILE(4) OVER (ORDER BY salary DESC) 

任务二：PERCENT_RANK函数 - 百分比排名
计算每个员工工资在公司内的百分比排名（0到1之间的小数，表示该员工工资超过了多少比例的人）。
提示： PERCENT_RANK() OVER (ORDER BY salary) 

任务三：CUME_DIST函数 - 累积分布
计算每个员工工资的累积分布（即工资小于等于该员工工资的比例）。
提示： CUME_DIST() OVER (ORDER BY salary) 

任务四：窗口框架 - 动态累加
计算每个部门内，按员工编号排序的累计工资（从部门第一个员工到当前员工）。
提示： SUM(salary) OVER (PARTITION BY dept_no ORDER BY emp_no ROWS UNBOUNDED PRECEDING) 

任务五：综合挑战 - 部门工资天花板分析
查询每个员工，显示其工资、所在部门的平均工资，以及其工资占部门最高工资的比例。
提示：需要组合使用 AVG() 、 MAX() 窗口函数和 PARTITION BY dept_no */
SELECT emp_no,salary,
NTILE(4) OVER (ORDER BY salary 	DESC) AS salary_quartile
FROM salaries;


SELECT salary,emp_no,
PERCENT_RANK() OVER (ORDER BY salary) AS salary_percnetRank
FROM salaries;

SELECT emp_no,salary,
CUME_DIST() OVER(ORDER BY salary) AS salary_cumeDist
FROM salaries;

SELECT e.emp_no,s.salary,e.dept_no,
SUM(salary) OVER (PARTITION BY 	dept_no ORDER BY emp_no 	ROWS UNBOUNDED PRECEDING) AS running_total
FROM employees e
join salaries s on s.emp_no=e.emp_no;

SELECT e.emp_no,s.salary,e.dept_no,
AVG(salary) OVER (PARTITION BY dept_no ) AS avg_salary,
MAX(salary) OVER (PARTITION BY dept_no) AS depertment_max_salary,
salary/(MAX(salary) OVER (PARTITION BY dept_no)) AS rate
FROM employees e
join salaries s on s.emp_no=e.emp_no;
