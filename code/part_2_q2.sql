-- In “table_youtube_category” which category_title only appears in one country?

select category_title, categoryid from table_youtube_category group by category_title, categoryid having count(country)=1;