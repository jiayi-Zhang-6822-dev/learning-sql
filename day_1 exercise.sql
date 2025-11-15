/*
基础查询：查询所有性别为‘F’（女性）的员工的所有信息。
逻辑运算：查询在‘d005’（Development）部门入职的男性（‘M’）员工。
范围查询：查询在2005年到2007年之间入职的员工编号和姓名（ emp_no ,  first_name ,  last_name ）。
模糊查询：查询姓氏（ last_name ）以‘S’开头的员工。
空值检查：查询那些还没有分配部门（ dept_no  为 NULL）的员工。（提示：目前数据中可能没有，但请写出这个查询语句）。
*/
SELECT *
FROM employees
where gender="F";

SELECT *
FROM employees
where dept_no="d005" and gender="F";

SELECT emp_no,first_name,last_name
FROM employees
where YEAR(hire_date) BETWEEN 2005 and 2007;

SELECT *
FROM employees
where last_name like "S%";

SELECT *
FROM employees
where dept_no is NULL;
