# fact_acc_filmpayment
Stores total amount of money a film could sell.

## Fields
film_id(integer): key to dim_film dimension
amount(numeric): total amount of money spent for the film


## Procedures
### fill_fact_acc_filmpayment
Fills acc fact.
This procedure gets the last date when acc was updated, calculates sum of payments from then and adds the result to the priviously calculated amount in this table.