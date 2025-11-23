/*
任务一：部门薪资分析报告
生成一个部门薪资统计报告，包含以下信息：
部门编号、部门名称
部门员工总数
部门平均薪资（保留2位小数）
部门最高薪资
部门最低薪资
薪资超过80000的员工人数
提示：需要用到  JOIN 、 COUNT() 、 AVG() 、 MAX() 、 MIN() 、 SUM(CASE WHEN...)  和  GROUP BY 。

任务二：员工薪资排名分析
查询每个部门内薪资排名前2的员工信息（考虑并列情况），显示：
部门名称、员工姓名、薪资、部门内排名
提示：使用窗口函数  DENSE_RANK() OVER(PARTITION BY...ORDER BY...) ，然后筛选排名<=2。

任务三：薪资差距分析
找出每个部门中薪资与部门平均薪资差距最大的员工（即 |个人薪资-部门平均薪资| 最大），显示：
部门名称、员工姓名、薪资、部门平均薪资、薪资差距
提示：需要先计算部门平均薪资（子查询或窗口函数），再用 ABS() 计算绝对值差距。

任务四：部门人力资源健康度分析
创建一个综合报告，分析各部门的“人力资源健康度”：
部门名称
员工总数
高薪员工占比（薪资>=90000的比例）
是否缺乏员工（员工总数<2的部门标记为“急需招聘”）
薪资分布均匀度（(最高薪资-最低薪资)/平均薪资）
提示：综合运用 CASE WHEN 、聚合函数、数学运算。

任务五：数据库设计思考题
现有表结构为 员工表 和 部门表 ，如果业务需要记录每个员工的薪资调整历史（每次调薪的时间、调整前薪资、调整后薪资、调整原因），您会如何设计表结构？
请写出CREATE TABLE语句，并思考：这个新表与现有表如何关联？*/

USE company_hr;
-- 任务一
-- CASE WHEN THEN END的语法是什么，它可以在哪里用？可以嵌套到函数里吗？
/*返回一个变量值，位置随意放
搜索型 CASE WHEN 条件  简单型 CASE WHEN 表达式
无ELSE 默认NULL 聚合函数会跳过
1/0+聚合=条件计数/求和
*/
SELECT d.dept_id,d.dept_name,count(*) AS total_employee,ROUND(AVG(`salary `),2) AS avg_salary,MAX(`salary `) AS max_salary,MIN(`salary `)AS min_salary,
SUM(CASE WHEN `salary `>80000 THEN 1 ELSE 0 END ) AS  high_salary_count
FROM employees e
join departments d on d.dept_id=e.`dept_id `
GROUP BY d.dept_id;

-- 任务二
-- 什么时候用窗口函数，什么时候直接用普通函数呢？
-- 普通聚合函数+group by ：当需要多行数据压缩为一行摘要时使用（如任务一每个部门返回一行统计结果）
-- 窗口函数：当既要看到每行的数据的细节，又看到其所属分组的统计信息时使用（如任务三既要看每个员工薪资又要计算它与部门哦ing军薪资的差距），不减少行数
SELECT *FROM(
SELECT d.dept_name,CONCAT(`first_name `,'',`last_name `) AS name,e.`salary `,
DENSE_RANK()  OVER (PARTITION BY d.dept_id ORDER BY `salary `) AS dense_rank_salary
FROM departments d
JOIN employees e on e.`dept_id `=d.dept_id
) AS ranked_employee
where dense_rank_salary <=2;

-- 任务三
-- 当要查询的属性需要利用另一个自己计算、创建的不存在于表中的属性时，可以进行嵌套子查询
-- 窗口函数不允许嵌套，每个子表都要有自己的别名
SELECT dept_name,name,`salary `,avg_salary,gap AS max_gap
FROM(
	SELECT  dept_id,dept_name,name,`salary `,avg_salary,gap,RANK() OVER (PARTITION BY dept_id ORDER BY gap DESC) as gap_rank
	FROM(
		SELECT d.dept_id,d.dept_name,CONCAT(`first_name `,'',`last_name `) AS name,`salary `,
		AVG( `salary `) OVER (PARTITION BY d.dept_id) AS avg_salary,
		ABS(`salary ` - AVG( `salary `) OVER (PARTITION BY d.dept_id))AS gap
		FROM departments d
		join employees e on d.dept_id=e.`dept_id `
			)AS gaps
)AS ranked
WHERE gap_rank=1;

-- 任务四
-- 所有在SELECT中出现的非聚合字段都必须包含在GROUP BY中 因为GROUP BY的逻辑是：​按指定字段分组，每组返回一行记录。
SELECT dept_name,
			 employee_count,
			 num_high/employee_count AS high_share,
			 max_salary-min_salary/avg_salary  AS salary_distribution,
CASE 
WHEN employee_count<2 THEN '急需招聘'
ELSE '不缺乏员工'
END AS  satff_shortage
	FROM(
		SELECT d.dept_name,
		COUNT(*) AS employee_count,
		SUM(CASE WHEN e.`salary `>=90000 THEN 1 else 0 END) AS num_high,
		AVG(e.`salary `) AS avg_salary,
    MAX(`salary `) AS max_salary,
		MIN(`salary `) AS min_salary
		FROM employees e
		JOIN departments d on e.`dept_id `=d.dept_id
		GROUP BY d.dept_id,d.dept_name
		)AS t1;

-- 任务五
-- 可以把这个表和employees表通过emp_id 连接，避免 直接存储first_name 和last_name（防止重名问题）
CREATE TABLE salaryAdjustment(
change_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name  VARCHAR(50),
change_date  DATE NOT NULL,
old_salary DECIMAL(10,2) NOT NULL,
new_salary  DECIMAL(10,2)  NOT NULL,
reason  VARCHAR(200)
);

