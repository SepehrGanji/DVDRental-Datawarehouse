CREATE TABLE dw.tmp_rating
(
    rating character varying(50) NOT NULL
);

CREATE PROCEDURE dw.fill_ratings()
LANGUAGE plpgsql AS
$$
BEGIN
  TRUNCATE TABLE dw.tmp_rating;
	TRUNCATE TABLE dw.dim_rating;

	INSERT INTO dw.tmp_rating
	  SELECT DISTINCT rating FROM public.film;

  INSERT INTO dw.dim_rating
    SELECT nextval('dw.dim_rating_id_seq'), SPLIT_PART(rating::TEXT, '-', 1),
    SPLIT_PART(rating::TEXT, '-', 2)
    FROM dw.tmp_rating;

END

$$
