CREATE DATABASE Sales
ON
PRIMARY
(
NAME = tuan1_data,
FILENAME ='T:\ThucHanhSQL\tuan1_data.mdf',
SIZE = 10MB,
MAXSIZE = 20MB,
FILEGROWTH = 20%
)
LOG ON
(
NAME = tuan1_log,
FILENAME ='T:\ThucHanhSQL\tuan1_log.mdf',
SIZE = 10MB,
MAXSIZE = 20MB,
FILEGROWTH = 20%
)
go
USE Sales
-- 1. Kiểu dữ liệu tự định nghĩa
EXEC sp_addtype 'Mota', 'NVARCHAR(40)'
EXEC sp_addtype 'IDKH', 'CHAR(10)', 'NOT NULL'
EXEC sp_addtype 'DT', 'CHAR(12)'
-- 2. Tạo table
go
CREATE TABLE SanPham (
MaSP CHAR(6) NOT NULL,
TenSP VARCHAR(20),
NgayNhap Date,
DVT CHAR(10),
SoLuongTon INT,
DonGiaNhap money,

)
CREATE TABLE HoaDon (
MaHD CHAR(10) NOT NULL,
NgayLap Date,
NgayGiao Date,
MaKH IDKH,
DienGiai Mota,
)
CREATE TABLE KhachHang (
MaKH IDKH,
TenKH NVARCHAR(30),
DiaCHi NVARCHAR(40),
DienThoai DT,
)
CREATE TABLE ChiTietHD (
MaHD CHAR(10) NOT NULL,
MaSP CHAR(6) NOT NULL,
SoLuong INT
)

-- 3. Trong Table HoaDon, sửa cột DienGiai thành nvarchar(100).
ALTER TABLE HoaDon
ALTER COLUMN DienGiai NVARCHAR(100)
-- 4. Thêm vào bảng SanPham cột TyLeHoaHong float
ALTER TABLE SanPham
ADD TyLeHoaHong float
-- 5. Xóa cột NgayNhap trong bảng SanPham
ALTER TABLE SanPham
DROP COLUMN NgayNhap
-- 6. Tạo các ràng buộc khóa chính và khóa ngoại cho các bảng trên
ALTER TABLE SanPham
ADD
CONSTRAINT pk_sp primary key(MASP)

ALTER TABLE HoaDon
ADD
CONSTRAINT pk_hd primary key(MaHD)

ALTER TABLE KhachHang
ADD
CONSTRAINT pk_khanghang primary key(MaKH)

ALTER TABLE HoaDon
ADD
CONSTRAINT fk_khachhang_hoadon FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT fk_hoadon_chitiethd FOREIGN KEY(MaHD) REFERENCES HoaDon(MaHD)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT fk_sanpham_chitiethd FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
-- 7. Thêm vào bảng HoaDon các ràng buộc
ALTER TABLE HoaDon
ADD CHECK (NgayGiao > NgayLap)

ALTER TABLE HoaDon
ADD CHECK (MaHD like '[A-Z][A-Z][0-9][0-9][0-9][0-9]')

ALTER TABLE HoaDon
ADD CONSTRAINT df_ngaylap DEFAULT GETDATE() FOR NgayLap
-- 8. Thêm vào bảng Sản phẩm các ràng buộc
ALTER TABLE SanPham
ADD CHECK (SoLuongTon > 0 and SoLuongTon < 50)

ALTER TABLE SanPham
ADD CHECK (DonGiaNhap > 0)

ALTER TABLE SanPham
ADD CONSTRAINT df_ngaynhap DEFAULT GETDATE() FOR NgayNhap

ALTER TABLE SanPham
ADD CHECK (DVT = N'KG' or DVT = N'Thùng' or DVT= N'Hộp' or DVT= N'Cái')
-- 9. Dùng lệnh T-SQL nhập dữ liệu vào 4 table trên, dữ liệu tùy ý, chú ý các ràng buộc của mỗi Table
INSERT INTO HoaDon VALUES ('HD0001','2022-11-22','2022-11-25','KH01','Hàng sẽ được giao vào buổi chiều')
INSERT INTO HoaDon VALUES ('HD0002','2022-11-21','2022-11-22','KH02','Hàng sẽ được giao')
INSERT INTO KhachHang VALUES ('KH01','Trần Văn Toàn','23 Phan Châu Trinh, TP HCM','0344892152')
INSERT INTO KhachHang VALUES ('KH02','Lê Văn Luyện','13 Cộng Hòa, TP HCM','0348952155')
INSERT INTO SanPham VALUES ('SP0001','Mì gói Hảo Hảo','2022-10-22',N'Thùng',20,114000)
INSERT INTO SanPham VALUES ('SP0002','Trà Chanh','2022-10-23',N'Hộp',14,32000)
INSERT INTO ChiTietHD VALUES ('HD0001','SP0001',1)
INSERT INTO ChiTietHD VALUES ('HD0001','SP0002',2)
INSERT INTO ChiTietHD VALUES ('HD0002','SP0002',4)
-- 10. Xóa 1 hóa đơn bất kỳ trong bảng HoaDon. Có xóa được không? Tại sao? Nếu vẫn muốn xóa thì phải dùng cách nào?
DELETE from HoaDon
where MaKH='KH02'
-- 11.Nhập 2 bản ghi mới vào bảng ChiTietHD với MaHD = ‘HD999999999’ và MaHD=’1234567890’. Có nhập được không? Tại sao?
INSERT INTO ChiTietHD VALUES ('HD999999999','SP0001',1)
INSERT INTO ChiTietHD VALUES ('1234567890','SP0001',1)
-- Không được vì ràng buộc chỉ có 6 kí tự và kí tự đầu phải là 2 chữ cái và 4 kí tự sau là số

-- 12.Đổi tên CSDL Sales thành BanHang
ALTER DATABASE Sales MODIFY NAME = BanHang;

-- 14. Tạo bản BackUp cho CSDL BanHang
Backup database Sales to disk = 'C:\Backup'
