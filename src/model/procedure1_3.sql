CREATE OR REPLACE FUNCTION calculate_patient_costs(cccd_input VARCHAR)
RETURNS TABLE(
    benh_nhi UUID,
    hoten VARCHAR,
    thuoc_total NUMERIC,
    dich_vu_total NUMERIC,
    total NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH 
        Thuoc_Sum AS (
            SELECT  
                B.MASO AS BENH_NHI,
                B.HOTEN,
                SUM(S.SOLUONG * T.GIACA) AS THUOC_TOTAL
            FROM 
                GIAM_HO G 
            JOIN 
                BENH_NHI B ON G.MASO_BN = B.MASO
            JOIN 
                BUOI_KHAM_BENH BU ON B.MASO = BU.MASO_BN  
            JOIN 
                SO_LUONG_THUOC S ON S.MASO_BKB = BU.MASO
            JOIN 
                THUOC T ON S.MASO_TH = T.MASO
            WHERE 
                G.CCCD = cccd_input
            GROUP BY 
                B.MASO, B.HOTEN
        ),
        DichVu_Sum AS (
            SELECT  
                B.MASO AS BENH_NHI,
                B.HOTEN,
                SUM(D.GIACA) AS DICH_VU_TOTAL
            FROM 
                GIAM_HO G 
            JOIN 
                BENH_NHI B ON G.MASO_BN = B.MASO
            JOIN 
                BUOI_KHAM_BENH BU ON B.MASO = BU.MASO_BN  
            JOIN 
                LAN_THUC_HIEN_DICH_VU L ON L.MASO_BKB = BU.MASO 
            JOIN 
                DICH_VU_KHAM D ON L.MADICHVU = D.MADICHVU
            WHERE 
                G.CCCD = cccd_input
            GROUP BY 
                B.MASO, B.HOTEN
        )
    SELECT 
        T.BENH_NHI,
        T.HOTEN,
        COALESCE(T.THUOC_TOTAL, 0) AS THUOC_TOTAL,
        COALESCE(D.DICH_VU_TOTAL, 0) AS DICH_VU_TOTAL,
        COALESCE(T.THUOC_TOTAL, 0) + COALESCE(D.DICH_VU_TOTAL, 0) AS TOTAL
    FROM 
        Thuoc_Sum T
    FULL OUTER JOIN 
        DichVu_Sum D ON T.BENH_NHI = D.BENH_NHI;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM calculate_patient_costs('123456789012');



CREATE OR REPLACE FUNCTION GET_BACSI_BUOIKHAM(P_NGAY DATE, P_SOLUONG INT)
RETURNS TABLE (
    cccd VARCHAR,
    so_luong_kham INT
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        bs.CCCD, 
      COUNT(bkb.MASO)::INT AS SoLuongKham
    FROM 
        BAC_SI bs
    JOIN 
        BUOI_KHAM_BENH bkb 
        ON bs.CCCD = bkb.CCCD_BS
    WHERE 
        DATE(bkb.NGAYKHAM) = P_NGAY::DATE
    GROUP BY 
        bs.CCCD
    HAVING 
        COUNT(bkb.MASO) > P_SOLUONG;
END;
$$;

SELECT * FROM GET_BACSI_BUOIKHAM('2024-12-01', 1);