/*
SELECT *
FROM employees
where `first_name `='张'; 
时间: 0.143s

EXPLAIN SELECT *
FROM employees
where `first_name `='张';
type->ALL rows->6

CREATE INDEX idx_first_name on employees(`first_name `);
SELECT *
FROM employees
where `first_name `='张';
 时间: 0.021s

EXPLAIN SELECT *
FROM employees
where `first_name `='张';
 type->ref rows->1
花费时间变少了，type类型发生变化 ALL->ref ，查询的列变少了

SELECT *
FROM employees
where `first_name `='张' AND `last_name `='明';
时间: 0.001s

CREATE INDEX idx_name_composite on employees( `first_name `,`last_name `);

EXPLAIN SELECT *
FROM employees
where `first_name `='张' AND `last_name `='明';
type->ref rows->1
时间: 0.000s

SHOW INDEX FROM employees;

INSERT INTO employees (first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES
('蒋','颖','jiang.ying@company.com','2025-11-25',70000.00,3);
 时间: 0.108s
此时有多条索引，每次插入都需要更新到B+树，是巨大开销
INSERT INTO employees (first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES
('梅','涵','mei.han@company.com','2025-11-25',60000.00,1);
时间: 0.015s  没删除索引，但时间短可能是因为幸运的避免了索引树分裂，可能受益于内存缓存
 DROP INDEX idx_name_composite on employees;
SHOW INDEX FROM employees;
INSERT INTO employees (first_name ,last_name ,email ,hire_date ,salary ,dept_id )
VALUES
('李','星','li.xing@company.com','2025-11-25',80000.00,2);
时间: 0.011s 删除了复合索引 显著减少了数据库要维护的索引数量，写入负担减轻
*/
SELECT *
FROM employees
where `first_name ` like '%张';-- 返回了张明的记录 未发现出现错误

EXPLAIN SELECT *
FROM employees
where `first_name ` like '%张';-- type->ALL rows->9 索引失效

SELECT *
FROM employees
where UPPER(`first_name `)='ZHANG';-- 返回都为空

EXPLAIN SELECT *
FROM employees
where UPPER(`first_name `)='ZHANG'; -- type->ALL 索引失效

EXPLAIN SELECT *
FROM employees
where `first_name `='张' AND `last_name `='明';-- type->ref 此时索引未失效

EXPLAIN SELECT *
FROM employees
where `first_name `!='张';-- type->ALL 索引失效
/*
索引能大幅提升读操作（SELECT）性能，但是会降低写操作（INSERT UPDATE DELETE)性能
索引占用额外的内存空间，来换取时间的缩短
因此 读多写少的表，建议使用索引；写多读少的表，谨慎添加索引；核心查询路径（凡是出现在WHERE JOIN ON ORDER BY 子句中的高频字段） 都应考虑索引*/