-- creating database test
CREATE DATABASE test;

-- selecting test databse
USE test;


-- creating student table
CREATE TABLE student (
StdID INT PRIMARY KEY,
StdName VARCHAR(30) NOT NULL,
Sex VARCHAR(6) CHECK (Sex = 'Female' || Sex = 'Male'), 
Percentage INT,
SClass INT,
Sec VARCHAR(255),
Stream Varchar(10) CHECK (Stream = 'Science' || Stream = 'Commerce'),
DOB DATE
);


-- Inserting values into student table
INSERT INTO student (StdID, StdName, Sex, Percentage, SClass, Sec, Stream, DOB)
VALUES (11030, 'RIYA','Female','50',12,'A','Science','2001-03-31'),
(11031, 'ISHITA','Female','90',12,'B','Science','2002-05-24'),
(11032, 'CHETNA','Female','80',12,'A','Commerce','1997-06-24'),
(11033, 'AYUSH','Male','92',12,'B','Commerce','2000-08-15');


-- adding new column in student table as "teacher_id" using ALTER command
ALTER TABLE student
Add teacher_id INT;


-- creating teacher table
CREATE TABLE teacher(
teacher_id INT PRIMARY KEY,
Name VARCHAR(30),
email VARCHAR(30),
subject VARCHAR(20),
Class INT
);


-- inserting values into teacher table
INSERT INTO teacher(teacher_id, Name, email, subject, Class)
VALUES(110,'Aman','aman123@gmail.com','Bio',12),
(111,'Tej', 'Tejendra801@gmail.com','Maths',12),
(112, 'Param', 'param456@gmail.com','Accounts',12),
(113,'Chaitanya', 'chaitanya234@gmail.com', 'English',12);


-- Altering student table and making teacher_id as foreign key in student table
ALTER TABLE student
ADD FOREIGN KEY (teacher_id) REFERENCES teacher (teacher_id);


-- updating student table and assigning teacher to student 
-- student 1)
UPDATE student
SET teacher_id = (
SELECT teacher_id FROM teacher WHERE Name = 'Tej'
)
WHERE StdName = 'RIYA';

-- student 2)
UPDATE student
SET teacher_id = (
SELECT teacher_id FROM teacher WHERE Name = 'Aman'
)
WHERE StdName = 'ISHITA';

-- student 3)
UPDATE student
SET teacher_id = (
SELECT teacher_id FROM teacher WHERE Name = 'Param'
)
WHERE StdName = 'CHETNA';

-- student 4)
UPDATE student
SET teacher_id = (
SELECT teacher_id FROM teacher WHERE Name = 'Chaitanya'
)
WHERE StdName = 'AYUSH';


-- Read from student and teacher table and get all the data from both tables after applying the inner join
SELECT * FROM student s
JOIN teacher t
ON s.teacher_id = t.teacher_id;


-- inserting more row into student table for testing diffrent queries 
INSERT INTO student (StdID, StdName, Sex, Percentage, SClass, Sec, Stream, DOB)
VALUES (11034, 'AYUSH','Male','55',12,'A','Science','2002-07-20');


-- reading disting students from student table
SELECT DISTINCT StdName FROM student;


-- finding number of students that are male
SELECT Sex, count(*) FROM student
WHERE Sex = 'Male'
GROUP BY Sex;


-- finding number of students having sex as male and stream as science 
SELECT Sex, count(*) AS 'Number of Student' FROM student
WHERE Sex = 'Male' AND Stream = 'Science'
GROUP BY Sex;


-- inserting more values to student table for testing diffrent queries 
INSERT INTO student (StdID, StdName, Sex, Percentage, SClass, Sec, Stream, DOB)
VALUES (11035, 'RAJAT','Male','40',12,'A','Science','2020-02-28'),
(11036, 'VANSHIKA','Female','89',12,'B','Science','2021-04-06');


-- reading students having their birth year as 2020.
SELECT * FROM student
WHERE DOB BETWEEN '2020-01-01' AND '2020-12-31';


-- creating features table (features available at the school like swimming,yoga and so on)
CREATE TABLE features(
feature_id INT AUTO_INCREMENT PRIMARY KEY,
feature_type VARCHAR(30) NOT NULL
);


-- inserting into features table
INSERT INTO features (feature_type)
VALUES ('swimming'),
('cricket'),
('yoga'),
('TT'),
('football');



-- creating table Student_feature esatablishing many to many relation between student and features
CREATE TABLE Student_feature(
StdID INT,
feature_id INT,
FOREIGN KEY (StdID) REFERENCES student (StdID),
FOREIGN KEY (feature_id) REFERENCES features (feature_id),
PRIMARY KEY (StdID, feature_id)
);


-- inserting values in Student_feature table
INSERT INTO Student_feature(StdID, feature_id)
VALUES (11030,3),
(11030,4),
(11031,1),
(11031,4),
(11031,5),
(11032,5),
(11033,2),
(11032,3);



-- finding all the students having swimming as a choice
SELECT s.StdName, f.feature_type 
from student s
JOIN Student_feature sf
ON s.StdID = sf.StdID
JOIN features f
ON f.feature_id = sf.feature_id
WHERE f.feature_type = 'swimming';


-- Finding teachers whose students are into cricket
SELECT t.Name AS 'teacher name', s.StdName AS 'student name', f.feature_type AS 'feature'
FROM teacher t
JOIN student s 
ON s.teacher_id = t.teacher_id
JOIN Student_feature sf
ON sf.StdID = s.StdID
JOIN features f
ON f.feature_id = sf.feature_id
WHERE f.feature_type = 'cricket';


-- creating view
CREATE VIEW Student_view AS
SELECT 
s.StdName AS students,
s.Sex,
s.Percentage,
s.SClass AS class,
s.Sec AS section,
t.Name AS 'teacher name',
f.feature_type AS activity,
s.Stream
FROM student s
JOIN teacher t
ON s.teacher_id = t.teacher_id
JOIN Student_feature sf
ON s.StdID = sf.StdID
JOIN features f
ON sf.feature_id = f.feature_id;



-- inserting more values into teacher table for testing queries
INSERT INTO teacher(teacher_id, Name, email, subject, Class)
VALUES(114,'Suraj','Suraj123@gmail.com','chemistry',12),
(115,'Sartaj', 'sartaj01@gmail.com','physics',12);


-- inserting more values into student table for testing queries
INSERT INTO student (StdID, StdName, Sex, Percentage, SClass, Sec, Stream, DOB)
VALUES (11037, 'PARAMJEET','Male','75',12,'A','Science','2000-04-29');


-- assigning teacher to new student which are added recently
UPDATE student
SET teacher_id = (
SELECT teacher_id FROM teacher WHERE Name = 'Suraj'
)
WHERE StdName = 'PARAMJEET';

UPDATE student
SET teacher_id = (
SELECT teacher_id FROM teacher WHERE Name = 'Sartaj'
)
WHERE StdName = 'RAJAT';

UPDATE student
SET teacher_id = (
SELECT teacher_id FROM teacher WHERE Name = 'Chaitanya'
)
WHERE StdName = 'VANSHIKA';

UPDATE student
SET teacher_id = (
SELECT teacher_id FROM teacher WHERE Name = 'Suraj'
)
WHERE StdName = 'AYUSH' AND StdID = 11034;



-- creating Stored procedure
DELIMITER //
CREATE PROCEDURE new_procedure()
BEGIN
  CREATE TEMPORARY TABLE temp (
    std_id INT,
    std_name VARCHAR(30),
    dob DATE,
    teacher_id INT,
    teacher_name VARCHAR(30)
  ); 

INSERT INTO temp (std_id, std_name, dob, teacher_id,teacher_name)
  SELECT s.StdID, s.StdName, s.DOB, t.teacher_id, t.name AS 'teacher name'
  FROM student s
  JOIN teacher t on s.teacher_id=t.teacher_id
  WHERE YEAR(s.DOB) = 2000 AND t.name LIKE 's%';
        
SELECT * FROM temp; 
DROP TABLE IF EXISTS temp;
END //
DELIMITER ;
CALL new_procedure();



-- creating backup table for storing deleted student data
CREATE TABLE backup_student (
StdID INT PRIMARY KEY,
StdName VARCHAR(30) NOT NULL,
Sex VARCHAR(6) CHECK (Sex = 'Female' || Sex = 'Male'), 
Percentage INT,
SClass INT,
Sec VARCHAR(255),
Stream Varchar(10) CHECK (Stream = 'Science' || Stream = 'Commerce'),
DOB DATE,
teacher_id INT,
FOREIGN KEY (teacher_id) REFERENCES teacher (teacher_id)
);


-- creating a trigger for storing deleted student data into backup table
CREATE TRIGGER backup_std
AFTER DELETE ON student
FOR EACH ROW
INSERT INTO backup_student (StdID, StdName, Sex, Percentage, SClass, Sec, Stream, DOB, teacher_id)
VALUES (OLD.StdID, OLD.StdName, OLD.Sex, OLD.Percentage, OLD.SClass, OLD.Sec, OLD.Stream, OLD.DOB, OLD.teacher_id);

-- deleting student
DELETE FROM student
WHERE StdID = 11036;

-- reading deleted student data
SELECT * FROM backup_student;


-- finding a student having 3rd height percentage.
SELECT StdID, StdName, Percentage
FROM student
ORDER BY Percentage DESC
LIMIT 3;



-- an example of a UNION query that combines the data from two separate tables, 
-- "students" and "backup_students," which have the same structure. 
-- The UNION query will retrieve the student information from both tables:
SELECT * FROM student
UNION
SELECT * FROM backup_student;



















