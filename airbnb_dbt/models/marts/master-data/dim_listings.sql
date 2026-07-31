with listing_scd_cols as (
    select  
        source_listing_id ,
        listing_name,
        source_host_id ,
        neighbourhood , 
        property_type,
        room_type,
        accommodates,
        bathrooms,
        bedrooms,
        instant_bookable,
        amenities,
        price,
        minimum_nights,
        has_availability,
        number_of_reviews,
        review_scores_rating,
        review_scores_cleanliness,
        review_scores_location, 
        dbt_valid_from  as valid_from,
        dbt_valid_to    as valid_to,
        iff(dbt_valid_to is null , True , False) as is_active
    from {{ ref('scd_property__listings') }}
     )   , curr_listings as (
    select 
        source_listing_id,
        description,
        latitude ,
        longitude ,
        last_scraped
    from {{ ref('stg_property__listings') }}
) ,  final_listings as (
    select 
       {{ dbt_utils.generate_surrogate_key(['scd.source_listing_id']) }} as listing_id,
       scd.source_listing_id  ,
       listing_name,
       description,
       h.host_id ,
       n.neighbourhood_id ,
       scd.property_type,
       scd.room_type,
       scd.accommodates,
       scd.bathrooms,
       scd.bedrooms,
       scd.instant_bookable,
       cl.latitude,
       cl.longitude,
       current_timestamp as created_at,
       current_timestamp as updated_at
    from listing_scd_cols scd
        inner join curr_listings as cl on scd.source_listing_id = cl.source_listing_id
        inner join {{ ref('dim_hosts') }} as h on scd.source_host_id = h.source_host_id   and cl.last_scraped >= h.valid_from  and cl.last_scraped < coalesce( h.valid_to,'9999-12-31'::timestamp )  
        inner join {{ ref('dim_neighbourhood')}} n on  scd.neighbourhood = n.neighbourhood_name
)
select *
from final_listings 
