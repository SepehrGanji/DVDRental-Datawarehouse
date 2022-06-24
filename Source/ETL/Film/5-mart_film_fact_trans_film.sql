CREATE PROCEDURE dw.fill_fact_trans_film()
LANGUAGE plpgsql AS
$$
BEGIN
  
  TRUNCATE TABLE dw.fact_trans_film;

  INSERT INTO dw.fact_trans_film(film, year, language, rating, rate, length)
    SELECT f.film_id, release_year, language_id, 
    dr.id, rate, length FROM film f
    JOIN film_category fc ON
    (f.film_id = fc.film_id)
    JOIN dw.dim_rating dr ON
    (CONCAT(dr.type, dr.age) = f.rating::TEXT);

END

$$
