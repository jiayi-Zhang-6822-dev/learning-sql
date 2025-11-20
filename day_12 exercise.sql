USE company_hr;
/*
INSERT INTO employees(first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES
('张', '明', 'zhang.ming@company.com', '2022-03-15', 75000.00, 1),
('李', '芳', 'li.fang@company.com', '2021-08-22', 82000.00, 2),
('王', '伟', 'wang.wei@company.com', '2023-01-10', 68000.00, 1),
('赵', '雪', 'zhao.xue@company.com', '2020-11-05', 91000.00, 3),
('刘', '洋', 'liu.yang@company.com', '2019-05-30', 105000.00, 2);
*/
#遇到了报错Unkown COLUMN 的情况，表设计里却存在这个字段，表设计工具的编辑状态与数据库服务器的实际状态不同步，还有手动输入的可能存在错误
#复制表设计字段，然后保存表设计再运行问题解决

/*
INSERT INTO employees(first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES
('陈','磊','chen.lei@company.com','2023-10-01',58000,4);
*/

/*任务二：更新数据 (UPDATE) – 业务操作
年度调薪：给所有销售部员工（dept_id = 2） 的薪资上涨10%。
统一邮箱：将所有销售部员工的邮箱域名更新为  @sales.company.com 。
关键步骤：在执行 UPDATE 前，请先写 SELECT 语句确认要更新的记录是“李芳”和“刘洋”。
UPDATE employees
SET `salary `=`salary `*1.1
where `dept_id `=2;
UPDATE employees
SET `email `=REPLACE(`email `,SUBSTRING_INDEX(`email `,'@',-1),'sales.company.com')
where `dept_id `=2;
*/

/*公司进行人员优化，需要清退2019年入职的员工（即最早入职的员工“刘洋”）。
SELECT CONCAT(`first_name `,'',`last_name `)
from employees
where `hire_date `<'2020-01-01';
DELETE FROM employees
where  `hire_date `<'2020-01-01';
*/

/*模拟一个员工的周期 入职 转正 离职
INSERT INTO employees(first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES
('张','三','zhang.san@company.com','2025-11-20',100000.00,NULL);
UPDATE employees
SET `dept_id `=3
where `first_name `='张' and `last_name `='三';
DELETE FROM employees
where `first_name `='张' and `last_name `='三';*/

/*任务五：创建备份表 (CREATE TABLE ... AS)
创建一个名为  high_salary_emps  的新表，包含  emp_id ,  full_name ,  salary  字段。
将  employees  表中当前薪资大于等于80000的员工信息插入到新表中。
提示：使用  INSERT INTO ... SELECT ...  语句。
CREATE TABLE high_salary_emps(
emp_id INT,
full_name VARCHAR(100),
salary DECIMAL(10,2)
);

INSERT INTO high_salary_emps(emp_id,full_name,salary)
SELECT `emp_id `,CONCAT(`first_name `,'',`last_name `),`salary `
FROM employees
where `salary `>=80000;*/
