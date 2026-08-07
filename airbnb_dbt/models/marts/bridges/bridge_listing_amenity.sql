with listing_amenities as (

    select
        s.source_listing_id,
        s.dbt_valid_from,

        regexp_replace(
            trim(a.value::string),
            '\\s+',
            ' '
        ) as amenity_name

    from {{ ref('scd_property__listings') }} as s,
    lateral flatten(
        input => try_parse_json(s.amenities)
    ) as a

)  ,
listing_versions as (

    select
        listing_id,
        source_listing_id,
        valid_from

    from {{ ref('dim_listings') }}

),
amenities as (

    select
        amenity_id,
        amenity_name

    from {{ ref('dim_amenities') }}

) ,
final as (

    select distinct
        l.listing_id,
        a.amenity_id

    from listing_amenities as la

    inner join listing_versions as l
        on la.source_listing_id = l.source_listing_id
        and la.dbt_valid_from = l.valid_from

    inner join amenities as a
        on la.amenity_name = a.amenity_name

    where la.amenity_name is not null
      and la.amenity_name <> ''

)

select 
    {{ dbt_utils.generate_surrogate_key([
    'listing_id',
    'amenity_id'
    ]) }} as listing_amenity_id,
    * ,
    current_timestamp as created_at,
    current_timestamp as updated_at
from final


