-- What are the 3 most viewed videos for each country in the “Sports” category for the trending_date = ‘'2021-10-17'’. Order the result by country and the rank,

select country, title, channeltitle , view_count, rk from (
select title, country,channeltitle,view_count, rank() over(partition by country order by country, view_count desc)  as rk from table_youtube_final
where category_title='Sports' and trending_date = '2021-10-17')
where rk <= 3
order by country, rk;