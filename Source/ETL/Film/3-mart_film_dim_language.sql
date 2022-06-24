CREATE PROCEDURE dw.fill_languages()
LANGUAGE plpgsql AS
$$
BEGIN
	TRUNCATE TABLE dw.dim_language;
	INSERT INTO dw.dim_language
		SELECT language_id, name FROM public.language;

END

$$