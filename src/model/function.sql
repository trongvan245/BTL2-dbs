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

CREATE OR REPLACE FUNCTION get_hoadon_in_day_range(from_date DATE, to_date DATE)
RETURNS TABLE(
    maso UUID,
    ngaytao DATE,
    tongtien NUMERIC,
    maso_bkb UUID,
    hoten_bn VARCHAR(255),
    hoten_ph VARCHAR(100)
) AS $$
BEGIN
    -- Ensure the date range is valid
    IF from_date > to_date THEN
        RAISE EXCEPTION 'Invalid date range: from_date % is later than to_date %', from_date, to_date;
    END IF;

    -- Return all rows where ngaytao is within the range (inclusive)
    RETURN QUERY
    SELECT 
      hd.mahoadon AS maso, 
      hd.ngaytao::DATE AS ngaytao, 
      hd.tongtien::NUMERIC AS tongtien, 
      hd.maso_bkb AS maso_bkb,
      bn.hoten::VARCHAR(255) AS hoten_bn,
      ph.hoten::VARCHAR(100) AS hoten_ph
    FROM "hoa_don" hd
    JOIN "buoi_kham_benh" bkb ON hd.maso_bkb = bkb.maso
    JOIN "benh_nhi" bn ON bkb.maso_bn = bn.maso
    JOIN "phu_huynh" ph ON hd.cccd_ph = ph.cccd
    WHERE hd.ngaytao BETWEEN from_date AND to_date;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_hoadon_in_day_range('2024-11-23', '2024-11-23');

CREATE OR REPLACE FUNCTION get_pills_for_child(child_id_input UUID)
RETURNS TABLE(
    ms UUID, 
    ten VARCHAR(100), 
    dang VARCHAR(50), 
    tong_so_luong NUMERIC,
    tong_gia_tien NUMERIC
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
        COALESCE(SUM(slg.soluong), 0)::NUMERIC AS tong_so_luong,
        COALESCE(SUM(slg.soluong * t.giaca), 0)::NUMERIC AS tong_gia_tien
    FROM
        "benh_nhi" bn
    JOIN
        "buoi_kham_benh" bkb ON bn.maso = bkb.maso_bn
    JOIN
        "so_luong_thuoc" slg ON bkb.maso = slg.maso_bkb
    JOIN
        "thuoc" t ON slg.maso_th = t.maso
    WHERE
        bn.maso = child_id_input
    GROUP BY
        t.maso, t.ten, t.dang;
END;
$$ LANGUAGE plpgsql;



SELECT * FROM get_pills_for_child('e0be6c97-f834-4a73-8df4-bf06f782eec3'::uuid);


CREATE OR REPLACE FUNCTION get_sum_fee_for_child(parent_cccd_input VARCHAR)
RETURNS TABLE(child_name VARCHAR, maso_bn UUID, total_drug_fee NUMERIC, total_service NUMERIC, total_fee NUMERIC) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHU_HUYNH WHERE cccd = parent_cccd_input) THEN
        RAISE EXCEPTION 'Không tìm thấy phu huynh với cccd %', parent_cccd_input;
    END IF;
    
    RETURN QUERY
        SELECT 
            bn.hoten AS child_name,
            bn.maso as maso_bn,
            COALESCE(SUM(slg.soluong * t.giaca), 0) AS total_drug_fee,
            COALESCE(SUM(-slg.soluong * t.giaca + hd.tongtien), 0) AS total_service_fee,
            COALESCE(SUM(hd.tongtien), 0) AS total_fee
        FROM 
            "phu_huynh" ph
        JOIN
            "giam_ho" gh ON ph.cccd = gh.cccd
        JOIN
            "benh_nhi" bn ON gh.maso_bn = bn.maso
        JOIN
            "buoi_kham_benh" bkb ON bn.maso = bkb.maso_bn
        JOIN
            "hoa_don" hd ON bkb.maso = hd.maso_bkb
        JOIN
            "so_luong_thuoc" slg ON bkb.maso = slg.maso_bkb
        JOIN
            "thuoc" t ON slg.maso_th = t.maso
        WHERE
            ph.cccd = parent_cccd_input
        GROUP BY
          bn.hoten, bn.maso;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_sum_fee_for_child('123456789012');



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





-- CREATE OR REPLACE FUNCTION get_pill_list()
-- RETURNS TABLE( 
--   maso_thuoc UUID, 
--   tong_so_luong NUMERIC, 
--   tong_gia_tien NUMERIC
--   ) 
-- AS $$
-- BEGIN
--     RETURN QUERY
--         SELECT 
--             t.maso as maso_thuoc,
--             COALESCE(SUM(slg.soluong), 0) AS tong_so_luong,
--             COALESCE(SUM(slg.soluong * t.giaca), 0) AS tong_gia_tien
--         FROM 
--             "thuoc" t
--         JOIN
--             "so_luong_thuoc" slg ON t.maso = slg.maso_th
--         GROUP BY
--           t.maso, t.ten;
-- END;
-- $$ LANGUAGE plpgsql;


-- SELECT * FROM get_pill_list();




CREATE OR REPLACE FUNCTION get_phuhuynh_from_hoadon(input_mahoadon UUID)
RETURNS TABLE(
    hoten_ph VARCHAR(100),
    cccd_ph VARCHAR(100),
    hoten_bn VARCHAR(255),
    quanhe VARCHAR(50),
    ngaytao DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ph.hoten AS hoten_ph,
        ph.cccd AS cccd_ph,
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