# fact_daily_payment
Stores total amount of money each customer has spent in each store each day.

## Fields
date(integer): key of dim_date dimension
customer(integer): key of dim_customer dimension
store(integer): key of dim_store dimension
amount(numeric): amount of payment related 


## Procedures
### fill_fact_daily_payment
Fills daily fact. it gets a from_date and a to_date.
This procedures makes use of transaction fact. Using a loop, iterates over each day, reads daily data, aggregates them and adds them to daily fact.