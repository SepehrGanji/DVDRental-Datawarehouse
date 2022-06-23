CREATE TABLE dw.fact_daily_payment_last_update(
    last_update date
);


CREATE TABLE dw.tmp_fact_daily_payment_1
(
    date integer,
    customer integer,
    film integer,
    store integer,
    country integer,
    staff integer,
    amount numeric(10, 2)
);

CREATE TABLE dw.tmp_fact_daily_payment_2
(
    customer_id integer,
    store_id integer
);

CREATE TABLE dw.tmp_fact_daily_payment_3
(
    date integer,
    customer integer,
    store integer,
    amount numeric(10, 2)
);

CREATE PROCEDURE dw.fill_fact_daily_payment(from_date DATE, to_date DATE)
LANGUAGE plpgsql
AS
$$
DECLARE
    curr_date DATE;
    curr_date_id INTEGER;
BEGIN
    curr_date := from_date;

     INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('fact_daily_payment', CURRENT_TIMESTAMP, 'started to add records from ' || from_date || ' to ' || to_date);


    INSERT INTO dw.tmp_fact_daily_payment_2
        SELECT dim_customer.id, dim_store.id
        FROM dw.dim_customer CROSS JOIN dw.dim_store;

    WHILE curr_date < to_date LOOP

        INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
            VALUES ('fact_daily_payment', CURRENT_TIMESTAMP, 'adding data of ' || curr_date);

        SELECT id FROM dw.dim_date INTO curr_date_id
        WHERE DATE_PART('day', curr_date) = dim_date.day
            AND DATE_PART('month', curr_date) = dim_date.month
            AND DATE_PART('year', curr_date) = dim_date.year;


        TRUNCATE TABLE dw.tmp_fact_daily_payment_1;
        INSERT INTO dw.tmp_fact_daily_payment_1(date, customer, film, store, country, staff, amount)
            SELECT date, customer, film, store, country, staff, amount
            FROM dw.fact_trans_payment
            WHERE date=curr_date_id;
        
        INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
            VALUES ('fact_daily_payment', CURRENT_TIMESTAMP, 'the related day data added to tmp table');

        TRUNCATE TABLE dw.tmp_fact_daily_payment_3;
        INSERT INTO dw.tmp_fact_daily_payment_3(date, customer, store, amount)
            SELECT curr_date_id, tmp2.customer_id, tmp2.store_id, 0
            FROM dw.tmp_fact_daily_payment_2 as tmp2 LEFT JOIN dw.tmp_fact_daily_payment_1 as tmp1
                ON tmp2.customer_id = tmp1.customer AND tmp2.store_id = tmp1.store
            WHERE tmp1.date IS NULL AND tmp1.customer IS NULL AND tmp1.film IS NULL;

        INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
            VALUES ('fact_daily_payment', CURRENT_TIMESTAMP, 'customers not buying from a store added to tmp table');

        INSERT INTO dw.tmp_fact_daily_payment_3
            SELECT curr_date_id, customer, store, SUM(amount)
            FROM dw.tmp_fact_daily_payment_1
            GROUP BY customer, store;

        INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
            VALUES ('fact_daily_payment', CURRENT_TIMESTAMP, 'customers having transaction added to tmp table');
        
        INSERT INTO dw.fact_daily_payment(date, customer, store, amount)
            SELECT date, customer, store, amount
            FROM dw.tmp_fact_daily_payment_3;

        INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
            VALUES ('fact_daily_payment', CURRENT_TIMESTAMP, 'new data added to fact');

        curr_date := curr_date + INTERVAL '1 day';

    END LOOP;
    TRUNCATE TABLE dw.fact_daily_payment_last_update;
    INSERT INTO dw.fact_daily_payment_last_update(last_update)
        VALUES (to_date);

END
$$