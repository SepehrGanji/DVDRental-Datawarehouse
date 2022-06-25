# fact_yearly_category

Yearly fact based on categories

## Fields

category(int): category id \
year(int): the target year \
film_count(int): number of films \
rate_avg(numeric): the average rate of films \
length_avg(numeric): the average length of films

## Procedures

### fill_fact_yearly_category

Gets from and to year and fills the fatcs by joinig film_category and film on film_id, count and avg over required films and group by category and the specified year.
