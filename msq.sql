CREATE USER 'username'@'%' IDENTIFIED BY 'password';
SHOW DATABASES
CREATE DATABASE db1
USE db1
CREATE TABLE CLASS(
    CID INT  AUTO_INCREMENT PRIMARY KEY ,
    CLASSNAME CHAR(20)
);
SHOW TABLES;
INSERT INTO CLASS(CLASSNAME) VALUES('三年级一班'),('三年级二班'),('三年级三班')
select *from CLASS
CREATE TABLE student(
   sid INT  AUTO_INCREMENT PRIMARY KEY ,
   sname CHAR(20),
   sclass INT ,
   CONSTRAINT S_C FOREIGN KEY (sclass)REFERENCES CLASS(CID)
);
INSERT INTO student(sname,sclass ) VALUES('wkh',1),('zr',3),('lcp',2)
select *from student;
CREATE TABLE teacher(
    tid INT  AUTO_INCREMENT PRIMARY KEY ,
    tNAME CHAR(20)
);
INSERT INTO teacher(tNAME ) VALUES('lzx'),('zdx'),('lcl');
select *from teacher;
CREATE TABLE course(
    coid INT  AUTO_INCREMENT PRIMARY KEY ,
    coNAME CHAR(20),
    cotid INT ,
    CONSTRAINT co_t FOREIGN KEY (cotid)REFERENCES teacher(tid)

);
INSERT INTO course(coNAME,cotid ) VALUES('生物',1),('体育',1),('数学',2);
select *from course;
CREATE table score(
    scid INT AUTO_INCREMENT PRIMARY KEY ,
    scstuid INT ,
    sccoid INT ,
    numeber INT ,
    constraint sc_s FOREIGN KEY (scstuid)REFERENCES STUDENT(SID),
    constraint sc_co FOREIGN KEY (sccoid)REFERENCES course(COID)

);
-------------习题
SELECT * FROM score WHERE numeber>60;--查询60分以上
SELECT COUNT(coid),cotid FROM course GROUP BY cotid;--每个老师任课个数
SELECT * FROM score; 
LEFT JOIN teacher on course.cotid = teacher.tid;--每个课程的任课老师名称
SELECT sname FROM  (SELECT * FROM student
LEFT JOIN class on student.sclass = class.CID) as b;--学生班级

SELECT B.scstuid,B.FEN ,student.sname from  (SELECT scstuid,avg(numeber) AS FEN FROM score GROUP BY scstuid HAVING AVG(numeber)<60) as B
LEFT join student on student.sid = B.scstuid;-----找到成绩大于60分的学号和姓名

SELECT sname, sid,sclass,count(1),sum(score.numeber)FROM student
LEFT join score on score.scstuid = student.sid
 GROUP BY sid;---------选课个数

SELECT coid from course LEFT JOIN teacher ON course.cotid = teacher.tid WHERE teacher.tNAME like  'l%';-----li老师任课的课程
SELECT * FROM score  where score.sccoid not in (SELECT coid from course LEFT JOIN teacher ON course.cotid = teacher.tid WHERE teacher.tNAME like  'l%');-----li老师任课的课程
SELECT * FROM score;

INSERT INTO SCORE(scstuid,sccoid,numeber) VALUES(1,1,60),(1,2,59),(2,2,100);
select *from SCORE;
DROP TABLE student;
DROP TABLE CLASS;
SHOW CREATE TABLE SCORE;#看表的创建;

CREATE TABLE tb11(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(32),
    age INT 
);
INSERT INTO tb11(name,age)VALUES('root',12),('alex',55);
INSERT INTO tb11(name,age)VALUES('root2',12),('alex2',55);
select *from tb11;
CREATE TABLE tb12(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(32),
    age INT 
);
INSERT INTO tb12(name,age) select name,age from tb11;
select *from tb12;
CREATE TABLE tb13(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(32),
    age INT 
);
INSERT INTO tb13(name,age) select name,age from tb11 where age =12;
select *from tb13;

CREATE TABLE deparment(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(32)
);
CREATE TABLE user(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(32),
    parid int,
    constraint fk FOREIGN KEY(parid)REFERENCES deparment(id)
);
INSERT INTO deparment(title) VALUES('公关'),('前台'),('公共'),('会计');
INSERT INTO user(name,parid) VALUES('w',1),('z',2),('ww',1),('zz',4),('ww',4);
SELECT count(parid) as count,parid FROM user GROUP BY parid HAVING COUNT(id)>4;
SELECT * FROM user;


SELECT user.id,name, title FROM user,deparment WHERE user.parid = deparment.id;
SELECT * FROM  user LEFT JOIN deparment on user.parid = deparment.id;
SHOW TABLEs;
SELECT *from  score;


CREATE TABLE Employee(
    id INT AUTO_INCREMENT PRIMARY KEY,

    Salary int
);
INSERT  INTO Employee(Salary)VALUES(100),(100);
select*FROM employee;
TRUNCATE TABLE employee;
SELECT Salary from Employee ORDER BY  Salary desc LIMIT 1,1;

CREATE TABLE Scores(
    id INT AUTO_INCREMENT PRIMARY KEY,

    Score int
);
INSERT  INTO Scores(Score)VALUES(4),(2),(4),(3),(1);
select s1.Score,count(distinct s2.Score) as ran
from Scores as s1, Scores as s2 
where s1.Score<=s2.Score GROUP BY s1.id
order by s1.score desc;
select s1.score,count(distinct s2.score) as ran
from scores as s1,scores as s2
where s1.score<=s2.score
group by s1.id
order by s1.score desc;
---------------------特别难得一道题
----------------每个部门前三高工资
DROP TABLE  department1;
DROP  TABLE employee1;
CREATE TABLE employee1(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name char(10),
    Salary int,
    departmentId int
);
CREATE TABLE department1(
    id INT AUTO_INCREMENT PRIMARY KEY,
    dname char(10)
);
INSERT  INTO employee1(name,Salary,departmentId)VALUES('jone',85000,1),
('henry',80000,2),('sam',60000,2),
('max',9000,1),('jant',69000,1),('randy',85000,1),
('willy',70000,1);

INSERT  INTO department1(sname)VALUES('it'),
('sales');
SELECT * FROM employee1;

select *
from employee1 as a 
left join department1 on a.DepartmentId = department1.Id
where  (    
    select COUNT(distinct Salary)
    from employee1 
    where a.DepartmentId = DepartmentId
    and a.Salary<Salary
    )<3
    order by departmentid, salary desc;


select d.dname as department, e.name as employee, e.salary as salary
from employee1 e join department1 d on d.id = e.departmentid;
where ( select count(distinct salary) 
        from employee1
        where e.departmentid = departmentid and e.salary < salary
        )<3
order by departmentid, salary desc;



 SELECT scstuid,sname
 from score
 INNER JOIN student ON student.sid = score.scstuid
 where sccoid = 1 or sccoid = 2
 GROUP BY  sid
 HAVING COUNT(sid)>1;

SELECT *
 from score
 INNER JOIN student ON student.sid = score.scstuid;

SELECT score.scstuid,sname
from score
left JOIN student ON student.sid = score.scstuid
WHERE score.sccoid in (
    SELECT coid
    from course
    left JOIN teacher ON teacher.tid = course.cotid
    where tname = 'lzx'
)
GROUP BY score.scstuid
HAVING count(score.scstuid)=(    
    SELECT count(coid)
    from course
    left JOIN teacher ON teacher.tid = course.cotid
    where tname = 'lzx'
    );
 

CREATE TABLE A (
    ID INT AUTO_INCREMENT PRIMARY KEY ,
NAME CHAR(5)
);
INSERT INTO  a (NAME)values('c'),('b'),('d');
delete from a 
WHERE id not in (
    SELECT Id
    from a 
    where  Id in 
    (select min(Id)
    from a
    group by name )
);

delete from a 
Where Id not in (
    SELECT * FROM a 
    WHERE ID in 
    Select MIN(Id)
    From a 
    Group by name
)
;
delete from a 
WHERE id not in (
select min(Id)
    from a
    group by name ) as T
);
delete from A
WHERE id not in (
    select id 
    from(
        select min(id) as id
        from A
        group by NAME
    ) AS t
);
select datediff('2019-05-15','2019-04-16') as s,datediff('2019-4-15','2019-4-12') as q
;
select TIMESTAMPDIFF(year,'2014-07-01 09:00:00','2018-07-04 12:00:00');




CREATE TABLE tt (
    ID INT AUTO_INCREMENT PRIMARY KEY ,
NAME enum('client', 'driver', 'partner')
);
INSERT into tt(NAME)values('driver'),('driver'),('client');
select id 
from tt 
where NAME  =  'driver';


SELECT  T.request_at AS Day, 
	ROUND(
			SUM(
				IF(T.STATUS = 'completed',0,1)
			)
			/ 
			COUNT(T.STATUS),
			2
	) AS Cancellation Rate
FROM Trips AS T
JOIN Users AS U1 ON (T.client_id = U1.users_id AND U1.banned ='No')
JOIN Users AS U2 ON (T.driver_id = U2.users_id AND U2.banned ='No')
WHERE T.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY T.request_at;

SHOW TABLES;
SELECT * FROM class;
SELECT * FROM course;
SELECT * FROM teacher;
SELECT * FROM score;
SELECT * FROM student;
INSERT INTO teacher(tNAME)VALUES('w1'),('l2'),('cc');
INSERT INTO class(CLASSNAMe)VALUES('三年级四班');
INSERT INTO student(sname,sclass)values('q',2),('a',3),('as',2),('why',2),('wlc',4);
INSERT INTO course(coNAME,cotid)values('语文',3),("英语",4);


INSERT INTO score(scstuid,sccoid,numeber)values(3,3,60),(3,4,78),(3,2,90),(5,4,43),(5,5,90),
(6,2,45),(6,1,32),(8,5,32),(2,1,60),(2,2,90),(3,1,32),(5,1,60),(5,2,78)
;
--查询和001的同学学习课程完全相同的同学学号和姓名
SELECT scstuid
from score 
where scstuid in (
SELECT scstuid
FROM score 
WHERE sccoid in (select sccoid
FROM score
where scstuid = 1)
AND  scstuid!=1
GROUP BY scstuid)
GROUP BY scstuid 
HAVING COUNT(1)=(select count(sccoid)
FROM score
where scstuid = 1
)
