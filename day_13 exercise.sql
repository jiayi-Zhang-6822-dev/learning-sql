/*
任务一：创建带外键的部门表
创建  departments  表，包含  dept_id （主键）和  dept_name （部门名称，非空且唯一）。
向  departments  表插入以下部门数据：
1, '技术部'  2, '销售部'  3, '市场部'  4, '人事部'

任务二：为员工表添加外键约束
修改  employees  表，为  dept_id  字段添加外键约束，引用  departments  表的  dept_id  字段。
思考：在添加外键前，为什么需要先确保  employees  表中现有的  dept_id  值（如1,2,3,4）必须在  departments  表中存在？

任务三：测试外键约束的威力
正向测试：尝试插入一个新员工，其  dept_id  为  departments  表中存在的值（如1），观察是否成功。
反向测试：尝试插入一个新员工，其  dept_id  为  departments  表中不存在的值（如99），观察数据库的反应（应该报错）。

任务四：应用唯一约束与非空约束
为  employees  表的  email  列添加唯一约束 UNIQUE ，确保邮箱地址不重复。
为  first_name  和  last_name  列明确加上  NOT NULL  约束。
测试：尝试插入两条邮箱相同的记录，观察结果。

任务五：探索检查约束
为  employees  表的  salary  列添加检查约束 CHECK ，确保薪资大于0。
测试：尝试插入一条薪资为  -5000  的记录，观察结果*/

/*
CREATE TABLE departments(
dept_id INT PRIMARY KEY 
dept_name VARCHAR(50)  NOT NULL  UNIQUE);
INSEERT INTO departments VALUES
(1,'技术部'),
(2,'销售部'),
(3,'市场部'),
(4,'人事部');

ALTER TABLE employees 
ADD CONSTRAINT fk_emp_dept
FOREIGN KEY (dept_id ) REFERENCES departments(dept_id);
*/
/*
INSERT INTO employees(first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES
('刘','哲','liu.zhe@company','2025-11-20',59000,2); #成功但是他的emp_id加到了14*/

/*INSERT INTO employees(first_name ,last_name ,email ,hire_date ,salary ,dept_id )
 VALUES
('陈','梓','chen.zi@company','2025-11-20',79000,99); #未成功无法添加或更新子行：外键约束失败 (company_hr.employees, 约束 fk_emp_dept 外键 (dept_id) 引用 departments (dept_id))
（说明：操作违反了dept_id字段的外键约束，需确保departments表中存在对应的dept_id值）*/

/*唯一约束与非空约束
ALTER TABLE  employees
ADD UNIQUE(email ) ;
ALTER TABLE employees
MODIFY first_name  VARCHAR(50)  NOT NULL,
MODIFY last_name  VARCHAR(50)  NOT NULL;
SHOW CREATE TABLE employees;*/


-- INSERT INTO employees (first_name ,last_name ,email ,hire_date ,salary ,dept_id )VALUES
-- ('李','星','li.xing@company','2025-11-20',53000,3),
-- ('蒋','颖','li.xing@company','2025-11-20',68000,2);#- Duplicate entry 'li.xing@company' for key 'employees.email '不可插入邮箱相同的数据
-- ALTER TABLE employees
-- ADD CONSTRAINT chk_salary_positive CHECK (salary >0);
/*
INSERT INTO employees(first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES('梅','涵','mei.han@company','2025-11-20',-50000,3);
检查约束 'chk_salary_positive' 被违反。（说明：违反了薪资必须为正数的约束条件，salary字段的值不能小于或等于0）*/