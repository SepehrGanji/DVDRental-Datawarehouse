CREATE TABLE dw.mart_payment_errors(
    error_id SERIAL,
    filling_table VARCHAR(64),
    time_occured TIMESTAMP,
    description TEXT
);

CREATE TABLE dw.mart_payment_logs(
    error_id SERIAL,
    filling_table VARCHAR(64),
    time_occured TIMESTAMP,
    description TEXT
)
