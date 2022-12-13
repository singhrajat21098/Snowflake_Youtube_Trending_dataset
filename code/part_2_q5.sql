-- 	 In “table_youtube_final”, which video doesn’t have a channeltitle?
--	 Since, a video could be identified by title, video id and other columns, the entire tuple is printed 

select * from table_youtube_final where channeltitle is NULL;