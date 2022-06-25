CREATE PROCEDURE dw.fill_film_tables_first_time()
LANGUAGE plpgsql
AS
$$
DECLARE
    from_year date;
    to_year date;
BEGIN
    call dw.fill_film_dim_year(2000, 22);
    call dw.fill_categories();
    call dw.fill_languages();
    call dw.fill_ratings();
    call dw.fill_fact_trans_film();
    call dw.fill_factless_film_category();
    call dw.fill_fact_yearly_category(from_year, to_year);
    call dw.fill_fact_acc_category();
END
$$;

CREATE PROCEDURE dw.fill_film_tables()
LANGUAGE plpgsql
AS
$$
DECLARE
    from_year date;
    to_year date;
BEGIN
    call dw.fill_categories();
    call dw.fill_languages();
    call dw.fill_ratings();
    call dw.fill_fact_trans_film();
    call dw.fill_factless_film_category();
    call dw.fill_fact_yearly_category(from_year, to_year);
    call dw.fill_fact_acc_category();
END
$$
