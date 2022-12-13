-- Update the table_youtube_final to replace the NULL values in category_title with the answer from the previous question.

update table_youtube_final 
    set category_title = 'Nonprofits & Activism'
    where category_title is NULL and categoryid = 29;