-- In “table_youtube_category” which category_title has duplicates if we don’t take into account the categoryid?


select category_title from table_youtube_category group by category_title having count(category_title) >1;