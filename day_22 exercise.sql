/*
任务一：理解事务的基本语法与流程
开启一个事务： START TRANSACTION; 
执行一系列SQL操作（例如：插入新员工、更新部门预算）。
提交事务： COMMIT; （使更改永久生效）
回滚事务： ROLLBACK; （撤销所有未提交的更改）
目标：掌握事务的生命周期。

任务二：模拟“员工入职”事务
模拟一个原子性操作：为新员工“王五”办理入职。
向 employees 表插入新记录。
更新 departments 表，将该部门的人数加1。
思考：如果插入成功但更新失败，会发生什么？如何用事务保证一致性？

任务三：体验事务回滚（模拟操作失败）
开启事务。
删除一个员工记录。
故意执行一条会出错的SQL（如：插入一个不存在的部门ID的员工）。
观察错误，然后执行回滚 ROLLBACK 。
检查被“删除”的员工记录是否恢复。
目标：亲身体验事务的“撤销”超能力。

任务四：探索事务的隔离性（并发控制）
打开两个独立的MySQL查询窗口（Session A和Session B）。
在Session A中开启事务并更新一条数据，但不提交。
在Session B中尝试查询同一条数据，观察结果。
理解“未提交读”和“已提交读”的区别。
目标：初步理解多用户并发环境下的数据可见性问题。

任务五：综合挑战——实现安全的“部门合并”
假设要将部门A的员工全部转移到部门B，然后删除空的部门A。
开启事务。
将所有属于部门A的员工的 dept_id 更新为部门B。
删除部门A。
提交事务。
思考：如果不使用事务，在步骤2和3之间数据库崩溃，会导致什么后果？*/

/*
事务是以组SQL的原子动作，要么全部成功要么全部失败，不支持嵌套无返回值，只有成功/失败状态
保证ACID也就是 原子性、一致性、隔离性、持久性
生命周期：一次连接内显示开启-提交/回滚*/

-- 任务一
/*
SELECT @@autocommit;
SET autocommit=0;
检查是否会自动提交，如果是自动提交会返回1
当需要执行事务（多个SQL作为一个原子操作）时关闭自动提交比较好
SHOW VARIABLES LIKE 'autocommit';
SELECT @@autocommit;
SELECT * FROM information_schema.innodb_trx; MYSQL检查事务状态常用方法*/
/*
表里没有headcount，添加使用
ALTER TABLE departments ADD COLUMN headcount INT DEFAULT 0;
UPDATE departments d 
SET headcount = (
    SELECT COUNT(*) 
    FROM employees e 
    WHERE e.dept_id = d.dept_id
);
headcount表上一直显示0，检查数据情况 显示正常
SELECT COUNT(*) AS 员工总数
FROM employees;
SELECT COUNT(*) AS 各部门员工数
FROM employees
GROUP BY `dept_id `;
SELECT headcount
FROM departments;
*/

/*开启事务
SET SESSION autocommit = 0;  
只影响当前会话
START TRANSACTION;
INSERT INTO employees (`first_name `,`last_name `,`email `,`hire_date `,`salary `,`dept_id `)
VALUES('赵','六','zhao.liu@company.com','2025-11-30',78000,2);
UPDATE departments SET headcount = headcount + 1 WHERE dept_id = 2;
COMMIT;
SET SESSION autocommit = 1;  
 及时恢复
*/

-- 任务二
/*
SET SESSION autocommit= 0;
START TRANSACTION;
INSERT INTO employees (`first_name `,`last_name `,`email `,`hire_date `,`salary `,`dept_id `)
VALUES('王','五','wang.wu@company.com','2025-11-30',60000,3);
UPDATE departments
SET headcount=headcount+1 WHERE dept_id= 3;
COMMIT;
SET SESSION autocommit=1;
*/

-- 任务三
/*
SET SESSION autocommit=0;
START TRANSACTION;
DELETE FROM employees WHERE `email `='zhang.yi@company.com';
INSERT INTO employees (`first_name `,`last_name `,`email `,`hire_date `,`salary `,`dept_id `)
VALUES('陈','明','chen.ming@company.com','2024-11-30',50400,7);
ROLLBACK;
SET SESSION autocommit=1;
报错信息 [Err] 1452 - Cannot add or update a child row: a foreign key constraint fails (`company_hr`.`employees`, CONSTRAINT `fk_emp_dept` FOREIGN KEY (`dept_id `) REFERENCES `departments` (`dept_id`))
1452错误 - 外键约束失败​ 意思是：您试图插入一个dept_id=7的员工，但departments表中不存在dept_id=7的部门
并且employees表中并未删除那条记录，实际上过程是删除了但插入失败因此回滚之前的删除操作也会撤销，事务的原子性得到完美体现
*/

-- 任务四
-- employees表上的触发器影响一直无法成功，因此构架了临时表类似表employees但不带有触发器
-- CREATE TEMPORARY TABLE temp_employees LIKE employees;
/*
INSERT INTO temp_employees(`first_name `,`last_name `,`email `,`hire_date `,`salary `,`dept_id `)
VALUES('李','冰','li.bing@company.com','2025-11-30',40400,4);
*/
/*
SESSION A	
SET SESSION autocommit = 0;
START TRANSACTION;
UPDATE temp_employees SET `salary `=`salary `+ 10000 WHERE `email `='li.bing@company.com';
SELECT 'Session A - 更新后的数据：' AS 提示;
SELECT first_name ,last_name ,salary  FROM temp_employees WHERE `email `='li.bing@company.com';

 SESSION B
 直接查询，使用数据库默认隔离级别
SELECT 'Session B - 默认隔离级别查询：' AS 提示;
SELECT first_name ,last_name ,salary  FROM temp_employees WHERE `email `= 'li.bing@company.com';

  设置未提交读隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT '=== READ UNCOMMITTED (未提交读) ===' AS 测试结果;
SELECT '可以看到Session A未提交的更改！' AS 说明;
SELECT first_name ,last_name ,salary 
FROM temp_employees
WHERE `email `='li.bing@company.com';

设置已提交读隔离级别  
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT '=== READ COMMITTED (已提交读) ===' AS 测试结果;
SELECT '只能看到已提交的数据，看不到未提交更改' AS 说明;
SELECT first_name ,last_name ,salary 
FROM temp_employees 
WHERE `email `= 'li.bing@company.com';

-提交事务
COMMIT;
SELECT 'Session A - 事务已提交' AS 提示;
 提交后再次查询 无返回结果
SELECT '=== 提交后的数据 ===' AS 测试结果;
SELECT first_name ,last_name ,salary 
FROM temp_employees 
WHERE  `email `= 'li.bing@company.com';

DROP TEMPORARY TABLE temp_employees;
*/
/*
未提交读（READ UNCOMMITTED）​​：像"透明墙"，能看到别人正在做的修改
​已提交读（READ COMMITTED）​​：像"实心墙"，只能看到最终确认的结果
​可重复读（REPEATABLE READ）​​：MySQL默认级别，更严格的隔离
​串行化（SERIALIZABLE）​​：最严格的隔离级别*/

-- 任务五
-- 同任务三一样之前建立的触发器干扰了此任务的实现 因此创建临时表
-- 1. 创建临时表（结构与原表相同，但没有触发器）

CREATE TEMPORARY TABLE temp_departments_2 LIKE departments;
CREATE TEMPORARY TABLE temp_employees_2 LIKE employees;

-- 2. 插入测试数据到临时表
INSERT INTO temp_departments_2 SELECT * FROM departments;
INSERT INTO temp_employees_2 SELECT * FROM employees;
 -- 3. 在临时表上执行您的事务测试
SET SESSION autocommit=0;
START TRANSACTION;

-- 在临时表上操作，不会触发任何触发器

INSERT INTO temp_departments_2 (dept_id, dept_name) VALUES (99, '测试部门');
UPDATE temp_employees_2 SET `dept_id `=3 WHERE `dept_id `=2;
DELETE FROM temp_departments_2 WHERE dept_id=99;

COMMIT;
SET SESSION autocommit=1;

-- 4. 查看结果
SELECT * FROM temp_employees_2 WHERE dept_id  IN (2,3);
SELECT * FROM temp_departments_2;

-- 5. 测试完成后删除临时表
DROP TEMPORARY TABLE temp_employees_2;
DROP TEMPORARY TABLE temp_departments_2;


-- DESC temp_employees_2;
-- DESC temp_departments_2;