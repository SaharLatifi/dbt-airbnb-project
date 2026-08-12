{{ config(materialized='view') }}

with listings_amenity as  
 (
    select 
        b.listing_id,
        a.amenity_id,
        a.amenity_name      
from {{ ref('bridge_listing_amenity') }} b
    inner join {{ ref('dim_amenities') }} a on b.amenity_id = a.amenity_id
 )

 select *
 from listings_amenity
