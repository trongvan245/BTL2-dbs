CREATE OR REPLACE FUNCTION calculate_giacathuoc(masobkb UUID)
RETURNS NUMERIC AS $$
BEGIN
  RETURN (
    SELECT SUM(s.soluong * t.giaca)
    FROM SO_LUONG_THUOC S
    JOIN THUOC T ON S.MASO_TH = T.MASO
    WHERE S.MASO_BKB = masobkb
  );
END;
$$ LANGUAGE plpgsql;

SELECT calculate_giacathuoc('1446b778-b4a0-47a8-a7fa-a5caa1f37bf3');


---
CREATE OR REPLACE FUNCTION calculate_giacadichvu(masobkb UUID)
RETURNS NUMERIC AS $$
BEGIN
  RETURN (
    SELECT SUM(D.giaca)
    FROM LAN_THUC_HIEN_DICH_VU L
    JOIN DICH_VU_KHAM D ON L.MADICHVU = D.MADICHVU
    WHERE L.MASO_BKB = masobkb
  );
END;
$$ LANGUAGE plpgsql;

SELECT calculate_giacadichvu('1446b778-b4a0-47a8-a7fa-a5caa1f37bf3');