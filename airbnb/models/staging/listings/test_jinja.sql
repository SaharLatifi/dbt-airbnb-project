{% set room_type = ['private room' , 'apt'] %}

select 
    listing_id_stg,
    case 
        when lower(room_type) in ('{{ room_type | join("','") }}') then true
        else false
    end as is_private_room
from {{ ref('stg_listings_listings') }}