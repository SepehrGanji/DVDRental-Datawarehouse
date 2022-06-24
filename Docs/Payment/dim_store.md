# dim_staff

stores where movies were bought

## Fields

id(integer): surrogate key \
manager_firstname(varchar): first name of the store manager \
manager_lastname(varhcar): last name of the store manager \
country(varchar): the country of the sotre \
city(varchar): the city of the sotre \
district(varchar): the district of the sotre \

## Procedures

### fill_store

this procedures fills the dim_store table. store data come from dvdrental source database. manager first-name and last-name is accessible in staff table in src db due to the fact that a manager is also a staff and in store there is a foreign key to the staff table as manager. district is brought from address table which a foreign key from store table points to. In addition address table has a foreign key to city which in turn has a foreign key to country table. city and country can be accessed by joining these tables. district is also available in address table.
