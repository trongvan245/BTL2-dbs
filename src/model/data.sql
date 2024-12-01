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
)


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
    MASO_BKB UUID NOT NULL,
    CCCD_PH VARCHAR(100) NOT NULL,
    CCCD_TN VARCHAR(100) NOT NULL,
 
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
)


CREATE TABLE SO_LUONG_THUOC (
    MASO_BKB UUID,
    MASO_TH UUID,
    SOLUONG INT NOT NULL CHECK (SOLUONG > 0),
    CACHSD VARCHAR(255) NOT NULL,
    PRIMARY KEY (MASO_BKB, MASO_TH),
    FOREIGN KEY (MASO_BKB) REFERENCES BUOI_KHAM_BENH(MASO),
    FOREIGN KEY (MASO_TH) REFERENCES THUOC(MASO)
)




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



INSERT INTO NHAN_VIEN (CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH) VALUES
('123456789012', 'Nguyễn Văn A', '0987654321', '12A', 'Đường ABC', 'Phường 1', 'Quận 1', 'Hà Nội'),
('234567890123', 'Trần Thị B', '0912345678', '45B', 'Đường DEF', 'Phường 2', 'Quận 2', 'Hà Nội'),
('345678901234', 'Lê Minh C', '0922334455', '78C', 'Đường GHI', 'Phường 3', 'Quận 3', 'Hồ Chí Minh'),
('456789012345', 'Phạm Thị D', '0933445566', '32D', 'Đường JKL', 'Phường 4', 'Quận 4', 'Đà Nẵng'),
('567890123456', 'Vũ Đức E', '0944556677', '65E', 'Đường MNO', 'Phường 5', 'Quận 5', 'Cần Thơ'),
('678901234567', 'Nguyễn Hữu F', '0955667788', '21F', 'Đường PQR', 'Phường 6', 'Quận 6', 'Bình Dương'),
('789012345678', 'Lê Hồng G', '0966778899', '54G', 'Đường STU', 'Phường 7', 'Quận 7', 'Hà Nội'),
('890123456789', 'Trần Quốc H', '0977889900', '87H', 'Đường VWX', 'Phường 8', 'Quận 8', 'Hồ Chí Minh'),
('901234567890', 'Phạm Thị I', '0988990011', '10I', 'Đường YZ', 'Phường 9', 'Quận 9', 'Đà Nẵng'),
('012345678901', 'Vũ Minh J', '0999001122', '23J', 'Đường ABCD', 'Phường 10', 'Quận 10', 'Cần Thơ');


INSERT INTO NHAN_VIEN_Y_TE (CCCD) VALUES
('123456789012'),
('234567890123'),
('345678901234'),
('456789012345'),
('567890123456');

INSERT INTO BAC_SI (CCCD, CHUYENKHOA, BANGCAP, CC_HANHNGHE) VALUES
('123456789012', 'Nội khoa', 'Bác sĩ Y khoa', 'Chứng chỉ hành nghề'),
('234567890123', 'Nhi khoa', 'Bác sĩ Ngoại khoa', 'Chứng chỉ hành nghề'),
('345678901234', 'Tai mũi họng', 'Bác sĩ Sản khoa', 'Chứng chỉ hành nghề')

INSERT INTO KY_THUAT_VIEN (CCCD, VITRI, CHUNGCHI) VALUES
('345678901234', 'Kỹ thuật viên CT', 'Chứng chỉ CT'),
('456789012345', 'Kỹ thuật viên Siêu âm', 'Chứng chỉ Siêu âm'),
('567890123456', 'Kỹ thuật viên Lab', 'Chứng chỉ Lab');



INSERT INTO THU_NGAN (CCCD) VALUES
('678901234567'),
('789012345678'),
('890123456789'),
('901234567890'),
('012345678901')



INSERT INTO PHU_HUYNH (CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH) VALUES
('123456789012', 'Nguyễn Văn A', '0987654321', '12A', 'Đường ABC', 'Phường 1', 'Quận 1', 'Hà Nội'),
('234567890123', 'Trần Thị B', '0912345678', '45B', 'Đường DEF', 'Phường 2', 'Quận 2', 'Hà Nội'),
('345678901234', 'Lê Minh C', '0922334455', '78C', 'Đường GHI', 'Phường 3', 'Quận 3', 'Hồ Chí Minh'),
('456789012345', 'Phạm Thị D', '0933445566', '32D', 'Đường JKL', 'Phường 4', 'Quận 4', 'Đà Nẵng'),
('567890123456', 'Vũ Đức E', '0944556677', '65E', 'Đường MNO', 'Phường 5', 'Quận 5', 'Cần Thơ');


INSERT INTO BENH_NHI (HOTEN, NGAYSINH, GIOITINH, CHIEUCAO, CANNANG, BMI, TIENSUBENH) VALUES
('Nguyễn Thị H', '2010-05-15', 'Nữ', 120, 30, 20.83, 'Không có tiền sử bệnh'),
('Trần Minh K', '2012-08-20', 'Nam', 130, 35, 20.70, 'Tiền sử bệnh tim'),
('Lê Hồng L', '2013-03-10', 'Nữ', 125, 32, 20.00, 'Tiền sử bệnh hen suyễn'),
('Phạm Quốc M', '2011-11-05', 'Nam', 140, 40, 20.41, 'Không có tiền sử bệnh'),
('Vũ Thị N', '2014-06-22', 'Nữ', 110, 28, 22.90, 'Tiền sử bệnh viêm phế quản'),
('Nguyễn Minh P', '2010-12-30', 'Nam', 135, 38, 20.65, 'Không có tiền sử bệnh'),
('Trần Thị Q', '2012-01-10', 'Nữ', 120, 30, 20.83, 'Tiền sử bệnh tiểu đường'),
('Lê Đức R', '2014-04-18', 'Nam', 130, 34, 21.45, 'Không có tiền sử bệnh'),
('Phạm Thị S', '2011-09-25', 'Nữ', 115, 29, 21.71, 'Tiền sử bệnh viêm dạ dày'),
('Vũ Quốc T', '2013-02-14', 'Nam', 125, 33, 21.12, 'Không có tiền sử bệnh');

INSERT INTO DICH_VU_KHAM (TEN, GIACA, MOTA) VALUES
('Khám tổng quát', 500000, 'Khám tổng quát cho trẻ em, tư vấn sức khỏe.'),
('Khám tai mũi họng', 300000, 'Khám và chẩn đoán các bệnh lý tai, mũi, họng.'),
('Khám da liễu', 400000, 'Khám và điều trị các bệnh về da cho trẻ.'),
('Khám tim mạch', 600000, 'Đánh giá sức khỏe tim mạch, đo điện tâm đồ.'),
('Khám tiêu hóa', 550000, 'Khám và tư vấn các vấn đề về tiêu hóa.'),
('Khám hô hấp', 450000, 'Chẩn đoán và điều trị các bệnh lý về hô hấp.'),
('Khám mắt', 250000, 'Khám mắt, kiểm tra thị lực cho trẻ.'),
('Khám dinh dưỡng', 500000, 'Tư vấn chế độ dinh dưỡng phù hợp.'),
('Khám tâm lý', 700000, 'Tư vấn và hỗ trợ tâm lý cho trẻ.'),
('Khám cơ xương khớp', 650000, 'Khám và tư vấn các vấn đề về cơ xương khớp.');

INSERT INTO THUOC (TEN, DANG, GIACA) VALUES
('Paracetamol', 'Viên', 2000),
('Amoxicillin', 'Viên', 1500),
('Vitamin C', 'Viên', 1000),
('Siro ho trẻ em', 'Chai', 45000),
('Thuốc nhỏ mắt', 'Lọ', 20000),
('Dung dịch muối sinh lý', 'Chai', 15000),
('Thuốc kháng sinh', 'Vỉ', 30000),
('Thuốc tiêu hóa', 'Hộp', 50000),
('Dung dịch hạ sốt', 'Ống', 35000),
('Thuốc bổ tổng hợp', 'Gói', 25000);


INSERT INTO BUOI_KHAM_BENH (
    TAIKHAM, 
    TRANGTHAI, 
    HUYETAP, 
    NHIETDO, 
    CHANDOAN, 
    KETLUAN, 
    MASO_BN, 
    CCCD_BS
) 
VALUES (
    TRUE,                  -- Tái khám hay không
    'Đang điều trị',       -- Trạng thái buổi khám
    '120/80',              -- Huyết áp
    37.5,                  -- Nhiệt độ
    'Viêm họng cấp',       -- Chẩn đoán
    'Đề nghị nghỉ ngơi và uống thuốc theo đơn', -- Kết luận
    '123e4567-e89b-12d3-a456-426614174000', -- Mã số bệnh nhi (cần tồn tại trong BENH_NHI)
    '123456789123'         -- CCCD bác sĩ (cần tồn tại trong BAC_SI)
);





-- Tinh tong tien thuoc cho moi dua con cua phu huynh 
SELECT BU.maso FROM GIAM_HO G JOIN BENH_NHI B ON G.MASO_BN = B.MASO JOIN BUOI_KHAM_BENH BU ON B.MASO = BU.MASO_BN WHERE G.CCCD = '123456789012'


