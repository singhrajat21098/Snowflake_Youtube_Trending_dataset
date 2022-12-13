-- For each country, which category_title has the most distinct videos and what is its percentage (2 decimals) out of the total distinct number of videos of that country? Order the result by category_title and country.

select d_by_country.country, category_title, total_category_video, total_country_video, total_category_video/total_country_video*100 as percentage
from
(select country, count(distinct title) as total_country_video
from table_youtube_final
group by country) d_by_country
inner join 
(select * from
(select country, category_title, total_category_video, rank() over(partition by country order by total_category_video desc) as rk
from (select country, category_title, count(distinct title) as total_category_video
from table_youtube_final
group by country, category_title))
where rk = 1) d_by_category
on d_by_country.country = d_by_category.country
order by category_title, country;