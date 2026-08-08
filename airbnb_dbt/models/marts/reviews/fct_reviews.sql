with reviews as (
   select  
        source_review_id,
        source_listing_id,
        source_reviewer_id,
        review_date,
        comments        , 
    from {{ ref('stg_reviews__reviews')}}
) , reviews_enriched as (
    select 
       {{ dbt_utils.generate_surrogate_key(['source_review_id']) }} as review_id,
        source_review_id ,
        l.listing_id, 
        re.reviewer_id, 
        d.date_id as review_date_id, 
        r.comments,
        {{ classify_sentiment('r.comments') }} as sentiment,        
        current_timestamp as created_at,
        current_timestamp as updated_at 
    from reviews r 
        inner join {{ ref('dim_listings')}} l  on r.source_listing_id = l.source_listing_id --and  r.review_date::timestamp >= l.valid_from
           -- and r.review_date::timestamp < coalesce(l.valid_to,'9999-12-31'::timestamp)
        inner join {{ ref('dim_reviewer')}} re on r.source_reviewer_id = re.source_reviewer_id
        inner join {{ ref('dim_dates')}}     d  on r.review_date = d.date_day 
)
select * 
from reviews_enriched
