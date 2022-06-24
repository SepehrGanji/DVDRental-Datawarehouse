CREATE PROCEDURE dw.fill_fact_yearly_category(from_year INT, to_year INT)
LANGUAGE plpgsql AS
$$
DECLARE
  cur_year INT;
BEGIN
  cur_year := from_year;
  WHILE cur_year <= to_year LOOP
    INSERT INTO dw.fact_yearly_category(category, year, film_count, rate_avg, length_avg)
      SELECT fc.category_id, f.release_year,
      count(f.film_id), avg(f.rate), avg(f.length)
      FROM film_category fc JOIN film f
      ON (fc.film_id = f.film_id)
      WHERE f.release_year = cur_year
      GROUP BY fc.category_id, f.release_year;

    cur_year := cur_year + 1;
  END LOOP;

END

$$
