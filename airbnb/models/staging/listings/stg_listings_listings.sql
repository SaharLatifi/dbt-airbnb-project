with source as 
(
    select 
        id ,
        name ,
        neighbourhood_cleansed,
        latitude,
        longitude,
        property_type,
        room_type,
        accommodates,
        bathrooms,
        bedrooms,
        beds,
        amenities,
        price,
        has_availability,
        number_of_reviews,
        first_review,
        last_review,
        review_scores_rating,
        review_scores_cleanliness,
        review_scores_accuracy,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value,
        instant_bookable,
        host_id,
        host_name,
        host_since,
        host_location,
        host_about,
        host_response_time,
        host_response_rate,
        host_acceptance_rate,
        host_is_superhost,
        host_listings_count,
        host_total_listings_count,
        host_verifications ,
        host_identity_verified
    
from {{ source('listings','listings')}}
) ,  cleaned as 
(    select 
        cast(id as integer)  as listing_id,
        initcap(trim(nullif(nullif(nullif(trim(name),'N/A'),'Unknown'),'Test'))) as listing_name,
        nullif(nullif(nullif(trim(neighbourhood_cleansed), 'N/A'),'UNKNOWN'),'--')as neighbourhood , 
        cast(latitude as float) as latitude,
        cast(longitude as float) as longitude,
        lower(trim(property_type)) as property_type,
        lower(trim(room_type)) as room_type,
        cast(accommodates as integer) as accommodates,
        cast(bathrooms as integer) as bathrooms,
        cast(bedrooms as integer) as bedrooms,
        cast(beds as integer) as beds,
        case 
            when amenities is null or trim(amenities) = '' then null
            else regexp_replace(
                regexp_replace(trim(amenities),'''','"'),
                '\\s+', ' ')
        end as amenities,
        cast(nullif(nullif(nullif(regexp_replace(regexp_replace(price,'\\$|,',''),','),'N/A'),'-'),'') as decimal)as price ,
       case 
            when lower(trim(has_availability)) in ('t','true','1','yes','y') then true
            when lower(trim(has_availability)) in ('f','false','0','no','n') then false
           else null
        end as has_availability,
        cast(number_of_reviews as integer) as number_of_reviews,
        to_date(first_review) as first_review,
        to_date(last_review) as last_review,
        cast(review_scores_rating as decimal(5,2)) as review_scores_rating,
        cast(review_scores_cleanliness  as decimal(5,2)) as review_scores_cleanliness,
        cast(review_scores_accuracy as decimal(5,2)) as review_scores_accuracy,
        cast(review_scores_checkin as decimal(5,2)) as review_scores_checkin,
        cast(review_scores_communication as decimal(5,2)) as review_scores_communication,
        cast(review_scores_location as decimal(5,2)) as review_scores_location,
        cast(review_scores_value as decimal(5,2)) as review_scores_value,
        case 
            when lower(trim(instant_bookable)) in ('t','true','1','yes','y') then true
            when lower(trim(instant_bookable)) in ('f','false','0','no','n') then false
            else null
        end as instant_bookable,
        cast(host_id as number) as host_id,
        initcap(
            trim(
                regexp_replace(
                     nullif(nullif(nullif(host_name,'N/A'),'Unknown'),'Test')
                    ,'[^A-Za-z0-9 &\'-]','' 
                )
            )
        )as host_name,
        to_date(host_since) as host_since,
        regexp_replace(
                regexp_replace(
                    nullif(nullif(nullif(host_about ,'N/A') ,'Unknown'),'Test'),
                    '[^A-Za-z0-9 ]',''
                    ),
              '\\s+',' '
          )as host_about,
        case
            when host_response_time is null or trim(host_response_time) = '' or trim(lower(host_response_time)) = 'n/a' then null
            when lower(trim(host_response_time )) = 'within an hour' then ''
            when lower(trim(host_response_time )) = 'a few days or more' then ''
            when lower(trim(host_response_time )) = 'within a few hours' then ''
            when lower(trim(host_response_time )) = 'within a day' then ''
            else concat('UNMAPPED_',lower(trim(host_response_time )))
        end as host_response_time,
        case 
            when host_acceptance_rate is null or trim(host_acceptance_rate) = '' or trim(lower(host_acceptance_rate)) = 'n/a' then null
            else    cast(trim(regexp_replace(host_acceptance_rate,'%','')) as integer) 
        end as host_acceptance_rate,
        case 
            when lower(trim(host_is_superhost)) in ('t','true','1','yes','y') then true
            when lower(trim(host_is_superhost)) in ('f','false','0','no','n') then false
            else null
        end as host_is_superhost ,
        cast(host_listings_count as integer) as host_listings_count,
        cast(host_total_listings_count as integer) as host_total_listings_count,
        case 
            when host_verifications is null or trim(host_verifications) = '' then null
            else regexp_replace(
                regexp_replace(trim(host_verifications),'''','"'),
                '\\s+', ' ')
        end as host_verifications ,
        case 
            when lower(trim(host_identity_verified)) in ('t','true','1','yes','y') then true
            when lower(trim(host_identity_verified)) in ('f','false','0','no','n') then false
            else null
        end as host_identity_verified,
   from source     
) , deduped as 
(
    select 
        *,
        row_number() over (partition by listing_id order by listing_id) as row_num
    from cleaned
     where listing_id is not null

) , with_id as 
(
    select 
        {{ dbt_utils.generate_surrogate_key(['listing_id']) }} as listing_id_stg ,
        *
    from deduped
    where row_num = 1
)

select *
from with_id


