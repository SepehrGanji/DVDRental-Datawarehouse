# dim_customer
Customer data

## Fields
id(integer): surrogate key,
first_name(varchar): customer first name,
last_name(varchar): customer last name,
country(varchar): customer country,
city(varchar): customer city,
district(varchar): customer district


## Procedures
### fill_customer
Adds customer records to dim_customer table.
This procedure takes customer first and last name from customer table, which has a foreign key to address table. From address table, district is obtained. address table has a foreign key to city and in turn, city has a foreign key to country. country and city fields are picked up from those tables.