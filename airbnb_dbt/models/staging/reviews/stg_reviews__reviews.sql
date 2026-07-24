with source as (
    select
        listing_id as source_listing_id,
        id as source_review_id,
        date as review_date,
        reviewer_id as source_reviewer_id,
        regexp_replace(trim(reviewer_name), '\\s+', ' ') as reviewer_name,
        regexp_replace(trim(comments), '\\s+', ' ') as  comments
    from 
        {{ source('reviews', 'reviews') }}
    where listing_id is not null and id is not null and date is not null
)
select *
from source


