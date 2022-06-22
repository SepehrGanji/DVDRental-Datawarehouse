CREATE TABLE dw.tmp_store(
    id integer NOT NULL,
    manager_firstname character varying(50) NOT NULL,
    manager_lastname character varying(50) NOT NULL,
    country character varying(64) NOT NULL,
    city character varying(40) NOT NULL,
    district character varying(20) NOT NULL
);


CREATE PROCEDURE dw.fill_sotre()
LANGUAGE plpgsql
AS
$$
DECLARE
    num_records integer;

BEGIN
    TRUNCATE TABLE dw.tmp_store;
    INSERT INTO dw.tmp_store(id, manager_firstname, manager_lastname, country, city, district)
        SELECT store.store_id, staff.first_name, 
            staff.last_name, country.country, city.city, address.district
        FROM store LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
        JOIN address ON address.address_id = store.address_id
        JOIN city ON address.city_id = city.city_id
        JOIN country ON country.country_id = city.country_id;
    
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_store', CURRENT_TIMESTAMP, 'data added to tmp table');
    
    IF EXISTS (
        SELECT * FROM dw.tmp_store WHERE country IS NULL or CITY IS NULL or manager_firstname is NULL
    ) THEN
        INSERT INTO dw.mart_payment_errors(filling_table, time_occured, description)
            VALUES ('dim_store', CURRENT_TIMESTAMP, 'some stores do not have city or country or manager data');
    END IF;

    TRUNCATE TABLE dw.dim_store;
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_store', CURRENT_TIMESTAMP, 'old store dim truncated');

    INSERT INTO dw.dim_store(id, manager_firstname, manager_lastname, country, city, district)
        SELECT id, manager_firstname, manager_lastname, country, city, district
        FROM dw.tmp_store;
        
    SELECT COUNT(*) INTO num_records FROM dw.tmp_store;
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_store', CURRENT_TIMESTAMP, num_records || ' data added to dim_store table');


END

$$