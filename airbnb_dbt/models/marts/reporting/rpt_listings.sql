{{ config(materialized='view') }}

with listings as (
    select 
        listing_id,
        listing_name,
        host_id ,
        neighbourhood_id ,
        property_type,
        room_type,
        accommodates,
        bathrooms,
        bedrooms,
        price, 
        has_availability ,
        instant_bookable,
        latitude,
        longitude ,
        number_of_reviews , 
        review_scores_rating,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        reviews_per_month 
    from {{ ref('dim_listings') }}
    where is_active = 'True'
) , listings_hosts_neighbourhoods as (
    select 
        l.listing_id,
        l.listing_name,
        n.neighbourhood_name, 
        l.property_type,
        l.room_type,
        l.accommodates,
        l.bathrooms,
        l.bedrooms,
        l.price, 
        l.has_availability ,
        l.instant_bookable,
        l.latitude,
        l.longitude ,
        l.number_of_reviews , 
        l.review_scores_rating,
        l.review_scores_cleanliness,
        l.review_scores_checkin,
        l.review_scores_communication,
        l.review_scores_location,
        l.reviews_per_month ,
        h.host_id,
        h.host_name ,
        h.host_response_time,
        h.host_response_rate,
        h.host_acceptance_rate,
        h.host_is_super_host,
        h.host_identity_verified ,
        h.verified_by_gov_id,
        h.verified_by_email,
        h.verified_by_phone
    from listings l
        inner join {{ ref('dim_hosts') }} h on l.host_id = h.host_id and h.is_active = 'True' 
        inner join {{ ref('dim_neighbourhood') }} n on l.neighbourhood_id = n.neighbourhood_id 
) 
select *
from listings_hosts_neighbourhoods


