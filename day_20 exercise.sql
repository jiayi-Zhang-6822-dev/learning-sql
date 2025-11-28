/*
任务一：创建无参数的存储函数
创建一个名为  fn_get_total_employee_count  的函数，返回公司员工总数。
关键语法： RETURNS  类型， RETURN  值。
调用方式： SELECT fn_get_total_employee_count(); 

任务二：创建带输入参数的存储函数
创建一个名为  fn_get_avg_salary_by_dept  的函数，接受部门ID作为参数，返回该部门的平均薪资。
思考：这个函数如何替代一个简单的 SELECT AVG(salary) ... 查询？优势在哪？

任务三：创建包含复杂逻辑的存储函数
创建一个名为  fn_get_salary_level  的函数，接受一个薪资值作为参数，根据以下规则返回薪资等级（字符串）：
高薪： salary >= 90000  -> 返回 'High'
中薪： 80000 <= salary < 90000  -> 返回 'Medium'
低薪： salary < 80000  -> 返回 'Low'
挑战：在函数中使用 IF 或 CASE 语句进行条件判断。

任务四：在查询中调用存储函数
编写一个查询，显示员工ID、姓名、薪资以及通过调用 fn_get_salary_level 函数得到的薪资等级。
体验：感受函数如何内嵌在SQL语句中，使查询更清晰。

任务五：综合练习
创建一个函数  fn_calculate_annual_salary ，根据员工ID，计算其年薪（假设年薪为月薪*12，并有一个年终奖参数bonus）。
公式： (salary * 12) + bonus 。*/
-- 任务一
/*
DELIMITER //
CREATE FUNCTION fn_get_total_employee_count()
RETURNS INT   声明最终返回类型
READS SQL DATA
BEGIN
DECLARE total_count INT;   在函数里临时开小变量，相当于一个小抽屉
SELECT COUNT(*) INTO total_count  把值存放到抽屉里
FROM employees;
RETURN total_count;  用抽屉里的值进行计算
END //
DELIMITER ;
*/
SELECT fn_get_total_employee_count();
-- SHOW FUNCTION STATUS WHERE Db='company_hr'; 和存储过程一样，查看当前数据库下所有的存储函数
-- DROP FUNCTION IF EXISTS  fn_get_total_employee_count; 删除存在的存储函数

-- 任务二
/*
DELIMITER //
CREATE FUNCTION fn_get_avg_salary_by_dept(p_dept_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA 
BEGIN
DECLARE avg_salary DECIMAL(10,2);注意这里有分号以及数据类型 容易忘记
SELECT  AVG(salary ) INTO avg_salary
FROM employees
WHERE dept_id =p_dept_id;
RETURN avg_salary;
END //
DELIMITER ;
*/
SELECT  fn_get_avg_salary_by_dept(2);

-- 任务三
/*
DELIMITER //
CREATE FUNCTION fn_get_salary_level(v_salary DECIMAL(10,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
IF v_salary>90000 THEN
	RETURN 'High';
ELSEIF v_salary <80000 THEN
	RETURN 'Low';
ELSE
	RETURN 'Medium';
END IF;
END //
DELIMITER ;
*/
 SELECT fn_get_salary_level(91000);
--  DROP FUNCTION IF EXISTS fn_get_salary_level;

-- 任务四
-- 显示员工ID、姓名、薪资以及通过调用 fn_get_salary_level 函数得到的薪资等级
SELECT `emp_id `,CONCAT(first_name ,'',last_name ) AS name,salary ,fn_get_salary_level(salary ) AS salary_level
FROM employees ;

-- 任务五
-- 创建一个函数  fn_calculate_annual_salary ，根据员工ID，计算其年薪（假设年薪为月薪*12，并有一个年终奖参数bonus）。公式： (salary * 12) + bonus 。
/*
DELIMITER //
CREATE FUNCTION fn_calculate_annual_salary(p_emp_id INT,p_bonus INT)
RETURNS DECIMAL(10,2)
READS SQL DATA 
BEGIN
DECLARE p_salary DECIMAL(10,2);
SELECT  `salary ` INTO p_salary
FROM employees
WHERE emp_id =p_emp_id;
RETURN p_salary*12+p_bonus;
END //
DELIMITER ;
*/
-- 在创建的时候总因为没有注意空格规范使用而导致错误信息指出 p_salary列不存在，但实际定义了这个字段却因为空格问题导致不一致
SELECT fn_calculate_annual_salary(1,10000);
-- DROP FUNCTION IF EXISTS fn_calculate_annual_salary;


/*
1.纯计算标DETERMINISTIC 
2.读表就标READS SQL DATA
3.写表就标MODIFIES SQL DATA 
4.无SELECT只有SET/IF/RETURN等流程  就标NO SQL
5.有SQL关键字 但不读写用户表 CONTAINS SQL 
4.5.都可以用DETERMINISTIC 
*/
/*存储过程用OUT输出，没有返回值，需要用CALL 过程名（参数）调用，常用于多部流程、报表生成
存储函数 可以像普通函数一样被用在SELECT WHERE ORDER BY等中，接收参数可以返回一个标量值，必须有且仅有一个返回值，常使用在计算、转换、复用等表达式中
一旦在数据库中创建了存储过程和存储函数，它们就成为了数据库服务器上的一个全局可调用对象，在新的查询窗口以及其他应用程序都可以调用它们，其他存储过程和存储函数内部也可以调用它们，实现代码复用
*/
