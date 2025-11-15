/*
任务一：基础排序
查询所有员工的信息（ employees  表），按照入职日期（ hire_date ）从早到晚（升序）排列。

任务二：降序排序
查询所有员工的信息，按照员工编号（ emp_no ）从大到小（降序）排列。

任务三：多列排序（重要！）
查询所有员工的信息，先按所在部门（ dept_no ）升序排列，同一个部门内再按入职日期（ hire_date ）降序排列。（这个任务能帮您清晰理解多列排序的优先级）

任务四：去重查询
查询公司中所有不重复的部门编号（ dept_no ）。（您应该得到一个包含所有部门编号的列表，且每个编号只出现一次）

任务五：综合挑战
查询  titles  表，列出所有不重复的职位名称（ title ），并将结果按职位名称的字母顺序（A-Z）升序排列。*/

SELECT *
FROM employees
ORDER BY hire_date;

SELECT *
FROM employees
ORDER BY emp_no;

SELECT *
FROM employees
ORDER BY dept_no ,hire_date DESC;

SELECT  DISTINCT dept_no
FROM departments;

SELECT DISTINCT title
FROM titles
ORDER BY title;
