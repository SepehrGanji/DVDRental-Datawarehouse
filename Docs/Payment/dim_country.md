# dim_country
Is used to identify payment origin country

## Fields
id(integer): surrogate key for couontry
country_name(varchar): the name of the country, limited to 64 characters.


## Procedures
### fill_countries
Truncates current dim_country and adds all of the countries to the dw with their given id.