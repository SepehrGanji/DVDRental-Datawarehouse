# fact_trans_film

Stores each film(transactional)

## Fields

film(integer): film id \
year(integer): release year of the film \
language(integer): language id of the film \
rating(integer): rating id of the film \
rate(numeric): 0-10 rate (generated) of the film \
length(smallint): length of the film

## Procedures

### fill_fact_trans_film

Scans and inserts the films into fact table
