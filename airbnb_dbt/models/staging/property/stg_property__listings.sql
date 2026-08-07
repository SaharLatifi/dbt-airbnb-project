with source as (
    select 
        id as source_listing_id,
        nullif(regexp_replace(trim(name), '\\s+', ' '), '')  as listing_name,
        nullif(regexp_replace(trim(description), '\\s+', ' '), '')  as description,
        host_id as source_host_id,
        last_scraped ,
        initcap(regexp_replace(trim(host_name), '\\s+', ' ')) as host_name,
        host_since , 
        nullif(regexp_replace(trim(host_response_time), '\\s+', ' '), '') as host_response_time,
        try_cast(nullif(regexp_replace(trim(host_response_rate), '[%$]', ''), '') AS number) as host_response_rate,
        try_cast(nullif(regexp_replace(trim(host_acceptance_rate), '[%$]', ''), '') as number) as host_acceptance_rate,
        case 
            when lower(host_is_superhost)  in ('f' , 'false') then 'False'
            when lower(host_is_superhost)  in ('t' , 'true') then 'True'
            else null
        end as host_is_super_host,
        nullif(
            nullif(
                lower(
                    regexp_replace(
                        trim(host_verifications),
                        '\\s+',
                        ' '
                    )
                ),
                ''
            ),
            'none'
        ) as host_verifications ,
        case 
            when lower(host_identity_verified)  in ('f' , 'false') then 'False'
            when lower(host_identity_verified)  in ('t' , 'true') then 'True'
            else null
        end as host_identity_verified,
        trim(regexp_replace(trim(neighbourhood_cleansed), '\\s+', ' ')) as neighbourhood,
        latitude ,
        longitude,
        nullif(initcap(regexp_replace(trim(property_type), '\\s+', ' ')), '') as property_type,
        nullif(initcap(regexp_replace(trim(room_type), '\\s+', ' ')), '') as room_type,
        accommodates ,
        bathrooms,
        bedrooms,
        nullif(initcap(regexp_replace(trim(amenities), '\\s+', ' ')), '') as amenities,
        case 
            when lower(instant_bookable)  in ('f' , 'false') then 'False'
            when lower(instant_bookable)  in ('t' , 'true') then 'True'
            else null
        end as instant_bookable ,
        try_cast(nullif(regexp_replace(trim(price), '[\\$,\\s]+', ''), '') as number(38,2)) as price,
        minimum_nights , 
        case 
            when lower(has_availability)  in ('f' , 'false') then 'False'
            when lower(has_availability)  in ('t' , 'true') then 'True'
            else null
        end as has_availability ,
        number_of_reviews , 
        review_scores_rating,
        review_scores_cleanliness,
        review_scores_location,
        reviews_per_month
    from {{ source('property', 'listings') }}
)
select *
from source 


