------------------------ LAB04 ----------------------------------
-- Bài tập 1: Sinh viên hoàn thành Phần III bài tập QuanLyBanHang từ câu 19 đến 30.
-- 19.Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*)
FROM HOADON H
WHERE NOT EXISTS (
	SELECT 1 
	FROM KHACHHANG K
	WHERE K.MAKH = H.MAKH
)
-- 20.	Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT SUM(CT.SL) AS SOLUONGSANPHAM
FROM CTHD CT INNER JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE YEAR(HD.NGHD) = 2006
-- 21.	Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT MIN(TRIGIA) AS TRIGIATHAPNHAT, MAX(TRIGIA) AS TRIGIACAONHAT 
FROM HOADON
-- 22.	Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AS TRUNGBINH
FROM HOADON 
WHERE YEAR(NGHD) = 2006
-- 23.	Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2006
-- 24.	Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD
FROM HOADON
WHERE YEAR(NGHD) = 2006 AND TRIGIA = (
	SELECT MAX(TRIGIA)
	FROM HOADON
	WHERE YEAR(NGHD) = 2006
)
-- 25.	Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT KH.HOTEN
FROM HOADON HD INNER JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
WHERE YEAR(NGHD) = 2006 AND TRIGIA = (
	SELECT MAX(TRIGIA)
	FROM HOADON
	WHERE YEAR(NGHD) = 2006
)
-- 26.	In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC
-- 27.	In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	ORDER BY GIA DESC
)
-- 28.	In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN (
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	ORDER BY GIA DESC
)
-- 29.	In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND	GIA IN (
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	WHERE NUOCSX = 'Trung Quoc' 
	ORDER BY GIA DESC
)
-- 30.	In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT TOP 3 MAKH, HOTEN, RANK() OVER (ORDER BY DOANHSO DESC) RANK_KH 
FROM KHACHHANG

-- Bài tập 2: Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 19 đến câu 25.
-- 19.	Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT MAKHOA, TENKHOA
FROM KHOA
WHERE NGTLAP = (
	SELECT MIN(NGTLAP)
	FROM KHOA
)
-- 20.	Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT(MAGV) AS SOLUONG
FROM GIAOVIEN
WHERE HOCHAM IN ('GS', 'PGS')
-- 21.	Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT MAKHOA, COUNT(MAGV) AS SOLUONG
FROM GIAOVIEN
WHERE HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS')
GROUP BY MAKHOA
-- 22.	Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MAMH, KQUA, COUNT(MAHV) AS SOLUONG
FROM KETQUATHI
GROUP BY MAMH, KQUA
ORDER BY MAMH, KQUA
-- 23.	Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT GV.MAGV, GV.HOTEN
FROM LOP L
INNER JOIN GIAOVIEN GV ON L.MAGVCN = GV.MAGV
INNER JOIN GIANGDAY GD ON GD.MALOP = L.MALOP AND GD.MAGV = GV.MAGV
GROUP BY GV.MAGV, GV.HOTEN
-- 24.	Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT HV.HO + ' ' + HV.TEN AS HOTEN
FROM LOP L INNER JOIN HOCVIEN HV ON HV.MAHV = L.TRGLOP
WHERE SISO = (
	SELECT MAX(SISO)
	FROM LOP
)
-- 25.	Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT HV.HO + ' ' + HV.TEN AS HOTEN
FROM LOP L INNER JOIN HOCVIEN HV ON HV.MAHV = L.TRGLOP
WHERE (
	SELECT COUNT(*)
	FROM KETQUATHI K
	WHERE K.MAHV = HV.MAHV
	GROUP BY K.MAMH
	HAVING COUNT (CASE WHEN K.KQUA = 'Dat' THEN 1 END) = 0
) <= 3


-- Bài tập 3: Sinh viên hoàn thành Phần III bài tập QuanLyBanHang từ câu 31 đến 45.
-- 31.	Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT SUM(CT.SL) AS TONGSOSANPHAM
FROM SANPHAM SP INNER JOIN CTHD CT ON SP.MASP = CT.MASP
WHERE SP.NUOCSX = 'Trung Quoc'
-- 32.	Tính tổng số sản phẩm của từng nước sản xuất.
SELECT SP.NUOCSX, SUM(CT.SL) AS TONGSOSANPHAM
FROM SANPHAM SP INNER JOIN CTHD CT ON SP.MASP = CT.MASP
GROUP BY SP.NUOCSX
-- 33.	Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) AS CAONHAT, MIN(GIA) AS THAPNHAT, AVG(GIA) AS TRUNGBINH
FROM SANPHAM
GROUP BY NUOCSX
-- 34.	Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
GROUP BY NGHD
-- 35.	Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT CT.MASP, SUM(CT.SL) AS TONGSOLUONG
FROM HOADON HD INNER JOIN CTHD CT ON HD.SOHD = CT.SOHD
WHERE MONTH(HD.NGHD) = 10 AND YEAR(HD.NGHD) = 2006
GROUP BY CT.MASP
-- 36.	Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHU
FROM HOADON 
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
-- 37.	Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT HD.SOHD, HD.NGHD, HD.MAKH
FROM HOADON HD INNER JOIN CTHD CT ON HD.SOHD = CT.SOHD
GROUP BY HD.SOHD, HD.NGHD, HD.MAKH
HAVING COUNT(DISTINCT CT.MASP) >= 4
-- 38.	Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT CT.SOHD
FROM SANPHAM SP INNER JOIN CTHD CT ON SP.MASP = CT.MASP
WHERE SP.NUOCSX = 'Viet Nam'
GROUP BY CT.SOHD
HAVING COUNT(DISTINCT CT.MASP) = 3
-- 39.	Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất. 
SELECT KH.MAKH, KH.HOTEN
FROM KHACHHANG KH INNER JOIN HOADON HD ON KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, KH.HOTEN
HAVING COUNT(*) = (
	SELECT MAX(SL)
	FROM (
		SELECT MAKH, COUNT(*) AS SL
		FROM HOADON 
		GROUP BY MAKH
	) AS T
)
-- 40.	Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP 1 THANG, DOANHTHU	
FROM (
	SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHU
	FROM HOADON
	WHERE YEAR(NGHD) = 2006
	GROUP BY MONTH(NGHD)
) AS T
ORDER BY DOANHTHU DESC
-- 41.	Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 SP.MASP, SP.TENSP
FROM (
	SELECT CT.MASP, SUM(SL) AS TONGSL
	FROM CTHD CT INNER JOIN HOADON HD ON CT.SOHD = HD.SOHD
	WHERE YEAR(HD.NGHD) = 2006
	GROUP BY MASP
) AS T INNER JOIN SANPHAM SP ON SP.MASP = T.MASP
ORDER BY T.TONGSL ASC 
-- 42.	*Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT SP.MASP, SP.TENSP, SP.NUOCSX, SP.GIA
FROM (
	SELECT NUOCSX, MAX(GIA) AS GIAMAX
	FROM SANPHAM 
	GROUP BY NUOCSX
) AS T 
INNER JOIN SANPHAM SP ON SP.NUOCSX = T.NUOCSX AND SP.GIA = T.GIAMAX
-- 43.	Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX
FROM SANPHAM
GROUP BY NUOCSX 
HAVING COUNT(DISTINCT GIA) >= 3
-- 44.	*Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
SELECT TOP 1 T.MAKH, T.HOTEN, T.SOLANMUAHANG
FROM (
	SELECT TOP 10 KH.MAKH, KH.HOTEN, COUNT(HD.SOHD) AS SOLANMUAHANG, SUM(HD.TRIGIA) AS DOANHSO
	FROM KHACHHANG KH INNER JOIN HOADON HD ON KH.MAKH = HD.MAKH
	GROUP BY KH.MAKH, KH.HOTEN
	ORDER BY SUM(HD.TRIGIA) DESC
) AS T
ORDER BY T.SOLANMUAHANG DESC


-- Bài tập 4: Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 26 đến câu 35.
-- 26.	Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
SELECT TOP 1 HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM (
	SELECT MAHV, COUNT(*) AS TONGSL
	FROM KETQUATHI 
	WHERE DIEM = 9 OR DIEM = 10
	GROUP BY MAHV
) AS T
INNER JOIN HOCVIEN HV ON HV.MAHV = T.MAHV
ORDER BY T.TONGSL DESC
/*
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM (
    SELECT MAHV, COUNT(*) AS TONGSL
    FROM KETQUATHI 
    WHERE DIEM = 9 OR DIEM = 10
    GROUP BY MAHV
) AS T
INNER JOIN HOCVIEN HV ON HV.MAHV = T.MAHV
WHERE T.TONGSL = (
    SELECT MAX(TONGSL)
    FROM (
        SELECT MAHV, COUNT(*) AS TONGSL
        FROM KETQUATHI 
        WHERE DIEM = 9 OR DIEM = 10
        GROUP BY MAHV
    ) AS X
)
*/
-- 27.	Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
SELECT LEFT(A.MAHV, 3) MALOP, A.MAHV, HO + ' ' + TEN HOTEN
FROM (
	SELECT MAHV, RANK() OVER (PARTITION BY LEFT(MAHV, 3) ORDER BY COUNT(MAMH) DESC) RANK_MH 
	FROM KETQUATHI KQ
	WHERE DIEM = 9 OR DIEM = 10
	GROUP BY KQ.MAHV
) A 
INNER JOIN HOCVIEN HV ON A.MAHV = HV.MAHV
WHERE RANK_MH = 1
GROUP BY LEFT(A.MAHV, 3), A.MAHV, HO, TEN
-- 28.	Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT HOCKY, NAM, MAGV, COUNT(MAMH) SOMH, COUNT(MALOP) SOLOP
FROM GIANGDAY
GROUP BY HOCKY, NAM, MAGV
-- 29.	Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT HOCKY, NAM, A.MAGV, GV.HOTEN
FROM (
	SELECT HOCKY, NAM, MAGV, RANK() OVER (PARTITION BY HOCKY, NAM ORDER BY COUNT(MAMH) DESC) RANK_MH
	FROM GIANGDAY
	GROUP BY HOCKY, NAM, MAGV
) A
INNER JOIN GIAOVIEN GV ON A.MAGV = GV.MAGV
WHERE RANK_MH = 1
-- 30.	Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
SELECT MH.MAMH, MH.TENMH
FROM (
	SELECT MAMH, RANK() OVER (ORDER BY COUNT(*) DESC) RANK_MH
	FROM KETQUATHI
	WHERE LANTHI = 1 AND KQUA = 'Khong Dat'
	GROUP BY MAMH
) A
INNER JOIN MONHOC MH ON A.MAMH = MH.MAMH
WHERE RANK_MH = 1
-- 31.	Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM (
	SELECT MAHV
	FROM KETQUATHI
	WHERE LANTHI = 1
	GROUP BY MAHV
	HAVING COUNT(CASE WHEN KQUA = 'Dat' THEN 1 END) = COUNT(MAMH)
) A
INNER JOIN HOCVIEN HV ON HV.MAHV = A.MAHV
-- 32. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN
FROM (
	SELECT MAHV
	FROM KETQUATHI A
	WHERE LANTHI = (
		SELECT MAX(LANTHI)
		FROM KETQUATHI B
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH
	)
	GROUP BY MAHV
	HAVING COUNT(CASE WHEN KQUA = 'Dat' THEN 1 END) = COUNT(MAMH)
) C
INNER JOIN HOCVIEN HV ON HV.MAHV = C.MAHV
-- 33. Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi thứ 1).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM (
	SELECT MAHV, COUNT(MAMH) AS SOLUONG
	FROM KETQUATHI
	WHERE LANTHI = 1 AND KQUA = 'Dat'
	GROUP BY MAHV
	HAVING COUNT(MAMH) = (
		SELECT COUNT(DISTINCT MAMH)
		FROM KETQUATHI
		WHERE LANTHI = 1
	)
) A 
INNER JOIN HOCVIEN HV ON HV.MAHV = A.MAHV
-- 34. Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi sau cùng).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM (
	SELECT MAHV, COUNT(MAMH) AS SOLUONG
	FROM KETQUATHI A
	WHERE LANTHI = (
		SELECT MAX(LANTHI)
		FROM KETQUATHI B
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH
	)
	AND KQUA = 'Dat'
	GROUP BY MAHV
	HAVING COUNT(MAMH) = (
		SELECT COUNT(DISTINCT MAMH)
		FROM KETQUATHI 
	)
) C
INNER JOIN HOCVIEN HV ON HV.MAHV = C.MAHV
-- 35. Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS HOTEN
FROM KETQUATHI A 
INNER JOIN HOCVIEN HV ON A.MAHV = HV.MAHV
WHERE
	A.LANTHI = (
		SELECT MAX(LANTHI)
		FROM KETQUATHI B
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH
	)
AND A.DIEM = (
		SELECT MAX(C.DIEM)
		FROM KETQUATHI C
		WHERE C.MAMH = A.MAMH
		AND C.LANTHI = (
			SELECT MAX(LANTHI)
			FROM KETQUATHI D
			WHERE D.MAHV = C.MAHV AND D.MAMH = C.MAMH
		)
	)	
