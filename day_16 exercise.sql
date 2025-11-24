/*
任务一：设计一个不符合1NF的表（反面教材）

创建一个  students_bad  表，故意违反第一范式：
 courses （选修课程），用逗号分隔多个课程名称，如“数学,语文,英语”
目的：亲身感受违反范式带来的问题。

任务二：设计符合1NF的规范表
创建符合第一范式的  students （学生表）和  courses （课程表），并建立关联表  student_courses （学生选课表）。
思考：为什么要拆分成三张表？这解决了什么问题？

任务三：实施高级约束
在规范表的基础上添加约束：
为 students 表的 email 添加唯一约束。
为 courses 表的 course_name 添加唯一约束。
为 student_courses 表添加复合主键 (student_id, course_id) 。
为 students 表的 age 字段添加检查约束 (age BETWEEN 15 AND 60) 。

任务四：体验数据异常
向 students_bad 表插入数据，体验更新、删除异常。
向规范的三张表插入相同逻辑的数据，对比操作上的差异。

任务五：思考与优化
分析两种设计的查询差异：
“查询选修了‘数学’课程的所有学生姓名”
“查询每个学生选修的课程数量”*/

/*CREATE TABLE students_bad(
student_id int PRIMARY KEY,
student_name VARCHAR(50) NOT NULL,
email VARCHAR(100),
courses VARCHAR(200)
);

CREATE TABLE students(
student_id int PRIMARY KEY,
student_name VARCHAR(50) not NULL,
email VARCHAR(100),
age INT);

CREATE TABLE courses(
courses_id INT PRIMARY KEY,
course_name VARCHAR(50) NOT NULL
);

CREATE TABLE student_courses(
student_id INT,
courses_id  INT,
PRIMARY KEY(student_id,courses_id),
FOREIGN KEY(student_id) REFERENCES students(student_id),
FOREIGN KEY (courses_id) REFERENCES courses(courses_id)
);

ALTER TABLE students ADD CONSTRAINT  uk_email UNIQUE(email);
ALTER TABLE courses ADD CONSTRAINT  uk_course_name UNIQUE(course_name);
ALTER TABLE students ADD CONSTRAINT chk_age CHECK(age BETWEEN 15 AND 60);


 像不规范表插入数据
INSERT INTO students_bad VALUES
(1,'张三','zhangsan@school.com','数学、语文、英语'),
(2,'李四','lisi@school.com','数学、物理');

 向规范表插入数据
INSERT INTO students VALUES
(1,'张三','zhangsan@school.com',18),
(2,'李四','lisi@school.com',19),
(3,'王五','wangwu@school.com',20);

INSERT INTO courses VALUES
(1,'数学'),(2,'语文'),(3,'英语'),(4,'物理');

INSERT INTO student_courses VALUES
(1,1),(1,2),(1,3),-- 张三
(2,1),(2,4);-- 李四
*/

SELECT s1.student_name,s1.student_id
FROM students s1
where EXISTS(
SELECT 1
FROM student_courses sc
join courses c on c.courses_id=sc.courses_id
where sc.student_id=s1.student_id AND c.course_name='数学'
);

SELECT s2.student_name,s2.student_id
FROM students_bad s2
where s2.courses LIKE '%数学%';-- 容易被数学建模等带有数学的字段混淆

SELECT s1.student_id,student_name,COUNT(*)
FROM students s1
join student_courses sc on sc.student_id=s1.student_id
GROUP BY student_id,student_name;

SELECT student_name,student_id,
CHAR_LENGTH(courses)-CHAR_LENGTH(REPLACE(courses,'、',''))+1  AS courses_cnt
FROM students_bad s2;
/*
不规范设计：将多个课程名称冗余存储到courses字段中，节省了表数量，但付出了巨大代价
	更新异常：如果数学课程改名为高等数学，就需要更新所有相关学生的courses字段
	删除异常： 如果删除张三选课记录，无法单独删除他的数学课而保留其他课
而且需要频繁使用字符串操作（LIKE ,REPLACE等），查询复杂易出错*/
