# date
Dates of payments

## fields
year, month, day


## Procedures 

### fill_payment_dim_date Procedure
This procedure gets start and end dates, adds a recored from start_date to end_date.

### fill_date_from_last_available Procedure
This procedure gets the number of days and adds as many as records in dim_date. If there already exist some records in dim_date, it starts from last available day plus one day, otherwise, it uses the first date available in data source.
