/*
任务一：创建无参数的简单存储过程
创建一个名为  sp_get_all_employees  的存储过程，用于获取所有员工的详细信息。
体验：感受如何将固定的查询封装成可重用的模块。

任务二：创建带输入参数的存储过程
创建一个名为  sp_get_employees_by_dept  的存储过程，接受一个部门ID作为参数，返回该部门的所有员工。
思考：参数如何让存储过程变得灵活？

任务三：创建带输出参数的存储过程
创建一个名为  sp_get_dept_employee_count  的存储过程，接受部门ID，返回该部门的员工数量（通过输出参数）。
关键：学习如何从存储过程中“取出”一个标量值。

任务四：创建包含业务逻辑的存储过程
创建一个名为  sp_give_raise  的存储过程，模拟公司调薪：
接受参数： in_dept_id （部门ID）、 raise_percent （涨幅百分比）。
更新该部门所有员工的薪资： salary = salary * (1 + raise_percent / 100) 。
返回受影响的行数。
挑战：在数据库中实现业务逻辑。

任务五：综合练习与调用
编写一个存储过程  sp_get_employee_detail ，根据员工ID返回其详细信息（包括部门名称）。
学习如何调用各种类型的存储过程，特别是如何获取输出参数的值。*/
-- 任务一
/*
DELIMITER //      1.临时换结束符，让分号不中断
CREATE PROCEDURE sq_get_all_employees()   2.起名加参数列表（无参不写）
BEGIN
SELECT *         3.开始装脚本
FROM employees;
END //
DELIMITER ;
*/
--  SHOW PROCEDURE STATUS WHERE Db='company_hr';展示数据库下所有的存储过程

-- 任务二
/*
DELIMITER //
CREATE PROCEDURE sp_get_employees_by_dept(IN p_dept_id INT)  这里不要写dept_id不然会列名=列名始终为真where子句就没什么用了
BEGIN 
SELECT *
FROM employees e
WHERE dept_id =p_dept_id;
END //
DELIMITER ;
*/
CALL sp_get_employees_by_dept(2);
--  DROP PROCEDURE IF EXISTS sp_get_employees_by_dept;

-- 任务三
/*
DELIMITER //
CREATE PROCEDURE sp_get_dept_employee_count(IN  p_dept_id INT,OUT employee_count INT) 有参数  输入IN 输出OUT 后面记得加上它们的数据类型
BEGIN
SELECT COUNT(*) INTO employee_count   SELECT INTO将值赋给了OUT输出
FROM employees
WHERE dept_id =p_dept_id;
END //
DELIMITER ;
*/
CALL sp_get_dept_employee_count(2,@count);SELECT @count;
-- DROP PROCEDURE IF EXISTS sp_get_dept_employee_count;

-- 任务四
/*
DELIMITER //
CREATE PROCEDURE sp_give_raise(
IN in_dept_id INT,
IN raise_percent DECIMAL(5,2))
BEGIN
UPDATE employees
SET salary =salary *(1+raise_percent/100)
WHERE dept_id =in_dept_id;
END //
DELIMITER ;
*/
-- CALL sp_give_raise(2,10.0);
SELECT `dept_id `,salary 
FROM employees
WHERE dept_id =2;
-- 任务五
/*
DELIMITER //
CREATE PROCEDURE sp_get_employee_detail(IN p_dept_id INT )
BEGIN
SELECT *
FROM employees e
join departments d on e.dept_id =d.dept_id
WHERE e.dept_id =p_dept_id;
END //
DELIMITER ;
*/
CALL sp_get_employee_detail(2);
-- DROP PROCEDURE IF EXISTS sp_get_employee_detail;
