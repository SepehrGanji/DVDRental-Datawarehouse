CREATE PROCEDURE dw.fill_countries()
LANGUAGE plpgsql AS
$$
BEGIN
	TRUNCATE TABLE dw.dim_country;
	INSERT INTO dw.dim_country
		SELECT country_id, country from public.country;

END

$$