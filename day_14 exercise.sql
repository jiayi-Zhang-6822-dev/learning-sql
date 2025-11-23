/*
任务一：使用 EXISTS 查询存在关系的记录
查询存在员工的部门信息。
提示：使用  EXISTS  判断在  employees  表中是否有记录与  departments  表的  dept_id  匹配。
思考：这个查询与  INNER JOIN  有什么异同？在什么场景下  EXISTS  更优？

任务二：使用 NOT EXISTS 查询“无”关系的记录
查询尚未分配任何员工的部门信息。
提示：使用  NOT EXISTS  找出在  employees  表中没有对应员工的部门。
思考：这个查询的现实业务意义是什么？（如：找出闲置的部门）

任务三：使用 ANY/SOME 进行条件比较
查询薪资高于销售部（dept_id=2）任一员工的员工信息。
提示： WHERE salary > ANY (SELECT salary FROM employees WHERE dept_id = 2) 
比较：尝试将  ANY  改为  ALL ，看看结果有何不同？（查询薪资高于销售部所有员工的员工）

任务四：使用 CASE 表达式进行复杂数据分类
对员工进行薪资等级分类，并统计每个等级的人数：
高薪资（薪资 >= 90000）：'High'
中薪资（80000 <= 薪资 < 90000）：'Medium'
低薪资（薪资 < 80000）：'Low'
提示：在 SELECT 中使用 CASE 创建新列，然后使用 GROUP BY 进行分组统计。

任务五：性能思考与简单优化
查询所有姓‘李’的员工。
思考：如果想快速完成这个查询，可以在哪个字段上建立索引？为什么？
（可选）尝试为  last_name  字段添加一个索引，感受查询速度的变化（在数据量小时可能不明显）。*/
USE  company_hr;
-- 任务一
SELECT d.dept_id,d.dept_name
FROM departments  d
WHERE EXISTS (
SELECT 1 FROM employees e  -- 用1知识告诉数据库只要EXISTS子查询里能查到这一行数据就行，用1最快最省资源
where e.dept_id =d.dept_id);
-- INNER JOIN主要是求交集，返回两表的笛卡尔积 不会去重，而EXISTS 是判断存不存在，会自动去重，只要存在就会停止扫描，可以用于大表去重，大表早停。
-- 需要组合数据和列表的时候用INNER JOIN,只判断存不存在，去重时可以用EXISTS 更快更省资源
SELECT d.dept_id,d.dept_name
FROM departments d
where not EXISTS(
SELECT 1 FROM employees e
WHERE e.dept_id =d.dept_id);

-- 任务三
SELECT *
FROM employees 
where salary >ANY(
SELECT salary  
FROM employees 
where dept_id =2);

SELECT *
FROM employees
where salary >ALL(
SELECT salary 
FROM employees
WHERE dept_id =2);
-- 任务四
SELECT 
CASE 
	WHEN salary >=90000 THEN 'High'
	WHEN salary  BETWEEN 80000 AND 90000 THEN 'Medium'
	WHEN salary <=80000 THEN 'Low'
	END AS salary_level,
count(*) AS employee_count
FROM employees
GROUP BY 
CASE 
	WHEN salary >=90000 THEN 'High'
	WHEN salary  BETWEEN 80000 AND 90000 THEN 'Medium'
	WHEN salary <=80000 THEN  'Low'
	END;

-- 任务五
SELECT *
FROM employees
where first_name ='李';
/*
CREATE INDEX idx_last_name ON employees(last_name );建立索引之后任务五的查询时间从0.001变为了0.000