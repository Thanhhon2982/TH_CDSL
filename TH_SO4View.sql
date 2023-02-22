Create database QLKHO
go
use QLKHO
go
Create table Nhap
(
	SoHDN int primary key,
	MaVT nvarchar(10) not null,
	SoLuongN int not null,
	DonGiaN money not null,
	NgayN datetime not null
)
Create table Xuat
(
	SoHDX int primary key,
	MaVT nvarchar(10) not null,
	SoLuongX int not null,
	DonGiaX money not null,
	NgayX datetime not null

)
Create table Ton
(
	MaVT nvarchar(10) primary key,
	TenVT nvarchar(50) not null,
	SoLuongT int not null,
)
go
alter table Nhap
add
CONSTRAINT fk_ton_nhap Foreign key (MaVT) REFERENCES Ton(MaVT)

alter table Xuat
add
CONSTRAINT fk_ton_xuat Foreign key (MaVT) REFERENCES Ton(MaVT)
go
Insert into Ton Values ('VT01','Bánh Choco pie',110),('VT02','Kẹo mạch nha',50),('VT03','Bánh mì ngọt',200),('VT04','Nước ngọt có gas',200),('VT05','Kẹo dừa',200)
Insert into Nhap Values (101,'VT01',210,50000,'1/6/2022'),(102,'VT02',100,20000,'1/6/2022'),(103,'VT03',80,35000,'2/6/2022')
Insert into Xuat Values (10001,'VT02',50,23000,'5/6/2022'),(10002,'VT01',100,56000,'7/6/2022')
-- câu 2 thống kê tiền bán theo mã vật tư gồm MaVT, TênVT, TienBan (TienBan=SoLuongX*DonGiaX)
CREATE VIEW CAU2
AS
select ton.MaVT,TenVT,sum(SoLuongX*DonGiaX) as tienban
from Xuat inner join ton on Xuat.MaVT=ton.MaVT
group by ton.mavt,tenvt
go
SELECT * FROM CAU2
-- câu 3 thống kê soluongxuat theo tên vattu
go
CREATE VIEW CAU3
AS
select ton.tenvt, sum(soluongx) as SoLuongT
from xuat inner join ton on xuat.mavt=ton.mavt
group by ton.tenvt
go
SELECT * FROM CAU3
go 
-- câu 4 thống kê soluongnhap theo tên vật tư
CREATE VIEW CAU4
AS
SELECT ton.TenVT, SUM(SoLuongN) AS SoLuongNhap
FROM Nhap inner join ton on Nhap.MaVT=ton.MaVT
group by ton.TenVT
go
SELECT * FROM CAU4
go
-- câu 5 đưa ra tổng soluong còn trong kho biết còn = nhap – xuất + tồn theo từng nhóm vật tư
CREATE VIEW CAU5
AS
select ton.mavt,ton.tenvt,sum(soluongN)-sum(soluongX) +
sum(soluongT) as tongton
from nhap inner join ton on nhap.mavt=ton.mavt
 inner join xuat on ton.mavt=xuat.mavt
group by ton.mavt,ton.tenvt
go 
SELECT * FROM CAU5
go
-- câu 6 đưa ra tên vật tư số lượng tồn nhiều nhất
CREATE VIEW CAU6
AS
select tenvt
from ton
where soluongT = (select max(soluongT) from Ton)
go
SELECT * FROM CAU6
go
-- câu 7 đưa ra các vật tư có tổng số lượng xuất lớn hơn 100
CREATE VIEW CAU7
AS
select ton.mavt,ton.tenvt
from ton inner join xuat on ton.mavt=xuat.mavt
group by ton.mavt,ton.tenvt
having sum(soluongX) >= 100
go
SELECT * FROM CAU7
go
--câu 8 Tạo view đưa ra tháng xuất, năm xuất, tổng số lượng xuất thống kê theo tháng và năm xuất
CREATE VIEW CAU8 AS
SELECT MONTH(NgayX) AS "Tháng xuất", YEAR(NgayX) AS "Năm xuất", SUM(SoLuongX) AS Total_Quantity
FROM Xuat
GROUP BY MONTH(NgayX), YEAR(NgayX);
go
SELECT * FROM CAU8

--câu 9: tạo view đưa ra mã vật tư. tên vật tư. số lượng nhập. số lượng xuất. đơn giá N. đơn giá X. ngày nhập. Ngày xuất
go
CREATE VIEW CAU9 AS
SELECT t.MaVT, t.TenVT,n.SoLuongN,x.SoLuongX, n.DonGiaN,x.DonGiaX, n.NgayN, x.NgayX
FROM Ton t
INNER JOIN Nhap n ON t.MaVT = n.MaVT
INNER JOIN Xuat x ON t.MaVT = x.MaVT;
go
SELECT * FROM CAU9
go 
--câu 10: Tạo view đưa ra mã vật tư. tên vật tư và tổng số lượng còn lại trong kho. biết còn lại = SoluongN-SoLuongX+SoLuongT theo từng loại Vật tư trong năm 2015

CREATE VIEW CAU10 AS
SELECT t.MaVT, t.TenVT, SUM(n.SoLuongN-x.SoLuongX+t.SoLuongT) as "SL còn lại"
FROM Ton t
INNER JOIN Nhap n ON t.MaVT = n.MaVT
INNER JOIN Xuat x ON t.MaVT = x.MaVT
where YEAR(n.NgayN) = 2015 OR YEAR(x.NgayX) = 2015
GROUP BY t.MaVT,t.TenVT;
go
SELECT * FROM CAU10