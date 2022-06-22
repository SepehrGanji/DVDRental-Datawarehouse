CREATE PROCEDURE dw.fill_payment_dim_date(start_date DATE, number_of_days INT)
LANGUAGE plpgsql AS
$$
DECLARE 
    cur_date DATE;
    i INT;
BEGIN
    i := 0;
    cur_date := start_date;
    WHILE i < number_of_days LOOP
        INSERT INTO dw.dim_date(day, month, year) 
            VALUES (DATE_PART('day', cur_date), DATE_PART('month', cur_date), DATE_PART('year', cur_date));
        i := i + 1;
        cur_date := cur_date + 1;
    END LOOP;
END
$$;

CREATE PROCEDURE dw.fill_date_from_last_available(number_of_days INT)
LANGUAGE plpgsql AS
$$
DECLARE
    last_available DATE;
BEGIN
    DROP TABLE IF EXISTS tmp1; 
    CREATE TABLE tmp1(
        date_ DATE
    );
    INSERT INTO tmp1
        SELECT TO_DATE(CONCAT(day::text, '-', month::text, '-', year::text), 'DD-MM-YYYY')
        FROM dw.dim_date;
    IF EXISTS (SELECT * FROM tmp1) THEN
        SELECT MAX(date_) INTO last_available FROM tmp1;
    ELSE
        SELECT MIN(payment_date) INTO last_available FROM public.payment;
    END IF;
    last_available := last_available + INTERVAL '1 day';
    CALL fill_payment_dim_date(last_available, number_of_days);
END
$$;
