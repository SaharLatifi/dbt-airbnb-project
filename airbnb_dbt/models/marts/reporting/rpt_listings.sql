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
        longitude
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


