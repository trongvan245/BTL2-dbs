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




