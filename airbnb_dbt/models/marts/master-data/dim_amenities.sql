with expanded_amenities as (

    select
        regexp_replace(
            trim(a.value::string),
            '\\s+',
            ' '
        ) as amenity_name

    from {{ ref('stg_property__listings') }} as l,
    lateral flatten(
        input => try_parse_json(l.amenities)
    ) as a

),

unique_amenities as (

    select distinct
        amenity_name

    from expanded_amenities

    where amenity_name is not null
      and amenity_name <> ''

)

select
    {{ dbt_utils.generate_surrogate_key([
        'amenity_name'
    ]) }} as amenity_id,

    amenity_name,

    current_timestamp() as created_at,
    current_timestamp() as updated_at

from unique_amenities