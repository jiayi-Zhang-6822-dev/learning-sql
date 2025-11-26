/*
任务一：创建基本视图，简化查询
创一个名为  v_employee_info  的视图，隐藏敏感薪资信息，只显示员工ID、姓名、邮箱、入职日期和部门ID。
思考：这个视图对普通业务人员查询员工基本信息有何便利？

任务二：创建连接多表的复杂视图
创建一个名为  v_employee_detail  的视图，连接 employees 和 departments 表，显示：
员工ID、姓名、部门名称（而不仅仅是部门ID）、入职日期、薪资
体验：体会视图如何将复杂的 JOIN 操作“封装”起来。

任务三：创建带条件的视图
创建一个名为  v_high_salary_employees  的视图，仅显示薪资大于80000的员工的所有信息。
思考：这个视图相当于一个什么样的 WHERE 子句？

任务四：操作视图（注意限制）
尝试通过视图  v_employee_info  插入一条新的员工记录。
思考：为什么有些视图可以更新（INSERT/UPDATE/DELETE），而有些不可以？其规则是什么？

任务五：管理视图
查看已创建视图的定义： SHOW CREATE VIEW v_employee_detail; 
删除视图： DROP VIEW v_high_salary_employees; 

（可选）尝试修改一个已存在的视图。*/
/*
CREATE VIEW v_employee_info AS
SELECT `emp_id `,`first_name `,`last_name `,`email `,`hire_date `,`dept_id `
FROM employees;

CREATE VIEW v_employee_detail AS
SELECT `emp_id `,`first_name `,`last_name `,d.dept_id,dept_name,`hire_date `,`salary `
FROM employees e
join departments d on d.dept_id=e.`dept_id `;

CREATE VIEW v_high_salary_employees AS
SELECT *
FROM employees
WHERE `salary `>80000;

INSERT INTO v_employee_info(first_name ,last_name ,email ,hire_date ,dept_id )
VALUES('张','一','zhang.yi@company.com','2025-11-26',3); v_employee_info视图可以插入数据
INSERT INTO v_high_salary_employees(first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES('祝','娴','zhu.xian@company.com','2025-11-26',90102,2);v_high_salary_employees视图可以插入数据

INSERT INTO v_employee_detail (first_name ,last_name ,dept_id,dept_name,hire_date ,salary )
VALUES('刘','彤',2,'销售部','2025-11-26',70302);
Can not modify more than one base table through a join view 'company_hr.v_employee_detail' 无法通过联接视图“company_hr.v_employee_detail”修改多个基表。*/

SHOW CREATE VIEW v_employee_info;
SHOW CREATE VIEW v_high_salary_employees;
SHOW CREATE VIEW v_employee_detail;
/*
根据SQL标准，一个视图可以被更新，必须满足以下条件（简化版）：

基于单个表（不能有 JOIN 、 UNION 等）。

不包含聚合函数（如 GROUP BY ,  COUNT() ,  SUM() ）。

不包含 DISTINCT 关键字。

不包含子查询在 SELECT 列表中。

包含基表的所有 NOT NULL 且无默认值的列（否则 INSERT 时无法提供值）。*/