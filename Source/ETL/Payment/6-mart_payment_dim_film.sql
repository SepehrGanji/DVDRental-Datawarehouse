CREATE TABLE dw.tmp_film
(
    id serial NOT NULL,
    title character varying(255) NOT NULL,
    release_year integer NOT NULL,
    rate character varying(10) NOT NULL,
    length smallint NOT NULL,
    language_name character varying(20) NOT NULL
);

CREATE PROCEDURE dw.fill_film()
LANGUAGE plpgsql
AS
$$
DECLARE
    num_records integer;

BEGIN
    TRUNCATE TABLE dw.tmp_film;
    INSERT INTO dw.tmp_film(id, title, release_year, rate, length, language_name)
        SELECT film.film_id, film.title, film.release_year, film.rate, film.length, language.name
        FROM film LEFT JOIN language ON language.language_id = film.language_id;

    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_film', CURRENT_TIMESTAMP, 'data added to tmp table');

    IF EXISTS (
        SELECT * FROM dw.tmp_film WHERE language_name IS NULL
    ) THEN
        INSERT INTO dw.mart_payment_errors(filling_table, time_occured, description)
            VALUES ('dim_film', CURRENT_TIMESTAMP, 'some films do not have language');
    END IF;

    TRUNCATE TABLE dw.dim_film;
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_film', CURRENT_TIMESTAMP, 'old film dim truncated');

    INSERT INTO dw.dim_film(id, title, release_year, rate, length, language_name)
        SELECT id, title, release_year, rate, length, language_name
        FROM dw.tmp_film;
        
    SELECT COUNT(*) INTO num_records FROM dw.tmp_film;
    INSERT INTO dw.mart_payment_logs(filling_table, time_occured, description)
        VALUES ('dim_film', CURRENT_TIMESTAMP, num_records || ' data added to dim_film table');

END
$$

