{{ config(materialized='view')  }}

with source as (
    select 
        source_listing_id,
        listing_name,
        source_host_id,
        to_timestamp_ntz(last_scraped) as last_scraped,
        neighbourhood,
        property_type,
        room_type,
        accommodates ,
        bathrooms,
        bedrooms,
        amenities,
        instant_bookable ,
        price ,
        minimum_nights , 
        has_availability ,
        number_of_reviews , 
        review_scores_rating,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        reviews_per_month
    from {{ ref('stg_property__listings') }} 
)
select *
from source  


