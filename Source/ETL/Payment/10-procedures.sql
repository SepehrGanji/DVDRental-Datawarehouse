CREATE PROCEDURE dw.fill_tables_first_time()
LANGUAGE plpgsql
AS
$$
DECLARE
    from_date date;
    to_date date;

BEGIN
    SELECT MIN(payment_date)::date INTO from_date FROM payment;
    SELECT MAX(payment_date)::date INTO to_date FROM payment;

    call dw.fill_date_from_last_available(100000);
    call dw.fill_countries();
    call dw.fill_staff();
    call dw.fill_sotre();
    call dw.fill_customer();
    call dw.fill_film();
    call dw.fill_fact_trans_payment();
    call dw.fill_fact_daily_payment(from_date, to_date);
    call dw.fill_fact_acc_payment();
END
$$;

CREATE PROCEDURE dw.fill_tables()
LANGUAGE plpgsql
AS
$$
DECLARE
    from_date date;
    to_date date;

BEGIN
    SELECT last_update INTO from_date FROM dw.fact_daily_payment_last_update;
    SELECT MAX(payment_date)::date INTO to_date FROM payment;

    call dw.fill_countries();
    call dw.fill_staff();
    call dw.fill_sotre();
    call dw.fill_customer();
    call dw.fill_film();
    call dw.fill_fact_trans_payment();
    call dw.fill_fact_daily_payment(from_date, to_date);
    call dw.fill_fact_acc_payment();
END
$$