{{ config(materialized='view') }}

with reviews as (
    select 
        review_id,
        r.listing_id, 
        r.reviewer_id, 
        d.date_day as review_date,
       -- r.comments,
        r.sentiment        
 
from {{ ref('fct_reviews') }}   r
    inner join {{ ref('dim_dates') }} d on r.review_date_id = d.date_id
)
select *
from reviews
