CREATE PROCEDURE dw.fill_factless_film_category()
LANGUAGE plpgsql AS
$$
BEGIN
  
  TRUNCATE TABLE dw.factless_film_category;

  INSERT INTO dw.factless_film_category(film, category)
    SELECT film_id, category_id FROM film_category;

END

$$
