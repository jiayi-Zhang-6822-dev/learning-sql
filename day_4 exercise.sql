/*
任务一：字符串函数（拼接与大小写）
查询员工表，将员工的姓氏（ last_name ）和名字（ first_name ）用逗号连接成一个完整的“姓名”字段，并全部显示为大写字母。
提示： CONCAT(str1, str2)  用于拼接； UPPER(str)  用于转大写。

任务二：字符串函数（截取与长度）
查询员工表，显示员工的名字（ first_name ），并计算出每个名字的长度。
提示： LENGTH(str)  用于计算长度。

任务三：日期时间函数（提取年份）
查询员工表，列出所有员工的姓名和他们的出生年份。
提示： YEAR(date)  用于从日期中提取年份。

任务四：日期时间函数（计算工龄）
查询员工表，列出员工姓名、入职日期（ hire_date ），并计算他们截至今天（ CURDATE() ）的工龄（单位为年，使用  DATEDIFF  和除法计算，或使用  TIMESTAMPDIFF ）。
提示： CURDATE()  获取当前日期； DATEDIFF(date1, date2)  计算日期差； TIMESTAMPDIFF(unit, start, end)  更便于计算年差。

任务五（综合挑战）：字符串与日期组合
查询员工表，生成一条描述信息，格式为： 员工 [firstName] [lastName] 于 [year] 年入职 。
例如： 员工 John DOE 于 2005 年入职 。
提示：需要组合使用  CONCAT  和  YEAR  等函数。
*/
SELECT UPPER(CONCAT(last_name,',',first_name)) AS NAME
FROM employees;

SELECT first_name ,LENGTH(first_name)
FROM employees;

SELECT CONCAT(last_name,',',first_name) AS name,YEAR(birth_date) AS birthYear
FROM employees;

SELECT CONCAT(last_name,',',first_name) AS name,hire_date,FLOOR(DATEDIFF(CURDATE(),hire_date)/365) AS LengthOfServices
FROM employees;
-- 这种方法会忽略闰年，不准确，推荐下面的方法

SELECT CONCAT(last_name,',',first_name) AS name,hire_date,TIMESTAMPDIFF(YEAR,hire_date,CURDATE()) AS LengthOfServices
from employees;

SELECT CONCAT('员工',first_name,' ',last_name,'于',YEAR(hire_date),'年入职') AS information
FROM employees;
