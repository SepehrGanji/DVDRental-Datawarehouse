# dim_staff

stores where movies were bought

## Fields

date(integer): key of dim_date dimension \
customer(integer): key of dim_customer dimenstion \
film (integer): key of dim_film dimenstionr \
store (integer): key of dim_store dimenstion \
country (integer): key of dim_country dimenstion \
staff (integer): key of dim_staff dimenstion \
amount (numeric): the amount of payment

## Procedures

### fill_fact_trans_payment

adds new payment records to fact_trans_payment.
This procedure, first gets all of the payment records. then finds out which records are unavailable in fact table, then adds them to fact table. Payment data is read from payment table.
