
-- After Music and Entertainment, Gaming has the most number of views.

-- but which is the most popular category in every country

-- Count Top 2 most popular categories

select category_title, count(*) as sum_of_views from
    (select category_title, sum(view_count) as total_view, country, rank() over(partition by country order by total_view desc) as rank_in_country
    from table_youtube_final
    where category_title not in ('Music', 'Entertainment') 
    group by category_title, country)
where rank_in_country <=2
group by category_title;