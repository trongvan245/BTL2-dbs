

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







