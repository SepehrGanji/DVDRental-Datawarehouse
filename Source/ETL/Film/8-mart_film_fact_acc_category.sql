CREATE PROCEDURE dw.fill_fact_acc_category()
LANGUAGE plpgsql AS
$$
BEGIN
  
  TRUNCATE TABLE dw.fact_acc_category;

  INSERT INTO dw.fact_acc_category(category, film_count, rate_avg, length_avg)
    SELECT category, SUM(film_count) film_count,
    SUM(film_count * rate_avg)/SUM(film_count) rate_avg,
    SUM(film_count * length_avg)/SUM(film_count) length_avg
    FROM dw.fact_yearly_category
    GROUP BY category;

END

$$
