/*Generate a report that provides an overview of the number of stores in each city.*/
SELECT city,count(city) as store_count FROM retail_events_db.dim_stores
group by city
order by store_count desc
;