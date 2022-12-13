-- Delete the duplicates in “table_youtube_final“ by using “table_youtube_duplicates”.

delete from table_youtube_final where id in (select id from table_youtube_duplicates);