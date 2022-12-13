-- For each country, year and month (in a single column), which video is the most viewed and what is its likes_ratio (defined as the percentage of likes against view_count) truncated to 2 decimals. Order the result by year_month and country.

select country, date_trunc('MONTH', trending_date) as year_month, title, category_title, view_count,
trunc(likes/nullif(view_count,0)*100,2) as likes_ratio
from (select *,  rank() over(partition by country order by country, view_count desc)  as rk 
from table_youtube_final)
where rk =1
order by year_month, country;