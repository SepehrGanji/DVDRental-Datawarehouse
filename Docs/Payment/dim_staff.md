# dim_staff
staff working at movie rental shop

## Fields
id(integer): surrogate key
first_name(varchar): first name of the staff
last_name(varhcar): last name of the staff
country(varchar): the country where staff live
city(varchar): the city where staff live
district(varchar): the district where staff live

## Procedures
### fill_staff
this procedures fills the staff. staff data come from dvdrental source database. first name and last name is accessible in staff table in src db. district is brought from address table which a foreign key from staff table points to. In addition address table has a foreign key to city which in turn has a foreign key to country table. city and country can be accessed by joining these tables. district is also available in address table. 
