-- In “table_youtube_final”, what is the categoryid of the missing category_title?


select distinct(categoryid) from table_youtube_final where category_title is NULL;