/*
任务一：创建审计触发器（记录数据变更）
创建一个 salary_changes_audit 表，用于记录薪资变更日志（字段： log_id ,  emp_id ,  old_salary ,  new_salary ,  change_time ,  action_by ）。
创建一个 AFTER UPDATE 触发器 trg_audit_salary_change ，当 employees 表的 salary 被更新时，自动将变更记录插入审计表。
目标：实现薪资变更的自动追踪。

任务二：创建数据验证触发器（阻止非法数据）
创建一个 BEFORE INSERT 触发器 trg_prevent_negative_salary ，在插入新员工记录前检查薪资是否大于0。如果薪资为负数，则触发错误阻止插入。
关键：学习如何使用 SIGNAL 语句主动抛出错误。

任务三：创建级联更新触发器（维护数据一致性）
创建一个 AFTER UPDATE 触发器 trg_update_department_stats ，当员工薪资更新后，自动重新计算该员工所在部门的平均薪资，并更新到 departments 表的一个新字段 avg_salary 中（需先添加此字段）。
挑战：实现跨表的自动数据同步。

任务四：综合练习——员工入职自动化
创建一个 BEFORE INSERT 触发器 trg_set_employee_defaults ，在新员工入职（ INSERT ）前自动设置：如果邮箱为NULL，则自动生成邮箱（规则： first_name.last_name@company.com ）；如果入职日期为NULL，则自动设置为当前日期。
体验：触发器的自动化威力。

任务五：管理触发器
查看当前数据库中的所有触发器： SHOW TRIGGERS; 
删除指定的触发器： DROP TRIGGER IF EXISTS trg_name; */

-- 任务一 构建审计表
/*
CREATE TABLE salary_changes_audit(
log_id INT PRIMARY KEY AUTO_INCREMENT,
emp_id INT NOT NULL,
old_salary DECIMAL(10,2) NOT NULL,
new_salary DECIMAL(10,2)  NOT NULL,
change_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
action_by VARCHAR(100) DEFAULT (USER()) 
);
*/
/*知识补充
DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP 如果插入行没有给change_date值，MYSQL就自动用当前服务器时间填进去 不用再用应用层时间填进去
VARCHAR(100) DEFAULT USER() 插入时没给列值，就填当前连接的用户名，记录了谁触发了触发器，USER()返回的是登陆账户，不是业务工号
DEFAULT后面不能直接接USER(),8.0后要求函数？表达式做默认值必须加括号，比如(USER())变成字符串函数形式
*/
-- 任务一 构造审计触发器
/*
DELIMITER //
CREATE TRIGGER trg_audit_salary_change
AFTER UPDATE ON employees
FOR EACH ROW 
BEGIN
	IF OLD.salary !=NEW.salary  THEN
		INSERT INTO salary_changes_audit(emp_id ,old_salary,new_salary)
		VALUES(NEW.emp_id ,OLD.salary ,NEW.salary );
END IF;
END //
DELIMITER ;
*/

/*知识补充
FOR EACH ROW 
触发器分两种粒度：行级和语句级（省略该子句）。
行级 每改一行就触发一次， 慢但精确 能用OLD/NEW
语句级 一条SQL语句只触发一次 快 无OLD/NEW
触发器有多种类型 BEFORE/AFTER ,INSERT/UPDATE/DELETE
触发器核心关键字是OLD,NEW
调试触发器 使用SIGNAL或SELECT
当需要自动响应数据变化时触发器

NEW.col 以及OLD.col 都是触发器内部的伪记录，OLD.col表示更新/删除前的旧值，NEW.col表示更新/插入后的新值。
而new_salary知识一个普通的列名，跟伪记录无关系
*/

-- 任务二
/*
DELIMITER //
CREATE TRIGGER trg_prevent_negative_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN 
	IF NEW.salary <0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='薪资不能为负数';
	END IF;
END //
DELIMITER ;
*/
/*知识补充
IF NEW.salary <0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='薪资不能为负数';
这里是说即将写入的salary是负数就向客户端抛出一个异常；
‘45000’是MYSQL保留的‘通用用户错误’状态码；
SET以及后面表示并给这个异常附带一条可读提示，客户端会收到这条文字
应用端收到：ERROR 1644(45000):薪资不能为负数
45000是MYSQL留给用户自定义错误的‘万能码’ 官方保留：45000~44999区间专门给SIGNAL用户用，一般写45000比较省事
*/

-- 任务三
/*
DELIMITER //
CREATE TRIGGER trg_update_department_stats
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
	UPDATE departments d
	SET avg_salary=(
		SELECT AVG(salary)
		FROM employees 
		WHERE dept_id=d.dept_id )
	WHERE d.dept_id=NEW.dept_id ;
END//
DELIMITER ;
*/
/*
第一个WHERE-> WHERE dept_id=d.dept_id 是相关子查询，让departments的每一行只算自己部门的平均薪资
第二个WHERE-> WHERE d.dept_id=NEW.dept_id  是触发器限制范围 只更新修改员工所在的那一个部门
*/
-- 任务四
/*
DELIMITER //
CREATE TRIGGER trg_set_employee_defaults
BEFORE INSERT ON employees
FOR EACH ROW 
BEGIN
IF NEW.email  IS NULL  THEN
	SET NEW.email  =LOWER(CONCAT(NEW.first_name ,'.',NEW.last_name ,'@company.com'));
END IF;
IF NEW.hire_date  IS NULL THEN
	SET NEW.hire_date =CURDATE();
END IF;
END//
DELIMITER ;
*/
/*
存储函数->'公式',必须return一个值
存储过程->'脚本', 用SET给OUT参数，无return
触发器->'改行',用SET NEW.col=... ，无return
default 插入时如果列没给值就用它指定的默认内容‘填坑’——发生在真正写入磁盘之前，和触发器/函数/过程无关*/

-- 任务五
 SHOW TRIGGERS;
-- 列出当前数据库所有触发器
-- SHOW TRIGGERS WHERE `Table`='employees';列出这个表上的触发器 注意！Table两侧是反引号  是英文键盘左上角数字1左边的符号
-- DROP TRIGGER IF EXISTS trg_set_employee_defaults;删除指定触发器