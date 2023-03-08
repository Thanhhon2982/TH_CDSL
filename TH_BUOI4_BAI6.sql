---- Cau 1.Cho biết danh sách các nhân viên có ít nhất một thân nhân

SELECT nv.MANV,nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV AS 'Họ và tên',nv.DCHI,nv.NGSINH
FROM NHANVIEN as nv, THANNHAN as tn
WHERE nv.MANV = tn.MA_NVIEN
GROUP BY nv.MANV,nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV,nv.DCHI,nv.NGSINH
HAVING COUNT(*) >= 1
--- Cau 2.Cho biết danh sách các nhân viên không có thân nhân nào

SELECT nv.MANV,nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV as 'Họ và tên',nv.NGSINH,nv.DCHI,nv.PHAI FROM NHANVIEN as nv
WHERE nv.MANV NOT IN (SELECT tn.MA_NVIEN FROM THANNHAN as tn)

--- Cau 3.Cho biết họ tên các nhân viên có trên 2 thân nhân.

SELECT nv.MANV,nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV as 'Họ tên các nhân viên có trên 2 thân nhân'
FROM NHANVIEN as nv, THANNHAN as tn
WHERE nv.MANV = tn.MA_NVIEN
GROUP BY nv.MANV,nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV
HAVING COUNT(*) > 2

--- Cau 4.Cho biết họ tên những trưởng phòng có ít nhất một thân nhân.

SELECT nv.MANV,nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV as 'Họ tên các nhân viên có trên 2 thân nhân'
FROM NHANVIEN as nv, THANNHAN as tn,PHONGBAN as pb
WHERE nv.MANV = tn.MA_NVIEN and pb.TRPHG = nv.MANV
GROUP BY nv.MANV,nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV
HAVING COUNT(*) >= 1

--- Cau 6.Cho biết họ tên các nhân viên phòng Quản lý có mức lương trên mức lương trung bình của phòng Quản lý.

select nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV as 'Họ tên các nhân viên phòng Quản lý có mức lương trên mức lương trung bình của phòng Quản lý.' 
from NHANVIEN as nv,PHONGBAN as pb 
where nv.PHG = pb.MAPHG and pb.TENPHG = N'Quản Lý' 
and luong > (select avg(luong) from NHANVIEN as nv,PHONGBAN as pb  where nv.PHG = pb.MAPHG and pb.TENPHG = N'Quản Lý' )

--- Cau 7.Cho biết họ tên nhân viên có mức lương trên mức lương trung bình của phòng mà nhân viên đó đang làm việc

select nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV as 'Họ tên nhân viên có mức lương trên mức lương trung bình của phòng mà nhân viên đó đang làm việc' 
from NHANVIEN as nv,PHONGBAN as pb 
where nv.PHG = pb.MAPHG
and luong > (select avg(luong) from NHANVIEN as nv,PHONGBAN as pb  where nv.PHG = pb.MAPHG)

--- Cau 8.Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất.

select pb.TENPHG, (nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV) as 'Họ tên trưởng phòng của phòng ban đông nhân viên nhất'
from NHANVIEN as nv, PHONGBAN as pb
where nv.MANV = pb.TRPHG AND pb.MAPHG = 
(select TOP 1 pb.MAPHG FROM NHANVIEN as nv, PHONGBAN as pb
where nv.PHG = pb.MAPHG
group by pb.MAPHG
order by count (nv.PHG) DESC)

--- Cau 9.Cho biết danh sách các đề án mà nhân viên có mã là 456 chưa tham gia.

select DEAN.TENDEAN
from DEAN
where DEAN.MADA not in (select PHANCONG.MADA from PHANCONG where PHANCONG.MA_NVIEN = '456')

--- Cau 10.Danh sách nhân viên gồm mã nhân viên, họ tên và địa chỉ của những nhân viên không sống tại TP Quảng Ngãi nhưng làm việc cho một đề án ở TP Quảng Ngãi.
select DISTINCT nv.MANV,nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV as 'Họ tên nhân viên', nv.DCHI
from NHANVIEN as nv, DEAN , DIADIEM_PHG
where nv.PHG = DEAN.PHONG AND nv.PHG = DIADIEM_PHG.MAPHG 
AND DEAN.DDIEM_DA LIKE '%Quãng Ngãi' AND DIADIEM_PHG.DIADIEM NOT LIKE '%Quãng Ngãi'

--- Cau 11.Tìm họ tên và địa chỉ của các nhân viên làm việc cho một đề án ở một địa điểm nhưng lại không sống tại địa điểm đó.

select DISTINCT nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV as 'Họ tên nhân viên', nv.DCHI
from NHANVIEN as nv, DEAN, DIADIEM_PHG
where nv.PHG = DEAN.PHONG AND nv.PHG = DIADIEM_PHG.MAPHG 
AND DEAN.DDIEM_DA IN (select DEAN.DDIEM_DA FROM DEAN) AND DIADIEM_PHG.DIADIEM NOT LIKE DEAN.DDIEM_DA

--- Cau 12.Cho biết danh sách các mã đề án có: nhân công với họ là Lê hoặc có người trưởng phòng chủ trì đề án với họ là Lê.

select pc.MADA FROM NHANVIEN as nv, PHANCONG as pc
where nv.MANV = pc.MA_NVIEN AND nv.HONV = N'Lê'
UNION 
select DEAN.MADA
from NHANVIEN, PHONGBAN, DEAN
where NHANVIEN.MANV = PHONGBAN.TRPHG AND PHONGBAN.MAPHG = DEAN.PHONG AND NHANVIEN.HONV = N'Lê'

--- Cau 13.Liệt kê danh sách các đề án mà cả hai nhân viên có mã số 123 và 789 cùng làm.

select DEAN.MADA
from DEAN
where DEAN.MADA IN (select PHANCONG.MADA from PHANCONG where PHANCONG.MA_NVIEN = '123' AND PHANCONG.MA_NVIEN = '789')
---Cau 14. Liệt kê danh sách các đề án mà cả hai nhân viên Đinh Bá Tiến và Trần Thanh Tâm cùng làm

SELECT DEAN.TENDEAN
FROM NHANVIEN, DEAN, PHANCONG
WHERE DEAN.MADA	= PHANCONG.MADA AND NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Đinh' AND NHANVIEN.TENLOT = N'Bá' AND NHANVIEN.TENNV = N'Tiến' 
UNION
SELECT DEAN.TENDEAN
FROM NHANVIEN, DEAN, PHANCONG
WHERE DEAN.MADA	= PHANCONG.MADA AND NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Trần' AND NHANVIEN.TENLOT = N'Thanh' AND NHANVIEN.TENNV = N'Tâm'

--- Cau 15. Danh sách những nhân viên (bao gồm mã nhân viên, họ tên, phái) làm việc trong mọi đề án của công ty
SELECT MANV, PHAI, (HONV+ '' +TENLOT+ '' +TENNV) AS 'HỌ TÊN'
FROM NHANVIEN 
SELECT DEAN.TENDEAN
FROM NHANVIEN, DEAN, PHANCONG
WHERE DEAN.MADA	= PHANCONG.MADA AND NHANVIEN.MANV = PHANCONG.MA_NVIEN