-- INSERT, UPDATE and DELETE procedures for TABLE BENH_NHI
-- Thêm dữ liệu vào bảng BENH_NHI
CREATE OR REPLACE PROCEDURE InsertBenhNhi(
    IN ten_bn VARCHAR(255),
    IN ngaysinh DATE,
    IN gioitinh CHAR(255),
    IN chieucao NUMERIC(5, 2),
    IN cannang NUMERIC(5, 2),
    IN tiensubenh TEXT,
    IN masobhyt CHAR(10),
    OUT p_maso UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    bmi NUMERIC(4, 2);
BEGIN
    IF ten_bn IS NULL OR ten_bn = '' THEN
        RAISE EXCEPTION 'Họ tên bệnh nhi không được để trống.';
    END IF;
    
    IF NOT ten_bn ~ '^[A-Za-zàáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ ]+$' THEN
      RAISE EXCEPTION 'Họ tên bệnh nhi chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.';
    END IF;
    
    IF ngaysinh IS NULL THEN
        RAISE EXCEPTION 'Ngày sinh bệnh nhi không được để trống.';
    END IF;
    
    IF gioitinh IS NULL OR gioitinh = '' THEN
        RAISE EXCEPTION 'Giới tính bệnh nhi không được để trống.';
    END IF;

    IF ngaysinh > CURRENT_DATE THEN
        RAISE EXCEPTION  'Ngày sinh của bệnh nhi phải trước ngày hiện tại.';
    END IF;
    
    IF (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM ngaysinh)) >= 18 THEN
        RAISE EXCEPTION 'Bệnh nhi phải dưới 18 tuổi';
    END IF;
    
    IF gioitinh NOT IN ('Nữ', 'Nam') THEN
        RAISE EXCEPTION 'Giới tính phải là "Nữ" hoặc "Nam".';
    END IF;

    IF chieucao <= 0 OR chieucao >= 1000 THEN
        RAISE EXCEPTION  'Chiều cao phải lớn hơn 0 cm và nhỏ hơn 1000 cm (tính theo cm).';
    END IF;

    IF cannang <= 0 OR cannang >= 1000 THEN
        RAISE EXCEPTION  'Cân nặng phải lớn hơn 0 kg và nhỏ hơn 1000 kg.';
    END IF;
  
    IF masobhyt = '' THEN
       masobhyt := NULL;
    END IF;
    IF masobhyt IS NOT NULL AND LENGTH(masobhyt) != 10 THEN
        RAISE EXCEPTION  'Mã BHYT rỗng hoặc phải có đúng 10 ký tự.';
    END IF;
    
    bmi := ROUND(cannang / (chieucao / 100)^2, 2);
     
    INSERT INTO BENH_NHI (HOTEN, NGAYSINH, GIOITINH, CHIEUCAO, CANNANG, BMI, TIENSUBENH, MASOBHYT)
    VALUES (ten_bn, ngaysinh, gioitinh, chieucao, cannang, bmi, tiensubenh, masobhyt)
    RETURNING MASO INTO p_maso;
END;
$$;

-- Cập nhật dữ liệu bảng BENH_NHI
CREATE OR REPLACE PROCEDURE UpdateBenhNhi(
  In p_maso_bn UUID,
  IN p_ten_bn VARCHAR(255),
  IN p_ngaysinh DATE,
  IN p_gioitinh CHAR(255),
  IN p_chieucao NUMERIC(5, 2),
  IN p_cannang NUMERIC(5, 2),
  IN p_tiensubenh TEXT,
  IN p_masobhyt CHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    p_bmi NUMERIC(4, 2);
    old_ten_bn VARCHAR(255);
    old_ngaysinh DATE;
    old_gioitinh CHAR(255);
    old_chieucao NUMERIC(5, 2);
    old_cannang NUMERIC(5, 2);
    old_tiensubenh TEXT;
    old_masobhyt CHAR(10);
BEGIN
  IF NOT EXISTS (SELECT 1 FROM BENH_NHI WHERE MASO = p_maso_bn) THEN
      RAISE EXCEPTION 'Không tìm thấy bệnh nhi với mã số %', p_maso_bn;
  END IF;
  
  IF p_ten_bn = '' THEN
    p_ten_bn := NULL;
  END IF;
  IF p_gioitinh = '' THEN
    p_gioitinh := NULL;
  END IF;
  IF p_tiensubenh = '' THEN
    p_tiensubenh := NULL;
  END IF;
  IF p_masobhyt = '' THEN
    p_masobhyt := NULL;
  END IF;
  
  SELECT HOTEN, NGAYSINH, GIOITINH, CHIEUCAO, CANNANG, TIENSUBENH, MASOBHYT
  INTO old_ten_bn, old_ngaysinh, old_gioitinh, old_chieucao, old_cannang, old_tiensubenh, old_masobhyt
  FROM BENH_NHI
  WHERE MASO = p_maso_bn;

  p_ten_bn    := COALESCE(p_ten_bn, old_ten_bn);
  p_ngaysinh  := COALESCE(p_ngaysinh, old_ngaysinh);
  p_gioitinh  := COALESCE(p_gioitinh, old_gioitinh);
  p_chieucao  := COALESCE(p_chieucao, old_chieucao);
  p_cannang   := COALESCE(p_cannang, old_cannang);
  p_tiensubenh:= COALESCE(p_tiensubenh, old_tiensubenh);
  p_masobhyt  := COALESCE(p_masobhyt, old_masobhyt);

  IF NOT p_ten_bn ~ '^[A-Za-zàáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ ]+$' THEN
    RAISE EXCEPTION 'Họ tên bệnh nhi chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.';
  END IF;
 
  IF p_ngaysinh > CURRENT_DATE THEN
      RAISE EXCEPTION  'Ngày sinh của bệnh nhi phải trước ngày hiện tại.';
  END IF;
  
  IF (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM p_ngaysinh)) >= 18 THEN
      RAISE EXCEPTION 'Bệnh nhi phải dưới 18 tuổi';
  END IF;
  
  IF p_gioitinh NOT IN ('Nữ', 'Nam') THEN
      RAISE EXCEPTION 'Giới tính phải là "Nữ" hoặc "Nam".';
  END IF;

  IF p_chieucao <= 0 OR p_chieucao >= 1000 THEN
      RAISE EXCEPTION  'Chiều cao phải lớn hơn 0 cm và nhỏ hơn 1000 cm (tính theo cm).';
  END IF;

  IF p_cannang <= 0 OR p_cannang >= 1000 THEN
      RAISE EXCEPTION  'Cân nặng phải lớn hơn 0 kg và nhỏ hơn 1000 kg.';
  END IF;

  IF p_masobhyt = '' THEN
      p_masobhyt := NULL;
  END IF;
  IF p_masobhyt IS NOT NULL AND LENGTH(p_masobhyt) != 10 THEN
      RAISE EXCEPTION  'Mã BHYT rỗng hoặc phải có đúng 10 ký tự.';
  END IF;

  p_bmi := ROUND(p_cannang / (p_chieucao / 100)^2, 2);

  UPDATE BENH_NHI
  SET HOTEN     = p_ten_bn,
      NGAYSINH  = p_ngaysinh,
      GIOITINH  = p_gioitinh,
      CHIEUCAO  = p_chieucao,
      CANNANG   = p_cannang,
      BMI       = p_bmi,
      TIENSUBENH= p_tiensubenh,
      MASOBHYT  = p_masobhyt
  WHERE MASO = p_maso_bn;
END;
$$;

-- Xóa dữ liệu trong bảng BENH_NHI và các thông tin liên quan
CREATE OR REPLACE PROCEDURE DeleteBenhNhi(p_maso UUID)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM BENH_NHI WHERE MASO = p_maso) THEN
        RAISE EXCEPTION 'Không tìm thấy bệnh nhi với mã số %', p_maso;
    END IF;
    
    DELETE FROM GIAM_HO WHERE MASO_BN = p_maso;
  
    DELETE FROM TRIEU_CHUNG
    WHERE MASO_BKB IN (SELECT MASO FROM BUOI_KHAM_BENH WHERE MASO_BN = p_maso);

    DELETE FROM SO_LUONG_THUOC
    WHERE MASO_BKB IN (SELECT MASO FROM BUOI_KHAM_BENH WHERE MASO_BN = p_maso);

    DELETE FROM DON_THUOC
    WHERE MASO_BKB IN (SELECT MASO FROM BUOI_KHAM_BENH WHERE MASO_BN = p_maso);
    
    DELETE FROM LAN_THUC_HIEN_DICH_VU
    WHERE MASO_BKB IN (SELECT MASO FROM BUOI_KHAM_BENH WHERE MASO_BN = p_maso);

    DELETE FROM BUOI_KHAM_BENH
    WHERE MASO_BN = p_maso;

    DELETE FROM HOA_DON
    WHERE MASO_BKB IN (SELECT MASO FROM BUOI_KHAM_BENH WHERE MASO_BN = p_maso);

    DELETE FROM BENH_NHI
    WHERE MASO = p_maso;

    RAISE NOTICE 'Đã xóa thành công bệnh nhi với mã số % và tất cả dữ liệu liên quan', p_maso;
END;
$$;

------------------------------------------------------------------
------------------------------------------------------------------
-- Thêm dữ liệu vào bảng PHU_HUYNH
CREATE OR REPLACE PROCEDURE InsertPhuHuynh(
    IN p_cccd CHAR(12),
    IN p_hoten VARCHAR(255),
    IN p_sdt CHAR(10),
    IN p_sonha VARCHAR(255),
    IN p_tenduong VARCHAR(255),
    IN p_phuong VARCHAR(255),
    IN p_huyen VARCHAR(255),
    IN p_tinh VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_hoten IS NULL OR p_hoten = '' THEN
        RAISE EXCEPTION 'Họ tên phụ huynh không được để trống.';
    END IF;
    
    IF LENGTH(p_cccd) != 12 OR p_cccd !~ '^\d+$' THEN
        RAISE EXCEPTION 'CCCD phải là chứa đúng 12 số.';
    END IF;
    
    IF NOT p_hoten ~ '^[A-Za-zàáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ ]+$' THEN
      RAISE EXCEPTION 'Họ tên phụ huynh chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.';
    END IF;
    
    IF LENGTH(p_sdt) != 10 OR p_sdt !~ '^\d+$' THEN
        RAISE EXCEPTION 'Số điện thoại phải là chứa đúng 10 số.';
    END IF;
    
    
    IF p_sonha IS NULL OR p_sonha = '' THEN
        RAISE EXCEPTION 'Số nhà không được để trống.';
    END IF;

    IF p_tenduong IS NULL OR p_tenduong = '' THEN
        RAISE EXCEPTION 'Tên đường không được để trống.';
    END IF;

    IF p_phuong IS NULL OR p_phuong = '' THEN
        RAISE EXCEPTION 'Phường không được để trống.';
    END IF;

    IF p_huyen IS NULL OR p_huyen = '' THEN
        RAISE EXCEPTION 'Huyện không được để trống.';
    END IF;

    IF p_tinh IS NULL OR p_tinh = '' THEN
        RAISE EXCEPTION 'Tỉnh không được để trống.';
    END IF;
    
    INSERT INTO PHU_HUYNH (CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH)
    VALUES (p_cccd, p_hoten, p_sdt, p_sonha, p_tenduong, p_phuong, p_huyen, p_tinh);
    RAISE NOTICE 'Thêm phụ huynh thành công!';
END;
$$;

------------------------------------------------------------------
------------------------------------------------------------------
-- Thêm dữ liệu vào bảng GIAM_HO
CREATE OR REPLACE PROCEDURE InsertGiamHo(
    IN p_cccd CHAR(12),
    IN b_maso UUID,
    IN p_quanhe VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHU_HUYNH WHERE CCCD = p_cccd) THEN
        RAISE EXCEPTION 'Không tìm thấy phụ huynh với CCCD %', p_cccd;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM BENH_NHI WHERE MASO = b_maso) THEN
        RAISE EXCEPTION 'Không tìm thấy bệnh nhi với mã số %', b_maso;
    END IF;
    
    IF p_quanhe IS NULL OR p_quanhe = '' THEN
        RAISE EXCEPTION 'Quan hệ khồng được để trống.';
    END IF;
    
    IF p_quanhe NOT IN ('Cha', 'Mẹ', 'Anh', 'Chị', 'Em', 'Bác', 'Dì', 'Chú', 'Cô', 'Ông', 'Bà') THEN
        RAISE EXCEPTION 'Quan hệ với bệnh nhi phải là: ''Cha'', ''Mẹ'', ''Anh'', ''Chị'', ''Em'', ''Bác'', ''Dì'', ''Chú'', ''Cô'', ''Ông'', ''Bà''';
    END IF;
    
    
    INSERT INTO GIAM_HO (CCCD, MASO_BN, QUANHE) 
    VALUES (p_cccd, b_maso, p_quanhe);
    
    RAISE NOTICE 'Thêm quan hệ  giữa phụ huynh và bệnh nhi thành công!';
END;
$$;

-- Ví dụ
-- CALL InsertGiamHo(
--     '123456789012',
--     '159ad795-6338-4990-a643-f84da4c555c4',
--     'Chú'
-- );

------------------------------------------------------------------
------------------------------------------------------------------
-- Thêm dữ liệu vào bảng THUOC

CREATE OR REPLACE PROCEDURE InsertThuoc(
    IN p_ten VARCHAR(100),
    IN p_dang VARCHAR(50),
    IN p_giaca BIGINT,
    OUT p_maso UUID
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_ten IS NULL OR p_ten = '' THEN
        RAISE EXCEPTION 'Tên thuốc không được để trống.';
    END IF;

    IF p_dang NOT IN ('Viên', 'Chai', 'Hộp', 'Ống', 'Lọ', 'Gói', 'Hủ', 'Túi', 'Vỉ', 'Khác') THEN
        RAISE EXCEPTION 'Dạng thuốc không hợp lệ. Các giá trị hợp lệ: ''Viên'', ''Chai'', ''Hộp'', ''Ống'', ''Lọ'', ''Gói'', ''Hủ'', ''Túi'', ''Vỉ'', ''Khác''.';
    END IF;

    IF p_giaca < 0 THEN
        RAISE EXCEPTION 'Giá cả phải lớn hơn hoặc bằng 0.';
    END IF;

    INSERT INTO THUOC (TEN, DANG, GIACA)
    VALUES (p_ten, p_dang, p_giaca)
    RETURNING MASO INTO p_maso;

    RAISE NOTICE 'Thuốc "%: % - %d" đã được thêm thành công.', p_ten, p_dang, p_giaca;
END;
$$;

-- Ví dụ:
-- CALL InsertThuoc('Acetuss 200mg/10ml', 'Ống', 7169, NULL);
-- CALL InsertThuoc('Cefurich 500mg','Viên',13900, NULL);

-- Cập nhật dữ liệu bảng THUOC
CREATE OR REPLACE PROCEDURE UpdateThuoc(
    IN p_maso UUID,
    IN p_ten VARCHAR(100),
    IN p_dang VARCHAR(50),
    IN p_giaca BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
    old_ten VARCHAR(100);
    old_dang VARCHAR(50);
    old_giaca BIGINT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM THUOC WHERE MASO = p_maso) THEN
        RAISE EXCEPTION 'Không tìm thấy thuốc với mã số %.', p_maso;
    END IF;

    IF p_ten = '' THEN
        p_ten := NULL;
    END IF;
    IF p_dang = '' THEN
        p_dang := NULL;
    END IF;

    SELECT TEN, DANG, GIACA
    INTO old_ten, old_dang, old_giaca
    FROM THUOC
    WHERE MASO = p_maso;

    p_ten := COALESCE(p_ten, old_ten);
    p_dang := COALESCE(p_dang, old_dang);
    p_giaca := COALESCE(p_giaca, old_giaca);

    IF p_ten IS NOT NULL AND p_ten = '' THEN
        RAISE EXCEPTION 'Tên thuốc không được để trống.';
    END IF;

    IF p_dang IS NOT NULL AND p_dang NOT IN ('Viên', 'Chai', 'Hộp', 'Ống', 'Lọ', 'Gói', 'Hủ', 'Túi', 'Vỉ', 'Khác') THEN
        RAISE EXCEPTION 'Dạng thuốc không hợp lệ. Các giá trị hợp lệ: ''Viên'', ''Chai'', ''Hộp'', ''Ống'', ''Lọ'', ''Gói'', ''Hủ'', ''Túi'', ''Vỉ'', ''Khác''.';
    END IF;

    IF p_giaca IS NOT NULL AND p_giaca < 0 THEN
        RAISE EXCEPTION 'Giá cả phải lớn hơn hoặc bằng 0.';
    END IF;

    UPDATE THUOC
    SET TEN = p_ten,
        DANG = p_dang,
        GIACA = p_giaca
    WHERE MASO = p_maso;

    RAISE NOTICE 'Thông tin thuốc với mã số "%" đã được cập nhật.', p_maso;
END;
$$;

-- Ví dụ
-- CALL UpdateThuoc('e9b69318-4400-42b8-a305-78e29d126ccd','','Viên',13900);

-- Xóa dữ liệu bảng THUOC
CREATE OR REPLACE PROCEDURE DeleteThuoc(
    IN p_maso UUID
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM THUOC WHERE MASO = p_maso) THEN
        RAISE EXCEPTION 'Không tìm thấy thuốc với mã số %.', p_maso;
    END IF;

    IF EXISTS (SELECT 1 FROM SO_LUONG_THUOC WHERE MASO_TH = p_maso) THEN
        RAISE EXCEPTION 'Thuốc với mã số % đang được sử dụng trong bảng SO_LUONG_THUOC và không thể xóa.', p_maso;
    END IF;

    DELETE FROM THUOC WHERE MASO = p_maso;

    RAISE NOTICE 'Thuốc với mã số % đã được xóa thành công.', p_maso;
END;
$$;