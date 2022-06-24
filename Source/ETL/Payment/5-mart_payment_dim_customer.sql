CREATE TABLE dw.tmp_customer
(
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    country character varying(64) NOT NULL,
    city character varying(40) NOT NULL,
    district character varying(20) NOT NULL
);

CREATE PROCEDURE dw.fill_customer()
LANGUAGE plpgsql
AS
$$
DECLARE
    num_records integer;

BEGIN
    TRUNCATE TABLE dw.tmp_customer;
    INSERT INTO dw.tmp_customer(id, first_name, last_name, country, city, district)
        SELECT customer.customer_id, customer.first_name, customer.last_name, 
            country.country, city.city, address.district
        FROM customer LEFT JOIN address ON address.address_id = customer.address_id
        JOIN city ON address.city_id = city.city_id
        JOIN country ON city.country_id = country.country_id;

    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_customer', CURRENT_TIMESTAMP, 'data added to tmp table');
    
    IF EXISTS (
        SELECT * FROM dw.tmp_customer WHERE country IS NULL or CITY IS NULL
    ) THEN
        INSERT INTO dw.mart_payment_errors(filling_table, time_occured, description)
            VALUES ('dim_customer', CURRENT_TIMESTAMP, 'some customers do not have city or country');
    END IF;

    TRUNCATE TABLE dw.dim_customer;
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_customer', CURRENT_TIMESTAMP, 'old customer dim truncated');

    INSERT INTO dw.dim_customer(id, first_name, last_name, country, city, district)
        SELECT id, first_name, last_name, country, city, district
        FROM dw.tmp_customer;
        
    SELECT COUNT(*) INTO num_records FROM dw.tmp_customer;
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_customer', CURRENT_TIMESTAMP, num_records || ' data added to dim_customer table');

END
$$

