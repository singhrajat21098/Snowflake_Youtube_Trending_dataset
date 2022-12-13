-- Create a new table called “table_youtube_duplicates”  containing only the “bad” duplicates by using the row_number() function.

create or replace table table_youtube_duplicates as
select * from
    (select *, row_number() over(partition by video_id, country, trending_date order by view_count desc) RowNum 
    from table_youtube_final)
where RowNum > 1;

alter table table_youtube_duplicates
drop column RowNum;