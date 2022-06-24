CREATE TABLE dw.tmp_fact_trans_payment_1
(
    date integer,
    customer integer,
    film integer,
    store integer,
    country integer,
    staff integer,
    amount numeric(10, 2)
);


CREATE TABLE dw.tmp_fact_trans_payment_2
(
    date integer,
    customer integer,
    film integer,
    store integer,
    country integer,
    staff integer,
    amount numeric(10, 2)
);


CREATE PROCEDURE dw.fill_fact_trans_payment()
LANGUAGE plpgsql
AS
$$
DECLARE
    num_records integer;
BEGIN
    TRUNCATE TABLE dw.tmp_fact_trans_payment_1;
    INSERT INTO dw.tmp_fact_trans_payment_1(date, customer, film, store, country, staff, amount)
        SELECT dim_date.id, payment.customer_id, inventory.film_id, staff.store_id,
            country.country_id, staff.staff_id, payment.amount
        FROM payment LEFT JOIN rental ON rental.rental_id = payment.rental_id
        JOIN inventory ON inventory.inventory_id = rental.inventory_id
        JOIN staff ON payment.staff_id = staff.staff_id
        JOIN address ON staff.address_id = address.address_id 
        JOIN city ON city.city_id = address.city_id
        JOIN country ON city.country_id = country.country_id
        JOIN dw.dim_date ON dim_date.year = DATE_PART('year', payment.payment_date)
            AND dim_date.month = DATE_PART('month', payment_date)
            AND dim_date.day = DATE_PART('day', payment_date);
    
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('fact_trans_payment', CURRENT_TIMESTAMP, 'all data added to tmp table');

    IF EXISTS (
        SELECT * FROM dw.tmp_fact_trans_payment_1 WHERE date IS NULL
            OR film IS NULL
            OR store IS NULL
            OR staff IS NULL
    ) THEN
        INSERT INTO dw.mart_payment_errors(filling_table, time_occured, description)
            VALUES ('fact_trans_payment', CURRENT_TIMESTAMP, 'date or film or store or staff unavailable for a payment');
    END IF;



    TRUNCATE TABLE dw.tmp_fact_trans_payment_2;
    INSERT INTO dw.tmp_fact_trans_payment_2
        SELECT tmp1.date, tmp1.customer, tmp1.film, tmp1.store, tmp1.country, tmp1.staff, tmp1.amount
        FROM dw.tmp_fact_trans_payment_1 as tmp1  LEFT JOIN dw.fact_trans_payment
            ON fact_trans_payment.date = tmp1.date
            AND fact_trans_payment.customer = tmp1.customer
            AND fact_trans_payment.film = tmp1.film
            AND fact_trans_payment.amount = tmp1.amount
        WHERE fact_trans_payment.date IS NULL 
            OR fact_trans_payment.customer IS NULL
            OR fact_trans_payment.amount IS NULL;
    
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('fact_trans_payment', CURRENT_TIMESTAMP, 'new data which are not currently available in fact added to tmp table');

    INSERT INTO dw.fact_trans_payment(date, customer, film, store, country, staff, amount)
        SELECT date, customer, film, store, country, staff, amount
        FROM dw.tmp_fact_trans_payment_2;
    
    SELECT COUNT(*) INTO num_records from dw.tmp_fact_trans_payment_2;

    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('fact_trans_payment', CURRENT_TIMESTAMP, num_records || ' records added to fact table');

END
$$