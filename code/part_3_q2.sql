-- For each country, count the number of distinct video with a title containing the word “BTS” and order the result by count in a descending order
select country, count(distinct(title)) as CT
from table_youtube_final
where title like '%BTS%'
group by country
order by CT desc;