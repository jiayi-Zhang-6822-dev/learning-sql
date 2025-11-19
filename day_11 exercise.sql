/*
任务一：创建数据库
创建一个名为  company_hr  的数据库，用于存储公司的人力资源数据。
提示： CREATE DATABASE company_hr; 

任务二：选择数据库
开始使用新创建的数据库。
提示： USE company_hr; 

任务三：创建数据表
在  company_hr  数据库中创建一个  employees  表，包含以下字段：
 emp_id ：整数，主键，自动增长
 first_name ：可变长度字符串（50）
 last_name ：可变长度字符串（50）
 email ：可变长度字符串（100）
 hire_date ：日期类型
 salary ：十进制数（总共10位，小数点后2位）
 dept_id ：整数
提示：使用  CREATE TABLE  语句，定义主键和自动增长。

任务四：修改表结构
向  employees  表中添加一个新列  phone ，类型为  VARCHAR(20) 。
将  email  列修改为  VARCHAR(150) 。
删除  phone  列。
提示：使用  ALTER TABLE ... ADD/ALTER/DROP COLUMN 。

任务五：创建用户并授权
创建一个新用户  hr_manager ，密码为  hr_123456 。
授予该用户对  company_hr  数据库的所有表的查询（ SELECT ）和插入（ INSERT ）权限。
查看该用户的权限。
（可选）撤销该用户的插入权限。
提示： CREATE USER ,  GRANT ,  SHOW GRANTS ,  REVOKE 。*/

#CREATE DATABASE company_hr;
/*
CREATE TABLE employees
(emp_id INT PRIMARY KEY AUTO_INCREMENT,
 first_name  VARCHAR(50) NOT NULL,
 last_name   VARCHAR(50) NOT NULL,
 email  VARCHAR(100) UNIQUE,
 hire_date   DATE,
 salary  DECIMAL(10,2)
 dept_id  INT);
*/

/*
ALTER TABLE employees 
ADD COLUMN phone VARCHAR(20);
ALTER TABLE employees 
ALTER COLUMN email  UNIQUE VARCHAR(150);
ALTER TABLE employees
DROP COLUMN phone;*/
/*
CREATE USER 'hr_manager'@'localhost' IDENTIFIED BY 'hr_123456';
GRANT SELECT ,INSERT ON company_hr.*  TO 'hr_manager'@'localhost';
SHOW GRANTS FOR 'hr_manager'@'localhost';
REVOKE INSERT ON company_hr.* FROM  'hr_manager'@'localhost';
-- 查看用户现在的权限
SHOW GRANTS FOR 'hr_manager'@'localhost';
*/
