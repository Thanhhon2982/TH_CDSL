CREATE DATABASE MarkManagement
go
use MarkManagement
go
Create table Students
(
	StudentID Nvarchar(12) primary key,
	StudentName Nvarchar(25) not null,
	DateofBirth Datetime not null,
	Email Nvarchar(40),
	Phone Nvarchar(12),
	Class Nvarchar(10)
)

Create table Subjects
(
	SubjectID Nvarchar(10) primary key,
	SubjectName Nvarchar(25) not null
)

Create table Mark
(
	StudentID Nvarchar(12) not null,
	SubjectID Nvarchar(10) not null,
	Date Datetime,
	Theory Tinyint,
	Practical Tinyint,
	
)

ALTER TABLE Mark
ADD
CONSTRAINT pk_mark PRIMARY KEY (StudentID,SubjectID)

ALTER TABLE Mark
ADD
CONSTRAINT fk_students_mark FOREIGN KEY (StudentID) REFERENCES Students(StudentID)

ALTER TABLE Mark
ADD
CONSTRAINT fk_Subjects_mark FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
go
INSERT INTO Students VALUES ('AV0807005','Mail Trung Hiếu','11/10/1989','trunghieu@yahoo.com','0904115116','AV1'),
('AV0807006','Nguyễn Quý Hùng','2/12/1988','quyhung@yahoo.com','0955667787','AV2'),
('AV0807007','Đỗ Đắc Huỳnh','2/1/1990','dachuynh@yahoo.com','0988574747','AV2'),
('AV0807009','An Đăng Khuê','6/3/1986','dangkhue@yahoo.com','0986757463','AV1'),
('AV0807010','Nguyễn T. Tuyết Lan','12/7/1989','tuyetlan@gmail.com','0983310342','AV2'),
('AV0807011','Đinh Phụng Long','2/12/1990','phunglong@yahoo.com',NULL,'AV1'),
('AV0807012', 'Nguyễn Tuấn Nam', '2/3/1990', 'tuannam@yahoo.com', NULL, 'AV1')

INSERT INTO Subjects 
VALUES ('S001', 'SQL'),
('S002', 'Java Simplefield'),
('S003', 'Active Server Page');
go
INSERT INTO Mark 
VALUES ('AV0807005', 'S001', '6/5/2008', 8, 25),
('AV0807006', 'S002', '6/5/2008', 16, 30),
('AV0807007', 'S001', '6/5/2008', 10, 25),
('AV0807009', 'S003', '6/5/2008', 7, 13),
('AV0807010', 'S003', '6/5/2008', 9, 16),
('AV0807011', 'S002', '6/5/2008', 8, 30),
('AV0807012', 'S001', '6/5/2008', 7, 31),
('AV0807005', 'S002', '6/6/2008', 12, 11),
('AV0807010', 'S001', '6/6/2008', 7, 6);

-- 1. Hiển thị nội dung bảng Students
SELECT * FROM Students
-- 2. Hiển thị nội dung danh sách sinh viên lớp AV1
SELECT * FROM Students where Class = 'AV1'
-- 3.Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2
UPDATE Students set Class = 'AV2' where StudentID = 'AV0807012'
-- 4. Tính tổng số sinh viên của từng lớp
create proc tinhtongsv @malop nvarchar(10)
as
begin
select count(StudentID) as 'Số lượng sinh viên',Class as 'mã lớp'
from Students where Class = @malop
group by Class
end
go
exec tinhtongsv 'AV1'
exec tinhtongsv 'AV2'
-- 5. Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
Select * From Students Where Class='AV2' Order by StudentName
-- 6. Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008
select * from Students inner join Mark ON Students.StudentID = Mark.StudentID
Where SubjectID = 'S001' and theory < 10 and Date = '6/5/2008'
-- 7. Hiển thị tổng số sinh viên không đạt lý thuyết môn S001. (theory <10)
select count(Class) As 'Tổng số sinh viên' From Students inner join Mark ON Students.StudentID = Mark.StudentID
Where SubjectID = 'S001' and theory < 10
-- 8.Hiển thị Danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980
select * from Students Where Class = 'AV1' and DateofBirth > '1/1/1980'
-- 9. Xoá sinh viên có mã AV0807011
DELETE FROM Students Where StudentID = 'AV0807011'
-- 10. Hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008 bao gồm các trường sau: StudentID, StudentName, SubjectName, Theory, Practical, Date
select Students.StudentID,Mark.SubjectID,Theory,Practical,Date from Students inner join Mark ON Students.StudentID = Mark.StudentID where SubjectID = 'S001' and Date = '6/5/2008 '
