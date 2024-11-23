-- CREATE DATABASE

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- MASOBHYT is unique
ALTER TABLE BENH_NHI
ADD CONSTRAINT unique_masobhyt UNIQUE (MASOBHYT);


CREATE TABLE BENH_NHI (
    MASO UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    HOTEN VARCHAR(255),
    NGAYSINH DATE,
    GIOITINH CHAR(255),
    CHIEUCAO INT NOT NULL,
    CANNANG INT NOT NULL,
    BMI DECIMAL(4, 2),
    TIENSUBENH VARCHAR(555),
    MASOBHYT VARCHAR(255)
);

CREATE TABLE PHU_HUYNH (
    CCCD VARCHAR(100) PRIMARY KEY,
    HOTEN VARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    SONHA VARCHAR(100),
    TENDUONG VARCHAR(100),
    PHUONG VARCHAR(50),
    HUYEN VARCHAR(50)  NOT NULL,
    TINH VARCHAR(50) NOT NULL
);

CREATE TABLE GIAM_HO (
    MASO_BN UUID,
    CCCD VARCHAR(100),
    QUANHE VARCHAR(50),
    PRIMARY KEY (MASO_BN, CCCD),
    FOREIGN KEY (MASO_BN) REFERENCES BENH_NHI(MASO),
    FOREIGN KEY (CCCD) REFERENCES PHU_HUYNH(CCCD)
);

CREATE TABLE NHAN_VIEN (
    CCCD VARCHAR(100) PRIMARY KEY,
    HOTEN VARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    SONHA VARCHAR(100),
    TENDUONG VARCHAR(100),
    PHUONG VARCHAR(100),
    HUYEN VARCHAR(100) NOT NULL,
    TINH VARCHAR(100) NOT NULL
);

CREATE TABLE NHAN_VIEN_Y_TE (
    CCCD VARCHAR(100) PRIMARY KEY REFERENCES NHAN_VIEN(CCCD)
);

CREATE TABLE BAC_SI (
    CCCD VARCHAR(100) PRIMARY KEY REFERENCES NHAN_VIEN_Y_TE(CCCD),
    CHUYENKHOA VARCHAR(100),
    BANGCAP VARCHAR(100),
    CC_HANHNGHE VARCHAR(100)
)

CREATE TABLE KY_THUAT_VIEN (
    CCCD VARCHAR(100) PRIMARY KEY REFERENCES NHAN_VIEN_Y_TE(CCCD),
    VITRI VARCHAR(100),
    CHUNGCHI VARCHAR(100)
);

CREATE TABLE THU_NGAN (
    CCCD VARCHAR(100) PRIMARY KEY REFERENCES NHAN_VIEN(CCCD)
);


ALTER TABLE BUOI_KHAM_BENH
DROP CONSTRAINT fk_cccd_bs;

ALTER TABLE BUOI_KHAM_BENH
ADD CONSTRAINT fk_cccd_bs FOREIGN KEY (CCCD_BS) REFERENCES BAC_SI(CCCD);

ALTER TABLE BUOI_KHAM_BENH
ADD COLUMN MAHOADON UUID;
ADD CONSTRAINT fk_mahoadon FOREIGN KEY (MAHOADON) REFERENCES HOA_DON(MAHOADON);

CREATE TABLE BUOI_KHAM_BENH (
    MASO UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    NGAYKHAM DATE DEFAULT CURRENT_DATE,
    TAIKHAM BOOLEAN NOT NULL,
    TRANGTHAI VARCHAR(50) NOT NULL,
    HUYETAP VARCHAR(20) NOT NULL,
    NHIETDO DECIMAL(4, 2) NOT NULL,
    CHANDOAN VARCHAR(255) NOT NULL,
    KETLUAN VARCHAR(255) NOT NULL,
    MASO_BN UUID NOT NULL,
    CCCD_BS VARCHAR(100) NOT NULL,
    FOREIGN KEY (MASO_BN) REFERENCES BENH_NHI(MASO),
    FOREIGN KEY (CCCD_BS) REFERENCES BAC_SI(CCCD),
);

CREATE TABLE TRIEU_CHUNG (
    MASO_BKB UUID,
    TRIEUCHUNG VARCHAR(255),
    PRIMARY KEY (MASO_BKB, TRIEUCHUNG),
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO)
);

drop TABLE hoa_don
CREATE TABLE HOA_DON (
    MAHOADON UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    NGAYTAO DATE DEFAULT CURRENT_DATE,
    TONGTIEN BIGINT NOT NULL,
    GHICHU VARCHAR(500),
    MASO_BKB UUID NOT NULL,
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO)
    CCCD_PH VARCHAR(100) REFERENCES PHU_HUYNH(CCCD),
    CCCD_TN VARCHAR(100) REFERENCES THU_NGAN(CCCD)
);

CREATE TABLE DICH_VU_KHAM (
    MADICHVU UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TEN VARCHAR(100) NOT NULL,
    GIACA BIGINT NOT NULL,
    MOTA VARCHAR(500) NOT NULL
);

CREATE TABLE THUOC (
    MASO UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TEN VARCHAR(100) NOT NULL, 
    DANG VARCHAR(50) NOT NULL,
    GIACA BIGINT NOT NULL
);


CREATE TABLE DON_THUOC (
    MASO_BKB UUID NOT NULL,
    THOIGIANRADON DATE DEFAULT CURRENT_DATE ,
    NGAYTAIKHAM DATE ,
    LOIDAN VARCHAR(255) NOT NULL,
    MASO_BN UUID,
    CCCD_BS VARCHAR(100),
    PRIMARY KEY (MASO_BKB, THOIGIANRADON),
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO),
    FOREIGN KEY (CCCD_BS) REFERENCES PHU_HUYNH(CCCD),
)

CREATE TABLE SO_LUONG_THUOC (
    MASO_BKB UUID,
    MASO_TH UUID,
    SOLUONG INT NOT NULL,
    CACHSD VARCHAR(255) NOT NULL,
    PRIMARY KEY (MASO_BKB, MASO_TH),
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO),
    FOREIGN KEY (MASO_TH) REFERENCES THUOC(MASO)
)

ALTER TABLE LAN_THUC_HIEN_DICH_VU
DROP COLUMN MAHOADON;

CREATE TABLE LAN_THUC_HIEN_DICH_VU (
    MASO UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    NGAYTHUCHIEN DATE DEFAULT CURRENT_DATE,
    CHUANDOAN VARCHAR(255) NOT NULL,
    KETLUAN VARCHAR(255) NOT NULL,
    MASO_BKB UUID NOT NULL,
    MAHOADON UUID  NOT NULL,
    MADICHVU UUID DEFAULT uuid_generate_v4(),
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO),
    FOREIGN KEY (MAHOADON) REFERENCES HOA_DON(MAHOADON),
    FOREIGN KEY (MADICHVU) REFERENCES DICH_VU_KHAM(MADICHVU)
);

CREATE TABLE THAM_GIA_DICH_VU (
    MASO_LTHDV UUID,
    CCCD_NVYT VARCHAR(100),
    PRIMARY KEY (MASO_LTHDV, CCCD_NVYT),
    FOREIGN KEY (MASO_LTHDV) REFERENCES LAN_THUC_HIEN_DICH_VU(MASO),
    FOREIGN KEY (CCCD_NVYT) REFERENCES NHAN_VIEN(CCCD)
);


-- TRIGGER
CREATE OR REPLACE FUNCTION check_birthday()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.NGAYSINH > CURRENT_DATE THEN
        RAISE EXCEPTION 'Ngày sinh của bệnh nhi không hợp lệ! Ngày sinh phải trước ngày hiện tại.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_birthday_trigger
BEFORE INSERT OR UPDATE ON BENH_NHI
FOR EACH ROW
EXECUTE FUNCTION check_birthday();

INSERT INTO BENH_NHI (HOTEN, NGAYSINH, GIOITINH, CHIEUCAO, CANNANG, BMI, TIENSUBENH, MASOBHYT)
VALUES 
    ('Nguyen Van A', '2030-05-15', 'M', 150, 40, 17.8, 'Không có tiền sử bệnh', '123456789')


-- CREATE OR REPLACE FUNCTION CHECK_TAIKHAM()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     IF NEW.TAIKHAM = TRUE THEN
        
--     END IF;
--     RETURN NEW;
-- END;

---
CREATE OR REPLACE FUNCTION CHECK_NGAYTAIKHAM()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.NGAYTAIKHAM < NEW.THOIGIANRADON THEN
        RAISE EXCEPTION 'Ngày tái khám không hợp lệ! Ngày tái khám phải sau ngày ra đơn.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_ngaytaikham_trigger
BEFORE INSERT OR UPDATE ON DON_THUOC
FOR EACH ROW
EXECUTE FUNCTION check_ngaytaikham();

---
CREATE OR REPLACE FUNCTION CHECK_KHOANGTAIKHAM()
RETURNS TRIGGER AS $$
BEGIN 
    IF NEW.NGAYTAIKHAM < NEW.THOIGIANRADON + 3 THEN
        RAISE EXCEPTION 'Ngày tái khám không hợp lệ! Ngày tái khám phải sau ít nhất 3 ngày kể từ lần khám trướ.';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_khoangtaikham_trigger
BEFORE INSERT OR UPDATE ON DON_THUOC
FOR EACH ROW
EXECUTE FUNCTION check_khoangtaikham();

---
CREATE OF REPLACE FUNCTION CHECK_TONGTIENDONTHUOC()
RETURNS TRIGGER AS $$
DECLARE  
    TOTALSERVICECOST BIGINT;
    TOTALMEDICINECOST BIGINT;
    TOTAL BIGINT;
BEGIN
    -- Tính tổng tiền dịch vụ
    SELECT SUM(GIACA) FROM LAN_THUC_HIEN_DICH_VU L 
    JOIN DICH_VU_KHAM D ON L.MADICHVU = D.MADICHVU 
    WHERE MAHOADON = NEW.MAHOADON INTO TOTALSERVICECOST;

    -- Tính tổng tiền thuốc
    SELECT SUM(GIACA * SOLUONG) FROM SO_LUONG_THUOC S 
    JOIN THUOC T ON S.MASO_TH = T.MASO 
    JOIN DON_THUOC D ON S.MASO_BKB =D.MASO_BKB 
    WHERE D.MAHOADON = NEW.MAHOADON INTO TOTALMEDICINECOST;

    -- Tính tổng tiền   
    TOTAL = TOTALSERVICECOST + TOTALMEDICINECOST;
    IF NEW.TONGTIEN != TOTAL THEN
        NEW.TONGTIEN = TOTAL;
        RAISE EXCEPTION 'Tổng tiền không hợp lệ! Tổng tiền phải bằng tổng tiền dịch vụ và tổng tiền thuốc.';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER check_tongtiendonthuoc_trigger
BEFORE INSERT OR UPDATE ON HOA_DON
FOR EACH ROW
EXECUTE FUNCTION check_tongtiendonthuoc();

-- 
CREATE OR REPLACE FUNCTION CHECK_HETTHUOC()
RETURNS TRIGGER AS $$
DECLARE
    REMAIN INT;
BEGIN
    SELECT SOLUONG FROM THUOC WHERE MASO = NEW.MASO_TH INTO REMAIN;
    IF REMAIN < NEW.SOLUONG THEN
        RAISE EXCEPTION 'Không đủ thuốc trong kho';
    END IF;    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_hetthuoc_trigger
BEFORE INSERT OR UPDATE ON SO_LUONG_THUOC
FOR EACH ROW
EXECUTE FUNCTION check_hetthuoc();

--- UPDATE NUMBER OF MEDICINE AFTER PRESCRIPTION
CREATE OR REPLACE FUNCTION UPDATE_NUMBER_OF_MEDICINE()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE THUOC
    SET SOLUONG = SOLUONG - NEW.SOLUONG
    WHERE MASO = NEW.MASO_TH;
    RETURN NEW;
END;

CREATE TRIGGER update_number_of_medicine_trigger
AFTER INSERT ON SO_LUONG_THUOC
FOR EACH ROW
EXECUTE FUNCTION update_number_of_medicine();


-- GET BENHNHI BY CCCD

CREATE OR REPLACE PROCEDURE get_benh_nhi_by_cccd(IN p_cccd VARCHAR(100))
LANGUAGE plpgsql
AS $$
BEGIN
        PERFORM * FROM GIAM_HO G
        JOIN BENH_NHI B ON G.MASO_BN = B.MASO
        WHERE G.CCCD = p_cccd;
        RAISE NOTICE 'Query executed for CCCD: %', p_cccd;
END;
$$;
CALL get_benh_nhi_by_cccd('123456789');


-- GET BUOIKHAMBENHBYCHILDID


CREATE OR REPLACE PROCEDURE get_buoi_kham_benh_by_child_id(IN p_maso_bn UUID)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Retrieve data for BUOI_KHAM_BENH based on MASO_BN
    RAISE NOTICE 'Fetching data for BUOI_KHAM_BENH with MASO_BN: %', p_maso_bn;
    
    -- Execute the query
    EXECUTE '
        SELECT * FROM BUOI_KHAM_BENH B
        JOIN BAC_SI BS ON B.CCCD_BS = BS.CCCD
        JOIN LAN_THUC_HIEN_DICH_VU L ON B.MASO = L.MASO_BKB
        JOIN DICH_VU_KHAM D ON L.MADICHVU = D.MADICHU
        JOIN DON_THUOC DT ON B.MASO = DT.MASO_BKB
        JOIN SO_LUONG_THUOC S ON DT.MASO_BKB = S.MASO_BKB
        JOIN THUOC T ON S.MASO_TH = T.MASO
        WHERE B.MASO_BN = $1'
    USING p_maso_bn;
END;
$$;
CALL get_buoi_kham_benh_by_child_id('123456789');
