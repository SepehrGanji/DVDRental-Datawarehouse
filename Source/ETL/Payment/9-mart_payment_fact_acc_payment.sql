CREATE TABLE dw.fact_acc_filmpayment_last_update(
    last_update date
);

CREATE TABLE dw.tmp_fact_acc_filmpayment_1(
    film_id integer,
    amount numeric(10, 2)
);

CREATE TABLE dw.tmp_fact_acc_filmpayment_2(
    film_id integer,
    amount numeric(10, 2)
);


CREATE PROCEDURE dw.fill_fact_acc_payment()
LANGUAGE plpgsql
AS
$$
DECLARE
    last_update_ date;
    last_update_id integer;
BEGIN
    SELECT last_update + INTERVAL '1 day' INTO last_update_
    FROM dw.fact_acc_filmpayment_last_update;

    IF last_update_ IS NULL THEN
        SELECT MIN(payment_date)::date INTO last_update_ FROM payment;
    END IF;


    -- SELECT id into last_update_id FROM dw.dim_date
    -- WHERE DATE_PART('day', last_update_) = dim_date.day 
    --     AND DATE_PART('month', last_update_) = dim_date.month 
    --     AND DATE_PART('year', last_update_) = dim_date.year;
    
    -- IF last_update_id IS NULL THEN
    --     INSERT INTO dw.mart_payment_errors(filling_table, time_occured, description)
    --         VALUES ('fact_acc_filmpayment', CURRENT_TIMESTAMP, 'last update date unavailable');
    --     RETURN;
    -- END IF;

    TRUNCATE TABLE dw.tmp_fact_acc_filmpayment_1;
    INSERT INTO dw.tmp_fact_acc_filmpayment_1
        SELECT inventory.film_id, SUM(payment.amount)
            FROM payment JOIN rental ON payment.rental_id = rental.rental_id
            JOIN inventory ON inventory.inventory_id = rental.inventory_id
            WHERE payment.payment_date >= last_update_
            GROUP BY inventory.film_id;
    
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('fact_acc_filmpayment', CURRENT_TIMESTAMP, 'new movie payments added to tmp table');

    TRUNCATE TABLE dw.tmp_fact_acc_filmpayment_2;
    INSERT INTO dw.tmp_fact_acc_filmpayment_2(film_id, amount)
        SELECT COALESCE(fact.film, tmp1.film_id), COALESCE(fact.amount, 0) + COALESCE(tmp1.amount, 0)
            FROM dw.fact_acc_filmpayment as fact FULL OUTER JOIN dw.tmp_fact_acc_filmpayment_1 AS tmp1
            ON tmp1.film_id = fact.film;


    TRUNCATE TABLE dw.fact_acc_filmpayment;
    INSERT INTO dw.fact_acc_filmpayment(film, amount)
        SELECT film_id, amount FROM dw.tmp_fact_acc_filmpayment_2;

    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('fact_acc_filmpayment', CURRENT_TIMESTAMP, 'fact table updated');

    TRUNCATE TABLE dw.fact_acc_filmpayment_last_update;
    INSERT INTO dw.fact_acc_filmpayment_last_update(last_update)
        SELECT MAX(payment_date)::date FROM payment; 

END
$$