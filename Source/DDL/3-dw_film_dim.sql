CREATE TABLE dw.dim_catrgory
(
    id integer NOT NULL,
    category_name character varying(25) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_catrgory
    OWNER to postgres;

----

CREATE TABLE dw.dim_year
(
    id serial NOT NULL,
    year integer NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_year
    OWNER to postgres;

----

CREATE TABLE dw.dim_language
(
    id integer NOT NULL,
    language_name character varying(20) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_language
    OWNER to postgres;

----

CREATE TABLE dw.dim_rating
(
    id serial NOT NULL,
    type character varying(10) NOT NULL,
    age character varying(10) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_rating
    OWNER to postgres;

---

