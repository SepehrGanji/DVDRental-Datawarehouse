CREATE PROCEDURE dw.fill_film_dim_year(start_year INT, number_of_years INT)
LANGUAGE plpgsql AS
$$
DECLARE 
    cur_year INT;
    i INT;
BEGIN
    i := 0;
    cur_year := start_year;
    WHILE i < number_of_years LOOP
        INSERT INTO dw.dim_year(year) 
            VALUES (cur_year);
        i := i + 1;
        cur_year := cur_year + 1;
    END LOOP;
END
$$;

