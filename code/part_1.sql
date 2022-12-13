-- Create a new database
CREATE DATABASE bde_at_1;

-- Use the newly created database
USE DATABASE bde_at_1;

-- Link the Azure Blob storage to Snowflake
CREATE STORAGE INTEGRATION azure_bde_at_1
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = 'e8911c26-cf9f-4a9c-878e-527807be8791'
  STORAGE_ALLOWED_LOCATIONS = ('azure://rajatsinghuts.blob.core.windows.net/bde-at-1');
  
  
-- Describe the storage integration with Azure Blob 
DESC STORAGE INTEGRATION azure_bde_at_1; 
  
  
-- Create a staging area 
CREATE OR REPLACE STAGE stage_bde_at_1
STORAGE_INTEGRATION = azure_bde_at_1
URL='azure://rajatsinghuts.blob.core.windows.net/bde-at-1'
;

-- List files in BDE
list @stage_bde_at_1;

-- Creating a new file format 
CREATE OR REPLACE FILE FORMAT file_format_csv 
TYPE = 'CSV' 
FIELD_DELIMITER = ',' 
SKIP_HEADER = 1
NULL_IF = ('\\N', 'NULL', 'NUL', '')
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
;

-- Create a new external table for youtube trending csv file
create or replace external table ex_table_youtube_trending
(
    video_id varchar as (value:c1::varchar),
    title varchar as (value:c2::varchar),
    publishedat timestamp as (value:c3::timestamp),
    channelid varchar as (value:c4:: varchar),
    channeltitle varchar as (value:c5:: varchar),
    categoryid int as (value:c6:: int),
    trending_date date as (value:c7:: date),
    view_count double as (value:c8:: double),
    likes double as (value:c9:: double),
    dislikes double as (value:c10:: double),
    comment_count double as (value:c11:: double),
    comments_disabled boolean as (value:c12:: boolean)
)
with location = @stage_bde_at_1
file_format = file_format_csv
pattern = '.*[.]csv';

-- Creating new table from external table ex_table_youtube_trending
create or replace table table_youtube_trending as 
select 
video_id, title, publishedat, channelid, channeltitle, categoryid, trending_date, view_count, likes, dislikes, comment_count,comments_disabled,
split_part(metadata$filename, '_', 1)::varchar as country
from ex_table_youtube_trending;




-- Creating new external table from JSON file
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_category
WITH LOCATION = @stage_bde_at_1
FILE_FORMAT = (TYPE=JSON)
PATTERN = '.*[.]json';

-- Creating a new table for categories using external table file for category json
create or replace table table_youtube_category as 
select l.value:id::int as categoryid, l.value:snippet:title::varchar as category_title,split_part(metadata$filename, '_', 1)::varchar as country 
from ex_table_youtube_category, lateral flatten(input => VALUE:items) l;


-- Creating final table by joining categories with trending tables.
create or replace table table_youtube_final as
select 
uuid_string() as id,
yt.video_id,
yt.title,
yt.publishedat,
yt.channelid,
yt.channeltitle,
yt.categoryid,
yc.category_title,
yt.trending_date,
yt.view_count,
yt.likes,
yt.dislikes,
yt.comment_count,
yt.comments_disabled,
yt.country
from table_youtube_category yc 
right outer join table_youtube_trending yt 
on yt.categoryid = yc.categoryid and yc.country = yt.country;

