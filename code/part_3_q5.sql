-- Which channeltitle has produced the most distinct videos and what is this number?

select channeltitle, count(distinct(title)) as number
from table_youtube_final
group by channeltitle
order by 2 desc
limit 1;