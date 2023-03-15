-- Câu 1. Viết SP spTangLuong dùng để tăng lương lên 10% cho tất cả các nhân viên.

CREATE PROC spTangLuong
	AS
	UPDATE NHANVIEN set LUONG = LUONG * 0.1
	go
	EXEC spTangLuong

-- Câu 2.Thêm vào cột NgayNghiHuu (ngày nghỉ hưu) trong bảng NHANVIEN. Viết SP spNghiHuu dùng để 
-- cập nhật ngày nghỉ hưu là ngày hiện tại cộng thêm 100 (ngày) cho những nhân viên nam có tuổi từ 60 trở lên và nữ từ 55 trở lên.
-- Tạo cột NgayNghiHuu
Alter table NHANVIEN
ADD NgayNghiHuu date 
go
CREATE PROC spNghiHuu
as
UPDATE NHANVIEN set NgayNghiHuu = (select GETDATE()+100)
go

-- Câu 3. Tạo SP spXemDeAn cho phép xem các đề án có địa điểm đề án được truyền vào khi gọi thủ tục.
Create proc spXemDeAn 
	@diadiem nvarchar(20)
as
select * from DEAN where DDIEM_DA = @diadiem
go

-- Câu 4.Tạo SP spCapNhatDeAn cho phép cập nhật lại địa điểm đề án với 2 tham số truyền vào là diadiem_cu, diadiem_moi.
Create proc spCapNhatDeAn 
	@diadiemcu nvarchar(50) ,
	@diadiemmoi nvarchar(50)
as
UPDATE DEAN
    SET DDIEM_DA = @DiaDiemMoi
    WHERE DDIEM_DA = @DiaDiemCu
go

--Câu 5. Viết SP spThemDeAn để thêm dữ liệu vào bảng DEAN với các tham số vào là các trường của bảng DEAN.

Create proc spThemDeAn
    @MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50)
AS
BEGIN
    INSERT INTO DEAN(MADA, TENDEAN, DDIEM_DA)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem)
END

--Câu 6. Cập nhật SP spThemDeAn ở câu trên để thỏa mãn ràng buộc sau: kiểm tra mã đề án có
--trùng với các mã đề án khác không. Nếu có thì thông báo lỗi “Mã đề án đã tồn tại, đề nghị chọn
--mã đề án khác”. Sau đó, tiếp tục kiểm tra mã phòng ban. Nếu mã phòng ban không tồn tại
--trong bảng PHONGBAN thì thông báo lỗi: “Mã phòng không tồn tại”. Thực thi thủ tục với 1
--trường hợp đúng và 2 trường hợp sai để kiểm chứng.
CREATE PROC spThemDeAn
	@MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50),
	@MaPhongBan nvarchar(20)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM DEAN WHERE MADA = @MaDeAn)
    BEGIN
        RAISERROR ('Mã đề án đã tồn tại, đề nghị chọn mã đề án khác',16,1)
        RETURN;
    END
    
    IF NOT EXISTS(SELECT 1 FROM PHONGBAN WHERE MAPHG = @MaPhongBan)
BEGIN
        RAISERROR ('Mã phòng không tồn tại',16,1)
        RETURN;
    END
    
    INSERT INTO DEAN(MADA, TenDeAn, DDIEM_DA)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem)
END


CREATE PROCEDURE spThemPhanCong
@MaNV INT,
@MaDA INT,
@ThoiGian INT
AS
BEGIN
IF @ThoiGian <= 0
BEGIN
PRINT 'Thời gian phải là một số dương.'
RETURN
END
IF NOT EXISTS (SELECT * FROM DEAN WHERE MaDeAn = @MaDA)
BEGIN
    PRINT 'Mã đề án không tồn tại trong bảng DEAN.'
    RETURN
END

IF NOT EXISTS (SELECT * FROM NHANVIEN WHERE MaNV = @MaNV)
BEGIN
    PRINT 'Mã nhân viên không tồn tại trong bảng NHANVIEN.'
    RETURN
END

INSERT INTO PHANCONG (MaNV, MaDeAn, ThoiGian)
VALUES (@MaNV, @MaDA, @ThoiGian)
END