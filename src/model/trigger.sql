
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

SELECT * FROM BENH_NHI;

--
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
CREATE OR REPLACE FUNCTION update_tongtiendonthuoc()
RETURNS TRIGGER AS $$
DECLARE
    total_service_cost BIGINT;
    total_medicine_cost BIGINT;
    total BIGINT;
BEGIN
    -- Get the total medicine cost
    SELECT calculate_giacathuoc(NEW.maso_bkb) INTO total_medicine_cost;

    -- Get the total service cost
    SELECT calculate_giacadichvu(NEW.maso_bkb) INTO total_service_cost;

    -- Calculate the total cost
    total := COALESCE(total_service_cost, 0) + COALESCE(total_medicine_cost, 0);

    -- Set the TONGTIEN column in the NEW record
    NEW.tongtien := total;

    UPDATE HOA_DON
    SET TONGTIEN = total
    WHERE MASO_BKB = NEW.MASO_BKB;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_tongtiendonthuoc_trigger
BEFORE INSERT OR UPDATE ON HOA_DON
FOR EACH ROW
EXECUTE FUNCTION check_tongtiendonthuoc();

CREATE OR REPLACE TRIGGER update_tongtien_after_service_trigger
AFTER INSERT OR UPDATE ON LAN_THUC_HIEN_DICH_VU
FOR EACH ROW
EXECUTE FUNCTION check_tongtiendonthuoc();

CREATE OR REPLACE TRIGGER update_tongtien_after_medicine_trigger
AFTER INSERT OR UPDATE ON SO_LUONG_THUOC
FOR EACH ROW
EXECUTE FUNCTION check_tongtiendonthuoc();
