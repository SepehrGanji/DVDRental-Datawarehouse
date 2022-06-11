CREATE PROCEDURE fill_payment_dim_date(start_date DATE, number_of_days INT)
LANGUAGE plpgsql AS
$$
DECLARE 
    cur_date DATE;
    i INT;
BEGIN
    i := 0;
    cur_date := start_date;
    WHILE i < number_of_days LOOP
        INSERT INTO dw.dim_date(year, month, day) 
            VALUES (DATE_PART('day', cur_date), DATE_PART('month', cur_date), DATE_PART('year', cur_date));
        i := i + 1;
        cur_date := cur_date + 1;
    END LOOP;
END
$$;

