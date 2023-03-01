--18. Cho biết số lượng đề án của công ty

select count(MADA) as 'Số lượng mã đề án' from DEAN

--19. Liệt kê danh sách các phòng ban có tham gia chủ trì các đề án

select * from DEAN,PHONGBAN where DEAN.PHONG = PHONGBAN.MAPHG

--20. Cho biết số lượng các phòng ban có tham gia chủ trì các đề án

select count(*) as 'Số lượng các phòng ban tham gia chủ trì đề án' from DEAN,PHONGBAN where DEAN.PHONG = PHONGBAN.MAPHG

--21. Cho biết số lượng đề án do phòng Nghiên Cứu chủ trì

select count(*) as 'Số lượng đề án do phòng Nghiên Cứu chủ trì' 
from DEAN inner join PHONGBAN on DEAN.PHONG = PHONGBAN.MAPHG 
where PHONGBAN.TENPHG = N'Nghiên cứu'

--22. Cho biết lương trung bình của các nữ nhân viên

select AVG(LUONG) as 'Lương trung bình của các nhân viên nữ' from NHANVIEN where PHAI = N'Nữ'

--23. Cho biết số thân nhân của nhân viên Đinh Bá Tiến

select count(TENTN) as 'số thân nhân của nhân viên Đinh Bá Tiến' from THANNHAN inner join NHANVIEN
ON THANNHAN.MA_NVIEN = NHANVIEN.MANV 
WHERE NHANVIEN.HONV = N'Đinh' and NHANVIEN.TENLOT = N'Bá' and NHANVIEN.TENNV = N'Tiến'

--24. Liệt kê danh sách 3 nhân viên lớn tuổi nhất, danh sách bao gồm họ tên và năm sinh.

select TOP 3 HONV + ' ' + TENLOT + ' ' + TENNV + ' ' as 'Họ và tên',year(NGSINH) as 'Năm sinh' from NHANVIEN
ORDER BY year(NGSINH)

--25. Với mỗi đề án, liệt kê mã đề án và tổng số giờ làm việc của tất cả các nhân viên tham gia đề án đó.
SELECT DEAN.MADA, COUNT(DEAN.MADA) AS 'Số lượng công việc'
FROM DEAN, CONGVIEC
WHERE DEAN.MADA = CONGVIEC.MADA
GROUP BY DEAN.MADA, DEAN.TENDEAN

--26. Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc của tất cả các nhân viên tham gia đề án đó.
SELECT DEAN.TENDEAN, COUNT(DEAN.MADA) AS 'Số lượng công việc'
FROM DEAN, CONGVIEC
WHERE DEAN.MADA = CONGVIEC.MADA
GROUP BY DEAN.MADA, DEAN.TENDEAN

--27. Với mỗi đề án, cho biết có bao nhiêu nhân viên tham gia đề án đó, thông tin bao gồm tên đề án và số lượng nhân viên.
SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', COUNT(THANNHAN.MA_NVIEN) AS 'Số lượng thân nhân'
FROM NHANVIEN, THANNHAN
WHERE NHANVIEN.MANV = THANNHAN.MA_NVIEN
GROUP BY (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV)

--28. Với mỗi nhân viên, cho biết họ và tên nhân viên và số lượng thân nhân của nhân viên đó.
SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', COUNT(THANNHAN.MA_NVIEN) AS 'Số lượng thân nhân'
FROM NHANVIEN, THANNHAN
WHERE NHANVIEN.MANV = THANNHAN.MA_NVIEN
GROUP BY (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV)

--29. Với mỗi nhân viên, cho biết họ tên của nhân viên và số lượng đề án mà nhân viên đó đã tham gia.

SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', COUNT(PHANCONG.MA_NVIEN) AS'Số lượng đề án tham gia'
FROM NHANVIEN, DEAN, PHANCONG
WHERE NHANVIEN.MANV = PHANCONG.MA_NVIEN AND DEAN.MADA = PHANCONG.MADA
GROUP BY (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV)

--30. Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm việc cho phòng ban đó.

SELECT PHONGBAN.MAPHG, PHONGBAN.TENPHG, AVG(NHANVIEN.LUONG) AS 'Lương trung bình'
FROM NHANVIEN, PHONGBAN
WHERE NHANVIEN.PHG = PHONGBAN.MAPHG
GROUP BY PHONGBAN.MAPHG, PHONGBAN.TENPHG

--31.Với các phòng ban có mức lương trung bình trên 5.200.000, liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó.

SELECT PHONGBAN.TENPHG, COUNT(NHANVIEN.MANV) AS N'Số lượng nhân viên'
FROM NHANVIEN, PHONGBAN
WHERE NHANVIEN.PHG = PHONGBAN.MAPHG
GROUP BY PHONGBAN.TENPHG
HAVING AVG(NHANVIEN.LUONG)>5200000

--32. Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà phòng ban đó chủ trì.

SELECT PHONGBAN.TENPHG, COUNT(DEAN.PHONG) AS 'Số lượng đề án'
FROM PHONGBAN, DEAN
WHERE PHONGBAN.MAPHG = DEAN.PHONG
GROUP BY PHONGBAN.TENPHG

--33. Với mỗi phòng ban, cho biết tên phòng ban, họ tên người trưởng phòng và số lượng đề án mà phòng ban đó chủ trì.

SELECT PHONGBAN.TENPHG, (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên trưởng phòng', COUNT(DEAN.PHONG) AS 'Số lượng đề án'
FROM NHANVIEN, PHONGBAN, DEAN
WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND PHONGBAN.MAPHG = DEAN.PHONG
GROUP BY PHONGBAN.TENPHG, (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV)

--34. Với mỗi đề án, cho biết tên đề án và số lượng nhân viên tham gia đề án

SELECT DEAN.MADA, DEAN.TENDEAN, COUNT(DEAN.MADA) AS 'Số lượng công việc'
FROM DEAN, CONGVIEC
WHERE DEAN.MADA = CONGVIEC.MADA
GROUP BY DEAN.MADA, DEAN.TENDEAN