-- Delete all schema 
DO $$ DECLARE
    schema_name text;
BEGIN
    FOR schema_name IN
        SELECT s.schema_name
        FROM information_schema.schemata s
        WHERE s.schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        EXECUTE format('DROP SCHEMA %I CASCADE', schema_name);
    END LOOP;
END $$;


-- Create schema
CREATE SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- Create extension for uuid_generate_v4 function

CREATE TABLE BENH_NHI (
    MASO UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    HOTEN VARCHAR(255),
    NGAYSINH DATE NOT NULL CHECK (NGAYSINH < CURRENT_DATE),
    GIOITINH CHAR(255) CHECK (GIOITINH IN ('Nam', 'Nữ')),
    CHIEUCAO INT NOT NULL CHECK (CHIEUCAO > 0),
    CANNANG INT NOT NULL CHECK (CANNANG > 0),
    BMI DECIMAL(4, 2) ,
    TIENSUBENH VARCHAR(555),
    MASOBHYT VARCHAR(255) UNIQUE
);

CREATE TABLE PHU_HUYNH (
    CCCD VARCHAR(100) PRIMARY KEY CHECK (LENGTH(CCCD) = 12),
    HOTEN VARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL CHECK (LENGTH(SDT) = 10),
    SONHA VARCHAR(100),
    TENDUONG VARCHAR(100),
    PHUONG VARCHAR(50),
    HUYEN VARCHAR(50)  NOT NULL,
    TINH VARCHAR(50) NOT NULL
);


CREATE TABLE GIAM_HO (
    MASO_BN UUID NOT NULL,
    CCCD VARCHAR(100) NOT NULL,
    QUANHE VARCHAR(50) NOT NULL CHECK (QUANHE IN ('Cha', 'Mẹ', 'Anh', 'Chị', 'Em','Bác', 'Dì', 'Chú', 'Cô', 'Ông', 'Bà')),
    PRIMARY KEY (MASO_BN, CCCD),
    FOREIGN KEY (MASO_BN) REFERENCES BENH_NHI(MASO),
    FOREIGN KEY (CCCD) REFERENCES PHU_HUYNH(CCCD)
);


CREATE TABLE NHAN_VIEN (
    CCCD VARCHAR(100) PRIMARY KEY CHECK (LENGTH(CCCD) = 12),
    HOTEN VARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL CHECK (LENGTH(SDT) = 10),
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
);


CREATE TABLE KY_THUAT_VIEN (
    CCCD VARCHAR(100) PRIMARY KEY REFERENCES NHAN_VIEN_Y_TE(CCCD),
    VITRI VARCHAR(100),
    CHUNGCHI VARCHAR(100)
);


CREATE TABLE THU_NGAN (
    CCCD VARCHAR(100) PRIMARY KEY REFERENCES NHAN_VIEN(CCCD)
);


CREATE TABLE BUOI_KHAM_BENH (
    MASO UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    NGAYKHAM TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TAIKHAM BOOLEAN NOT NULL,
    TRANGTHAI VARCHAR(50) NOT NULL,
    HUYETAP VARCHAR(20) NOT NULL,
    NHIETDO DECIMAL(4, 2) NOT NULL CHECK (NHIETDO > 0),
    CHANDOAN VARCHAR(255) NOT NULL,
    KETLUAN VARCHAR(255) NOT NULL,
    MASO_BN UUID NOT NULL,
    CCCD_BS VARCHAR(100) NOT NULL,
    FOREIGN KEY (MASO_BN) REFERENCES BENH_NHI(MASO),
    FOREIGN KEY (CCCD_BS) REFERENCES BAC_SI(CCCD)
);


CREATE TABLE TRIEU_CHUNG (
    MASO_BKB UUID,
    TRIEUCHUNG VARCHAR(255),
    PRIMARY KEY (MASO_BKB, TRIEUCHUNG),
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO)
);



CREATE TABLE HOA_DON (
    MAHOADON UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    NGAYTAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TONGTIEN BIGINT NOT NULL CHECK (TONGTIEN >= 0),
    GHICHU VARCHAR(500),
    MASO_BKB UUID UNIQUE NOT NULL , 
    CCCD_PH VARCHAR(100) NOT NULL,
    CCCD_TN VARCHAR(100) NOT NULL,
    TRANGTHAI VARCHAR(50) NOT NULL CHECK (TRANGTHAI IN ('PENDING', 'DONE')),
 
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO),
    FOREIGN KEY (CCCD_PH) REFERENCES PHU_HUYNH(CCCD),
    FOREIGN KEY (CCCD_TN) REFERENCES THU_NGAN(CCCD)
);


CREATE TABLE DICH_VU_KHAM (
    MADICHVU UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TEN VARCHAR(100) NOT NULL,
    GIACA BIGINT NOT NULL CHECK (GIACA >= 0),
    MOTA VARCHAR(500) NOT NULL
);


CREATE TABLE THUOC (
    MASO UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TEN VARCHAR(100) NOT NULL,
    DANG VARCHAR(50) NOT NULL CHECK (DANG IN ('Viên', 'Chai', 'Hộp', 'Ống', 'Lọ', 'Gói', 'Hủ', 'Túi','Vỉ', 'Khác')),
    GIACA BIGINT NOT NULL CHECK (GIACA >= 0)
);




CREATE TABLE DON_THUOC (
    MASO_BKB UUID NOT NULL,
    THOIGIANRADON TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    NGAYTAIKHAM DATE CHECK (NGAYTAIKHAM > CURRENT_DATE + 3),
    LOIDAN VARCHAR(255) NOT NULL,
    MASO_BN UUID,
    CCCD_BS VARCHAR(100),
    PRIMARY KEY (MASO_BKB, THOIGIANRADON),
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO),
    FOREIGN KEY (CCCD_BS) REFERENCES BAC_SI(CCCD)
);

CREATE TABLE SO_LUONG_THUOC (
    MASO_BKB UUID,
    MASO_TH UUID,
    SOLUONG INT NOT NULL CHECK (SOLUONG > 0),
    CACHSD VARCHAR(255) NOT NULL,
    PRIMARY KEY (MASO_BKB, MASO_TH),
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO),
    FOREIGN KEY (MASO_TH) REFERENCES THUOC(MASO)
);

CREATE TABLE LAN_THUC_HIEN_DICH_VU (
    MASO UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    NGAYTHUCHIEN DATE DEFAULT CURRENT_DATE,
    CHUANDOAN VARCHAR(255) NOT NULL,
    KETLUAN VARCHAR(255) NOT NULL,
    MASO_BKB UUID NOT NULL,
    CCCD_NVYT VARCHAR(100)  NOT NULL,
    MADICHVU UUID NOT NULL,
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO),
    FOREIGN KEY (MADICHVU) REFERENCES DICH_VU_KHAM(MADICHVU),
    FOREIGN KEY (CCCD_NVYT) REFERENCES NHAN_VIEN_Y_TE(CCCD)
);


--- Data
INSERT INTO BENH_NHI (MASO, HOTEN, NGAYSINH, GIOITINH, CHIEUCAO, CANNANG, BMI, TIENSUBENH, MASOBHYT)
VALUES 
('123e4567-e89b-12d3-a456-426614174000', 'Nguyen Van A', '2015-05-10', 'Nam', 120, 30, 20.83, 'Hen suyễn', 'BHYT0001'),
('123e4567-e89b-12d3-a456-426614174001', 'Tran Thi B', '2016-11-20', 'Nữ', 115, 25, 18.88, NULL, 'BHYT0002'),
('123e4567-e89b-12d3-a456-426614174002', 'Pham Van C', '2014-03-15', 'Nam', 130, 40, 23.66, 'Dị ứng', 'BHYT0003'),
('123e4567-e89b-12d3-a456-426614174003', 'Le Thi D', '2013-07-18', 'Nữ', 140, 35, 17.86, NULL, 'BHYT0004'),
('123e4567-e89b-12d3-a456-426614174004', 'Hoang Van E', '2012-12-30', 'Nam', 150, 45, 20.00, 'Viêm phế quản', 'BHYT0005'),
('123e4567-e89b-12d3-a456-426614174005', 'Nguyen Thi F', '2016-04-01', 'Nữ', 110, 22, 18.18, NULL, 'BHYT0006'),
('123e4567-e89b-12d3-a456-426614174006', 'Pham Van G', '2015-09-09', 'Nam', 125, 33, 21.12, 'Hen suyễn', 'BHYT0007'),
('123e4567-e89b-12d3-a456-426614174007', 'Tran Thi H', '2017-01-01', 'Nữ', 100, 20, 20.00, NULL, 'BHYT0008'),
('123e4567-e89b-12d3-a456-426614174008', 'Le Van I', '2013-05-25', 'Nam', 135, 38, 20.89, NULL, 'BHYT0009'),
('123e4567-e89b-12d3-a456-426614174009', 'Nguyen Thi J', '2014-10-10', 'Nữ', 145, 40, 19.05, NULL, 'BHYT0010');

INSERT INTO PHU_HUYNH (CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH)
VALUES 
('012345678901', 'Nguyen Van K', '0901234567', '123', 'Nguyen Hue', 'Phuong 1', 'Quan 1', 'Ho Chi Minh'),
('012345678902', 'Tran Thi L', '0901234568', '124', 'Le Loi', 'Phuong 2', 'Quan 2', 'Ho Chi Minh'),
('012345678903', 'Le Van M', '0901234569', '125', 'Pham Ngu Lao', 'Phuong 3', 'Quan 3', 'Ho Chi Minh'),
('012345678904', 'Pham Thi N', '0901234570', '126', 'Hai Ba Trung', 'Phuong 4', 'Quan 4', 'Ho Chi Minh'),
('012345678905', 'Hoang Van O', '0901234571', '127', 'Vo Thi Sau', 'Phuong 5', 'Quan 5', 'Ho Chi Minh'),
('012345678906', 'Nguyen Thi P', '0901234572', '128', 'Tran Hung Dao', 'Phuong 6', 'Quan 6', 'Ho Chi Minh'),
('012345678907', 'Tran Van Q', '0901234573', '129', 'Ly Thuong Kiet', 'Phuong 7', 'Quan 7', 'Ho Chi Minh'),
('012345678908', 'Le Thi R', '0901234574', '130', 'Ngo Gia Tu', 'Phuong 8', 'Quan 8', 'Ho Chi Minh'),
('012345678909', 'Pham Van S', '0901234575', '131', 'Dien Bien Phu', 'Phuong 9', 'Quan 9', 'Ho Chi Minh'),
('012345678910', 'Hoang Thi T', '0901234576', '132', 'Nguyen Trai', 'Phuong 10', 'Quan 10', 'Ho Chi Minh');

INSERT INTO GIAM_HO (MASO_BN, CCCD, QUANHE)
VALUES 
('123e4567-e89b-12d3-a456-426614174000', '012345678901', 'Cha'),
('123e4567-e89b-12d3-a456-426614174001', '012345678902', 'Mẹ'),
('123e4567-e89b-12d3-a456-426614174002', '012345678903', 'Anh'),
('123e4567-e89b-12d3-a456-426614174003', '012345678904', 'Chị'),
('123e4567-e89b-12d3-a456-426614174004', '012345678905', 'Bà'),
('123e4567-e89b-12d3-a456-426614174005', '012345678906', 'Dì'),
('123e4567-e89b-12d3-a456-426614174006', '012345678907', 'Ông'),
('123e4567-e89b-12d3-a456-426614174007', '012345678908', 'Cô'),
('123e4567-e89b-12d3-a456-426614174008', '012345678909', 'Chú'),
('123e4567-e89b-12d3-a456-426614174009', '012345678910', 'Bác');



INSERT INTO NHAN_VIEN (CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH)
VALUES
('012345678901', 'Nguyen Van A', '0901234567', '123', 'Nguyen Hue', 'Phuong 1', 'Quan 1', 'Ho Chi Minh'),
('012345678902', 'Tran Thi B', '0902234567', '456', 'Le Loi', 'Phuong 2', 'Quan 2', 'Ha Noi'),
('012345678903', 'Le Van C', '0903234567', '789', 'Pham Ngu Lao', 'Phuong 3', 'Quan 3', 'Da Nang'),
('012345678904', 'Pham Thi D', '0904234567', '321', 'Hai Ba Trung', 'Phuong 4', 'Quan 4', 'Hue'),
('012345678905', 'Hoang Van E', '0905234567', '654', 'Vo Thi Sau', 'Phuong 5', 'Quan 5', 'Can Tho'),
('012345678906', 'Nguyen Thi F', '0906234567', '987', 'Tran Hung Dao', 'Phuong 6', 'Quan 6', 'Hai Phong'),
('012345678907', 'Tran Van G', '0907234567', '111', 'Ly Thuong Kiet', 'Phuong 7', 'Quan 7', 'Bac Ninh'),
('012345678908', 'Le Thi H', '0908234567', '222', 'Ngo Gia Tu', 'Phuong 8', 'Quan 8', 'Quang Ninh'),
('012345678909', 'Pham Van I', '0909234567', '333', 'Dien Bien Phu', 'Phuong 9', 'Quan 9', 'Thanh Hoa'),
('012345678910', 'Hoang Thi J', '0910234567', '444', 'Nguyen Trai', 'Phuong 10', 'Quan 10', 'Nghe An');

INSERT INTO NHAN_VIEN_Y_TE (CCCD)
VALUES
('012345678901'),
('012345678902'),
('012345678903'),
('012345678904'),
('012345678905'),
('012345678906'),
('012345678907'),
('012345678908'),
('012345678909'),
('012345678910');

INSERT INTO BAC_SI (CCCD, CHUYENKHOA, BANGCAP, CC_HANHNGHE)
VALUES
('012345678901', 'Nhi khoa', 'Bác sĩ Đa khoa', 'CC0001'),
('012345678902', 'Tim mạch', 'Thạc sĩ Y khoa', 'CC0002'),
('012345678903', 'Hô hấp', 'Bác sĩ Đa khoa', 'CC0003'),
('012345678904', 'Ngoại khoa', 'Tiến sĩ Y học', 'CC0004'),
('012345678905', 'Da liễu', 'Bác sĩ Đa khoa', 'CC0005'),
('012345678906', 'Thần kinh', 'Thạc sĩ Y khoa', 'CC0006'),
('012345678907', 'Nội tiết', 'Tiến sĩ Y học', 'CC0007'),
('012345678908', 'Tiêu hóa', 'Bác sĩ Đa khoa', 'CC0008'),
('012345678909', 'Phụ sản', 'Thạc sĩ Y khoa', 'CC0009'),
('012345678910', 'Tai mũi họng', 'Bác sĩ Đa khoa', 'CC0010');

INSERT INTO KY_THUAT_VIEN (CCCD, VITRI, CHUNGCHI)
VALUES
('012345678901', 'Kỹ thuật hình ảnh', 'CCKT001'),
('012345678902', 'Xét nghiệm', 'CCKT002'),
('012345678903', 'Siêu âm', 'CCKT003'),
('012345678904', 'Nội soi', 'CCKT004'),
('012345678905', 'Kỹ thuật phục hồi chức năng', 'CCKT005'),
('012345678906', 'Hóa sinh', 'CCKT006'),
('012345678907', 'Vi sinh', 'CCKT007'),
('012345678908', 'Điện tim', 'CCKT008'),
('012345678909', 'Điện não', 'CCKT009'),
('012345678910', 'Kỹ thuật phân tích', 'CCKT010');

INSERT INTO THU_NGAN (CCCD)
VALUES
('012345678901'),
('012345678902'),
('012345678903'),
('012345678904'),
('012345678905'),
('012345678906'),
('012345678907'),
('012345678908'),
('012345678909'),
('012345678910');


INSERT INTO BUOI_KHAM_BENH (MASO, NGAYKHAM, TAIKHAM, TRANGTHAI, HUYETAP, NHIETDO, CHANDOAN, KETLUAN, MASO_BN, CCCD_BS)
VALUES
('b0011111-1111-1111-1111-111111111111', '2024-12-01 08:00:00', FALSE, 'Hoàn tất', '120/80', 36.8, 'Cảm cúm', 'Nghỉ ngơi, uống thuốc', '123e4567-e89b-12d3-a456-426614174000', '012345678901'),
('b0022222-2222-2222-2222-222222222222', '2024-12-01 09:00:00', TRUE, 'Đang xử lý', '130/85', 37.0, 'Sốt siêu vi', 'Hạ sốt, kiểm tra thêm', '123e4567-e89b-12d3-a456-426614174001', '012345678902'),
('b0033333-3333-3333-3333-333333333333', '2024-12-01 10:00:00', FALSE, 'Hoàn tất', '125/82', 36.5, 'Đau họng', 'Uống kháng sinh', '123e4567-e89b-12d3-a456-426614174002', '012345678903'),
('b0044444-4444-4444-4444-444444444444', '2024-12-02 08:00:00', FALSE, 'Hoàn tất', '118/75', 36.7, 'Viêm phế quản', 'Điều trị thuốc', '123e4567-e89b-12d3-a456-426614174003', '012345678904'),
('b0055555-5555-5555-5555-555555555555', '2024-12-02 09:00:00', TRUE, 'Đang xử lý', '140/90', 37.5, 'Cao huyết áp', 'Điều chỉnh thuốc', '123e4567-e89b-12d3-a456-426614174004', '012345678905'),
('b0066666-6666-6666-6666-666666666666', '2024-12-02 10:00:00', FALSE, 'Hoàn tất', '110/70', 36.4, 'Đau dạ dày', 'Kiểm tra thêm', '123e4567-e89b-12d3-a456-426614174005', '012345678906'),
('b0077777-7777-7777-7777-777777777777', '2024-12-03 08:00:00', FALSE, 'Hoàn tất', '115/78', 36.6, 'Viêm amidan', 'Điều trị kháng sinh', '123e4567-e89b-12d3-a456-426614174006', '012345678907'),
('b0088888-8888-8888-8888-888888888888', '2024-12-03 09:00:00', TRUE, 'Đang xử lý', '125/80', 37.2, 'Sốt phát ban', 'Theo dõi thêm', '123e4567-e89b-12d3-a456-426614174007', '012345678908'),
('b0099999-9999-9999-9999-999999999999', '2024-12-03 10:00:00', FALSE, 'Hoàn tất', '130/85', 36.9, 'Viêm xoang', 'Điều trị thuốc', '123e4567-e89b-12d3-a456-426614174008', '012345678909'),
('b0101010-1010-1010-1010-101010101010', '2024-12-03 11:00:00', FALSE, 'Hoàn tất', '120/80', 36.8, 'Hen suyễn', 'Điều trị lâu dài', '123e4567-e89b-12d3-a456-426614174009', '012345678910');

INSERT INTO TRIEU_CHUNG (MASO_BKB, TRIEUCHUNG)
VALUES
('b0011111-1111-1111-1111-111111111111', 'Ho nhiều'),
('b0011111-1111-1111-1111-111111111111', 'Sốt nhẹ'),
('b0022222-2222-2222-2222-222222222222', 'Đau đầu'),
('b0022222-2222-2222-2222-222222222222', 'Mệt mỏi'),
('b0033333-3333-3333-3333-333333333333', 'Đau họng'),
('b0044444-4444-4444-4444-444444444444', 'Khó thở'),
('b0055555-5555-5555-5555-555555555555', 'Huyết áp cao'),
('b0066666-6666-6666-6666-666666666666', 'Đau bụng'),
('b0077777-7777-7777-7777-777777777777', 'Sưng họng'),
('b0088888-8888-8888-8888-888888888888', 'Phát ban đỏ'),
('b0099999-9999-9999-9999-999999999999', 'Đau đầu'),
('b0101010-1010-1010-1010-101010101010', 'Khó thở khi vận động');

INSERT INTO DICH_VU_KHAM (MADICHVU, TEN, GIACA, MOTA)
VALUES
('a1111111-1111-1111-1111-111111111111', 'Khám tổng quát', 100000, 'Khám toàn diện sức khỏe của bệnh nhân.'),
('a2222222-2222-2222-2222-222222222222', 'Khám tim mạch', 150000, 'Khám bệnh lý tim mạch, đo huyết áp, điện tim.'),
('a3333333-3333-3333-3333-333333333333', 'Khám mắt', 120000, 'Kiểm tra thị lực, đo độ cận, kiểm tra mắt.'),
('a4444444-4444-4444-4444-444444444444', 'Khám da liễu', 130000, 'Khám các vấn đề về da, mụn, dị ứng.'),
('a5555555-5555-5555-5555-555555555555', 'Khám tai mũi họng', 110000, 'Khám bệnh tai mũi họng, tai, mũi, họng.'),
('a6666666-6666-6666-6666-666666666666', 'Khám sản phụ khoa', 160000, 'Khám phụ khoa, kiểm tra sức khỏe sinh sản.'),
('a7777777-7777-7777-7777-777777777777', 'Khám nội khoa', 140000, 'Khám các bệnh lý liên quan đến nội tạng.'),
('a8888888-8888-8888-8888-888888888888', 'Khám nha khoa', 180000, 'Khám răng miệng, làm sạch răng, điều trị nha khoa.'),
('a9999999-9999-9999-9999-999999999999', 'Khám tiêu hóa', 140000, 'Khám các vấn đề về tiêu hóa, dạ dày, ruột.'),
('a1010101-1010-1010-1010-101010101010', 'Khám thần kinh', 170000, 'Khám các vấn đề về thần kinh, não, cột sống.');

INSERT INTO THUOC (MASO, TEN, DANG, GIACA)
VALUES
('b1111111-1111-1111-1111-111111111111', 'Paracetamol', 'Viên', 5000),
('b2222222-2222-2222-2222-222222222222', 'Amoxicillin', 'Viên', 15000),
('b3333333-3333-3333-3333-333333333333', 'Ibuprofen', 'Viên', 20000),
('b4444444-4444-4444-4444-444444444444', 'Aspirin', 'Viên', 8000),
('b5555555-5555-5555-5555-555555555555', 'Loratadine', 'Viên', 12000),
('b6666666-6666-6666-6666-666666666666', 'Cetirizine', 'Viên', 10000),
('b7777777-7777-7777-7777-777777777777', 'Omeprazole', 'Viên', 25000),
('b8888888-8888-8888-8888-888888888888', 'Vitamin C', 'Viên', 10000),
('b9999999-9999-9999-9999-999999999999', 'Ciprofloxacin', 'Viên', 18000),
('b1010101-1010-1010-1010-101010101010', 'Metformin', 'Viên', 22000);




INSERT INTO HOA_DON (MAHOADON, NGAYTAO, TONGTIEN, GHICHU, MASO_BKB, CCCD_PH, CCCD_TN, TRANGTHAI)
VALUES
('a1111111-1111-1111-1111-111111111111', CURRENT_TIMESTAMP, 100000, 'Hóa đơn kiểm tra sức khỏe', 'b0011111-1111-1111-1111-111111111111', '012345678902', '012345678901', 'PENDING'),
('a2222222-2222-2222-2222-222222222222', CURRENT_TIMESTAMP, 150000, 'Hóa đơn điều trị', 'b0022222-2222-2222-2222-222222222222', '012345678902', '012345678902', 'DONE'),
('a3333333-3333-3333-3333-333333333333', CURRENT_TIMESTAMP, 200000, 'Hóa đơn khám bệnh', 'b0033333-3333-3333-3333-333333333333', '012345678903', '012345678903', 'PENDING'),
('a4444444-4444-4444-4444-444444444444', CURRENT_TIMESTAMP, 250000, 'Hóa đơn xét nghiệm', 'b0044444-4444-4444-4444-444444444444', '012345678904', '012345678904', 'DONE'),
('a5555555-5555-5555-5555-555555555555', CURRENT_TIMESTAMP, 120000, 'Hóa đơn tiêm vắc xin', 'b0055555-5555-5555-5555-555555555555', '012345678905', '012345678905', 'PENDING'),
('a6666666-6666-6666-6666-666666666666', CURRENT_TIMESTAMP, 180000, 'Hóa đơn phẫu thuật', 'b0066666-6666-6666-6666-666666666666', '012345678906', '012345678906', 'DONE'),
('a7777777-7777-7777-7777-777777777777', CURRENT_TIMESTAMP, 220000, 'Hóa đơn xét nghiệm máu', 'b0077777-7777-7777-7777-777777777777', '012345678907', '012345678907', 'PENDING'),
('a8888888-8888-8888-8888-888888888888', CURRENT_TIMESTAMP, 140000, 'Hóa đơn kiểm tra mắt', 'b0088888-8888-8888-8888-888888888888', '012345678908', '012345678908', 'DONE'),
('a9999999-9999-9999-9999-999999999999', CURRENT_TIMESTAMP, 170000, 'Hóa đơn kiểm tra tim', 'b0099999-9999-9999-9999-999999999999', '012345678909', '012345678909', 'PENDING'),
('a1010101-1010-1010-1010-101010101010', CURRENT_TIMESTAMP, 300000, 'Hóa đơn khám tổng quát', 'b0101010-1010-1010-1010-101010101010', '012345678910', '012345678910', 'DONE');


INSERT INTO DON_THUOC (MASO_BKB, THOIGIANRADON, NGAYTAIKHAM, LOIDAN, MASO_BN, CCCD_BS)
VALUES
('b0011111-1111-1111-1111-111111111111', '2024-12-01 08:30:00', '2024-12-30', 'Uống thuốc 5 ngày', '123e4567-e89b-12d3-a456-426614174000', '012345678901'),
('b0022222-2222-2222-2222-222222222222', '2024-12-01 09:30:00', '2024-12-30', 'Kiểm tra thêm sau 3 ngày', '123e4567-e89b-12d3-a456-426614174001', '012345678902'),
('b0033333-3333-3333-3333-333333333333', '2024-12-01 10:30:00', '2024-12-30', 'Uống thuốc và theo dõi', '123e4567-e89b-12d3-a456-426614174002', '012345678903'),
('b0044444-4444-4444-4444-444444444444', '2024-12-02 08:30:00', '2024-12-30', 'Uống thuốc kháng sinh', '123e4567-e89b-12d3-a456-426614174003', '012345678904'),
('b0055555-5555-5555-5555-555555555555', '2024-12-02 09:30:00', '2024-12-30', 'Điều chỉnh thuốc', '123e4567-e89b-12d3-a456-426614174004', '012345678905'),
('b0066666-6666-6666-6666-666666666666', '2024-12-02 10:30:00', '2024-12-30', 'Kiểm tra thêm sau điều trị', '123e4567-e89b-12d3-a456-426614174005', '012345678906'),
('b0077777-7777-7777-7777-777777777777', '2024-12-03 08:30:00', '2024-12-30', 'Điều trị bằng thuốc', '123e4567-e89b-12d3-a456-426614174006', '012345678907'),
('b0088888-8888-8888-8888-888888888888', '2024-12-03 09:30:00', '2024-12-30', 'Theo dõi thêm', '123e4567-e89b-12d3-a456-426614174007', '012345678908'),
('b0099999-9999-9999-9999-999999999999', '2024-12-03 10:30:00', '2024-12-30', 'Điều trị thuốc kháng sinh', '123e4567-e89b-12d3-a456-426614174008', '012345678909'),
('b0101010-1010-1010-1010-101010101010', '2024-12-03 11:30:00', '2024-12-30', 'Kiểm tra sau 1 tuần', '123e4567-e89b-12d3-a456-426614174009', '012345678910');

INSERT INTO SO_LUONG_THUOC (MASO_BKB, MASO_TH, SOLUONG, CACHSD)
VALUES
('b0011111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 2, 'Uống mỗi ngày 2 viên'),
('b0011111-1111-1111-1111-111111111111', 'b2222222-2222-2222-2222-222222222222', 1, 'Uống mỗi ngày 1 viên'),
('b0011111-1111-1111-1111-111111111111', 'b3333333-3333-3333-3333-333333333333', 3, 'Uống mỗi ngày 3 viên'),
('b0011111-1111-1111-1111-111111111111', 'b4444444-4444-4444-4444-444444444444', 2, 'Uống mỗi ngày 2 viên'),
('b0011111-1111-1111-1111-111111111111', 'b5555555-5555-5555-5555-555555555555', 1, 'Uống mỗi ngày 1 viên');

INSERT INTO LAN_THUC_HIEN_DICH_VU (NGAYTHUCHIEN, CHUANDOAN, KETLUAN, MASO_BKB, CCCD_NVYT, MADICHVU)
VALUES
(CURRENT_DATE, 'Bệnh nhân bị cảm cúm, sốt cao', 'Cần dùng thuốc hạ sốt, nghỉ ngơi.', 'b0011111-1111-1111-1111-111111111111', '012345678901', 'a1111111-1111-1111-1111-111111111111'),
(CURRENT_DATE, 'Khám tim mạch, huyết áp cao', 'Cần dùng thuốc hạ huyết áp, theo dõi định kỳ.', 'b0011111-1111-1111-1111-111111111111', '012345678902', 'a2222222-2222-2222-2222-222222222222'),
(CURRENT_DATE, 'Khám mắt, thị lực yếu', 'Cần đeo kính, tái khám sau 6 tháng.', 'b0011111-1111-1111-1111-111111111111', '012345678903', 'a3333333-3333-3333-3333-333333333333'),
(CURRENT_DATE, 'Bệnh nhân bị dị ứng da', 'Cần sử dụng kem chống dị ứng, hạn chế tiếp xúc với chất gây dị ứng.', 'b0011111-1111-1111-1111-111111111111', '012345678904', 'a4444444-4444-4444-4444-444444444444'),
(CURRENT_DATE, 'Khám tai mũi họng, viêm họng', 'Cần uống thuốc kháng sinh và súc miệng với nước muối.', 'b0011111-1111-1111-1111-111111111111', '012345678905', 'a5555555-5555-5555-5555-555555555555');



-- Trigger

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



CREATE OR REPLACE FUNCTION CHECK_NGAYTAIKHAM()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.NGAYTAIKHAM < NEW.THOIGIANRADON  THEN
        RAISE EXCEPTION 'Ngày tái khám không hợp lệ! Ngày tái khám phải sau ngày ra đơn.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_ngaytaikham_trigger
BEFORE INSERT OR UPDATE ON DON_THUOC
FOR EACH ROW
EXECUTE FUNCTION check_ngaytaikham();



CREATE OR REPLACE FUNCTION update_tongtiendonthuoc()
RETURNS TRIGGER AS $$
DECLARE
    total_medicine_cost NUMERIC;
    total_service_cost NUMERIC;
    total NUMERIC;
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        -- Calculate costs based on NEW record
        SELECT calculate_giacathuoc(NEW.maso_bkb) INTO total_medicine_cost;
        SELECT calculate_giacadichvu(NEW.maso_bkb) INTO total_service_cost;

        -- Calculate the total cost
        total := COALESCE(total_service_cost, 0) + COALESCE(total_medicine_cost, 0);

        -- Update the tongtien in the HOADON table
        UPDATE HOA_DON
        SET tongtien = total
        WHERE maso_bkb = NEW.maso_bkb;

    ELSIF TG_OP = 'DELETE' THEN
        -- Handle DELETE case using OLD record
        SELECT calculate_giacathuoc(OLD.maso_bkb) INTO total_medicine_cost;
        SELECT calculate_giacadichvu(OLD.maso_bkb) INTO total_service_cost;

        -- Calculate the total cost (likely set to 0 or based on remaining records)
        total := COALESCE(total_service_cost, 0) + COALESCE(total_medicine_cost, 0);

        -- Update the tongtien in the HOADON table
        UPDATE HOA_DON
        SET tongtien = total
        WHERE maso_bkb = OLD.maso_bkb;
    END IF;

    RETURN NULL; -- For BEFORE triggers, no modification is needed for the row
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER update_tongtien_after_service_trigger
after INSERT OR UPDATE OR DELETE ON LAN_THUC_HIEN_DICH_VU
FOR EACH ROW
EXECUTE FUNCTION update_tongtiendonthuoc();

CREATE OR REPLACE TRIGGER update_tongtien_after_medicine_trigger
after INSERT OR UPDATE OR DELETE ON SO_LUONG_THUOC
FOR EACH ROW
EXECUTE FUNCTION update_tongtiendonthuoc();

CREATE OR REPLACE TRIGGER update_tongtien_after_don_thuoc_trigger
BEFORE INSERT ON HOA_DON
FOR EACH ROW
EXECUTE FUNCTION update_tongtiendonthuoc();



-- Function

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





CREATE OR REPLACE FUNCTION get_specific_pills_for_child(child_id_input UUID)
RETURNS TABLE(
    ms UUID, 
    ten VARCHAR(100), 
    dang VARCHAR(50), 
    so_luong NUMERIC,
    thoi_gian_kham DATE,
    thoi_gian_ra_don DATE
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
        slg.soluong::NUMERIC AS so_luong,
        bkb.ngaykham::DATE AS thoi_gian_kham,
        dt.thoigianradon::DATE AS thoi_gian_ra_don
    FROM
        "benh_nhi" bn
    JOIN
        "buoi_kham_benh" bkb ON bn.maso = bkb.maso_bn
    JOIN
        "so_luong_thuoc" slg ON bkb.maso = slg.maso_bkb
    JOIN
        "don_thuoc" dt on dt.maso_bkb = bkb.maso
    JOIN
        "thuoc" t ON slg.maso_th = t.maso
    WHERE
        bn.maso = child_id_input;
END;
$$ LANGUAGE plpgsql;





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
