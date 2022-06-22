CREATE TABLE IF NOT EXISTS dw.staff_tmp(
    staff_tmp_id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(64),
    city VARCHAR(40),
    district VARCHAR(20)
);

CREATE PROCEDURE dw.fill_staff()
LANGUAGE plpgsql
AS
$$
BEGIN
    TRUNCATE TABLE dw.staff_tmp;
    INSERT INTO dw.staff_tmp(staff_tmp_id, first_name, last_name, country, city, district)
        SELECT staff.staff_id, staff.first_name, staff.
            last_name, country.country, city.city, address.district
        FROM public.staff 
        LEFT JOIN public.address ON staff.address_id = address.address_id
        JOIN public.city ON city.city_id = address.city_id
        JOIN public.country ON city.country_id = country.country_id;

    IF EXISTS (
        SELECT * FROM dw.staff_tmp
        WHERE country IS NULL or city IS NULL
    ) THEN
        -- IF THERE IS NO COUNTRY OR CITY FOR STAFF ADD AN ERROR LOG
        INSERT INTO dw.mart_payment_errors(filling_table, time_occured, description)
            VALUES ('dim_staff', CURRENT_TIMESTAMP, 'some of staff do not have city or country');

    END IF;
    TRUNCATE TABLE dw.dim_staff;
    INSERT INTO dw.dim_staff(id, first_name, last_name, country, city, district)
        SELECT staff_tmp_id, first_name, last_name, country, city, district FROM dw.staff_tmp;

END
$$