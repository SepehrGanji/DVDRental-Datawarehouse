CREATE PROCEDURE dw.fill_categories()
LANGUAGE plpgsql AS
$$
BEGIN
	TRUNCATE TABLE dw.dim_catrgory;
	INSERT INTO dw.dim_catrgory
		SELECT category_id, name FROM public.category;

END

$$