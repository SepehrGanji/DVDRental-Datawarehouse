# dim_film
film data

## Fields
id(integer): surrogate key,
title(varchar): film title,
release_year(integer): the year film was released,
rate(smallint): rate of the film from 1 to 10,
length(integer): film length,
language_name(varchar): name of the language, e.g English


## Procedures
### fill_film
Adds films to dim_film.
title, release year, rate and length directly come from film table. However, language_name is obtained by joining film and language table.