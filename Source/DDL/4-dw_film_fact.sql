CREATE TABLE dw.fact_trans_film
(
    film integer NOT NULL,
    year integer NOT NULL,
    language integer NOT NULL,
    rating integer NOT NULL,
    rate numeric(5, 2) NOT NULL,
    length smallint NOT NULL
);

ALTER TABLE IF EXISTS dw.fact_trans_film
    OWNER to postgres;

----

CREATE TABLE dw.factless_film_category
(
    film integer NOT NULL,
    category integer NOT NULL
)

ALTER TABLE IF EXISTS dw.factless_film_category
    OWNER to postgres;

---

CREATE TABLE dw.fact_yearly_category
(
    category integer NOT NULL,
    year integer NOT NULL,
    film_count integer NOT NULL,
    rate_avg numeric(5, 2) NOT NULL,
    length_avg numeric(5, 2) NOT NULL
);

ALTER TABLE IF EXISTS dw.fact_yearly_category
    OWNER to postgres;

----

CREATE TABLE dw.fact_acc_category
(
    category integer NOT NULL,
    film_count integer NOT NULL,
    rate_avg numeric(5, 2) NOT NULL,
    length_avg numeric(5, 2) NOT NULL
);

ALTER TABLE IF EXISTS dw.fact_acc_category
    OWNER to postgres;

----

