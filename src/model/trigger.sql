
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


CREATE OR REPLACE TRIGGER update_tongtien_after_don_thuoc_trigger
BEFORE INSERT ON HOA_DON
FOR EACH ROW
EXECUTE FUNCTION update_tongtiendonthuoc();


CREATE OR REPLACE FUNCTION validate_phuhuynh()
RETURNS TRIGGER AS $$
DECLARE
    valid_phuhuynh BOOLEAN;
BEGIN
    -- Check if the phuhuynh exists in get_phuhuynh_from_hoadon
    SELECT EXISTS (
        SELECT 1
        FROM get_phuhuynh_from_hoadon(NEW.mahoadon)
        WHERE cccd_ph = NEW.phuhuynh
    )
    INTO valid_phuhuynh;

    -- If not valid, raise an error
    IF NOT valid_phuhuynh THEN
        RAISE EXCEPTION 'Invalid phuhuynh: % does not exist for mahoadon: %',
            NEW.phuhuynh, NEW.mahoadon;
    END IF;

    -- Proceed with the insert
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER get_phuhuynh_from_hoadon_trigger
BEFORE INSERT ON HOA_DON
FOR EACH ROW
EXECUTE FUNCTION validate_phuhuynh();