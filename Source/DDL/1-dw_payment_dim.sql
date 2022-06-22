CREATE TABLE dw.dim_date
(
    id serial NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    day integer NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_date
    OWNER to postgres;

----

CREATE TABLE dw.dim_customer
(
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    country character varying(64) NOT NULL,
    city character varying(40) NOT NULL,
    district character varying(20) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_customer
    OWNER to postgres;

----

CREATE TABLE dw.dim_film
(
    id serial NOT NULL,
    title character varying(255) NOT NULL,
    release_year integer NOT NULL,
    rate character varying(10) NOT NULL,
    length smallint NOT NULL,
    language_name character varying(20) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_film
    OWNER to postgres;

----

CREATE TABLE dw.dim_store
(
    id integer NOT NULL,
    manager_firstname character varying(50) NOT NULL,
    manager_lastname character varying(50) NOT NULL,
    country character varying(64) NOT NULL,
    city character varying(40) NOT NULL,
    district character varying(20) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_store
    OWNER to postgres;

----

CREATE TABLE dw.dim_country
(
    id integer NOT NULL,
    country_name character varying(64) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_country
    OWNER to postgres;

----

CREATE TABLE dw.dim_staff
(
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    country character varying(64) NOT NULL,
    city character varying(40) NOT NULL,
    district character varying(20) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS dw.dim_staff
    OWNER to postgres;

----

