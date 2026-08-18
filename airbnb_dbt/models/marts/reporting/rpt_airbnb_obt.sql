with listings_data as (
    select 
        listing_id, 
        --listing_name,
        neighbourhood_name, 
        property_type,
      --  room_type,
      --  accommodates,
       -- bathrooms,
       -- bedrooms,
        price, 
        has_availability ,
        --instant_bookable,
        latitude,
        longitude ,
        number_of_reviews , 
        review_scores_rating,
        --review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        --review_scores_location,
        reviews_per_month ,
        host_id,
        --host_name ,
        --host_response_time,
        host_response_rate,
        host_acceptance_rate,
        host_is_super_host,
        host_identity_verified ,
        verified_by_gov_id,
        verified_by_email,
        verified_by_phone
      from {{ ref('rpt_listings')}} 
) , listings_with_reviews as 
(
    select 
        l.* , 
        review_id,
        review_date,
        sentiment 
    from listings_data  l 
    left outer join {{ ref('rpt_reviews') }}  r on l.listing_id = r.listing_id
) 
select *
from listings_with_reviews
