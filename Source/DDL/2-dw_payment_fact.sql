CREATE TABLE dw.fact_trans_payment
(
    date integer NOT NULL,
    customer integer NOT NULL,
    film integer NOT NULL,
    store integer NOT NULL,
    country integer NOT NULL,
    staff integer NOT NULL,
    amount numeric(10, 2) NOT NULL
);

ALTER TABLE IF EXISTS dw.fact_trans_payment
    OWNER to postgres;

----

CREATE TABLE dw.fact_daily_payment
(
    date integer NOT NULL,
    customer integer NOT NULL,
    store integer NOT NULL,
    amount numeric(10, 2) NOT NULL
);

ALTER TABLE IF EXISTS dw.fact_daily_payment
    OWNER to postgres;

----

CREATE TABLE dw.fact_acc_filmpayment
(
    film integer NOT NULL,
    amount numeric(10, 2) NOT NULL
);

ALTER TABLE IF EXISTS dw.fact_acc_filmpayment
    OWNER to postgres;

----

