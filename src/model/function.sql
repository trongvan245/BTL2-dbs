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


CREATE OR REPLACE FUNCTION calculate_pending_tongtien(cccd_input VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(tongtien), 0)
        FROM hoa_don
        WHERE cccd_ph = cccd_input
          AND status = 'PENDING'--Deprecated, no status row
    );
END;
$$ LANGUAGE plpgsql;

SELECT calculate_pending_tongtien('111222333444');


CREATE OR REPLACE FUNCTION calculate_done_tongtien(cccd_input VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(tongtien), 0)
        FROM hoa_don
        WHERE cccd_ph = cccd_input
          AND status = 'DONE' --Deprecated, no status row
    );
END;
$$ LANGUAGE plpgsql;

SELECT calculate_done_tongtien('111222333444');




CREATE OR REPLACE FUNCTION tinh_tonghoadon_trong_thoigian( ffrom DATE, tto DATE)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(tongtien), 0)
        FROM hoa_don
        WHERE hoa_don.ngaytao BETWEEN ffrom AND tto
    );
END;
$$ LANGUAGE plpgsql;

SELECT tinh_tonghoadon_trong_thoigian('2024-11-23', '2024-11-23');




CREATE OR REPLACE FUNCTION get_pills_for_child(child_id_input UUID)
RETURNS TABLE(
    ms UUID, 
    ten VARCHAR(100), 
    dang VARCHAR(50), 
    giaca BIGINT,
    soluong INT
) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM BENH_NHI WHERE maso = child_id_input) THEN
        RAISE EXCEPTION 'Không tìm thấy bệnh nhi với mã số %', child_id_input;
    END IF;
    RETURN QUERY
    SELECT
        t.maso AS ms,
        t.ten,
        t.dang,
        t.giaca,
        slg.soluong as soluong
    FROM
        "benh_nhi" bn
    JOIN
        "buoi_kham_benh" bkb ON bn.maso = bkb.maso_bn
    JOIN
        "so_luong_thuoc" slg ON bkb.maso = slg.maso_bkb
    JOIN
        "thuoc" t ON slg.maso_th = t.maso
    WHERE
        bn.maso = child_id_input;
END;
$$ LANGUAGE plpgsql;



SELECT * FROM get_pills_for_child('e0be6c97-f834-4a73-8df4-bf06f782eec3'::uuid);



CREATE OR REPLACE FUNCTION get_bkb_in_date_range(input_cccd_bs VARCHAR(100), ffrom DATE, tto DATE)
RETURNS TABLE(
    bkb_maso UUID,
    ngaykham DATE,
    trangthai VARCHAR(50),
    benh_nhi_maso UUID,
    ten_bn VARCHAR(255)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        bkb.maso AS bkb_maso,
        bkb.ngaykham::DATE as ngaykham,
        bkb.trangthai,
        bn.maso AS benh_nhi_maso,
        bn.hoten AS ten_bn
    FROM
        "bac_si" bs
    JOIN
        "buoi_kham_benh" bkb ON bs.cccd = bkb.cccd_bs
    JOIN
        "benh_nhi" bn ON bn.maso = bkb.maso_bn
    WHERE
        bs.cccd = input_cccd_bs
        AND bkb.ngaykham BETWEEN ffrom AND tto;
END;
$$ LANGUAGE plpgsql;



SELECT * FROM get_bkb_in_date_range('345678901234', '2024-01-01', '2025-01-31');


CREATE OR REPLACE FUNCTION get_phuhuynh_from_hoadon(input_mahoadon UUID)
RETURNS TABLE(
    hoten_ph VARCHAR(100),
    hoten_bn VARCHAR(255),
    quanhe VARCHAR(50),
    ngaytao DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ph.hoten AS hoten_ph,
        bn.hoten AS hoten_bn,
        gh.quanhe AS quanhe,
        hd.ngaytao::DATE as ngaytao
    FROM
        "hoa_don" hd
    JOIN
        "buoi_kham_benh" bkb ON hd.maso_bkb = bkb.maso
    JOIN --co the toi uu o day
        "benh_nhi" bn ON bn.maso = bkb.maso_bn
    JOIN
        "giam_ho" gh ON gh.maso_bn = bn.maso
    JOIN
        "phu_huynh" ph ON ph.cccd = gh.cccd
    WHERE
        hd.mahoadon = input_mahoadon;
END;
$$ LANGUAGE plpgsql;



SELECT * FROM get_phuhuynh_from_hoadon('e0be6c97-f834-4a73-8df4-bf06f782eec3'::uuid);