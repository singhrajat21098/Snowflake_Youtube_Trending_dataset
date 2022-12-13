-- Part 4

-- let's take this problem one by one

-- Globally which category has most views

select category_title, sum(view_count) as sum_of_views
from table_youtube_final
group by category_title
order by 2 desc;