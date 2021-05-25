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
