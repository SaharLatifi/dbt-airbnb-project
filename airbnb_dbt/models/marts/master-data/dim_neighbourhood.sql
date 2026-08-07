with source as (
    select 
        {{ dbt_utils.generate_surrogate_key(['neighbourhood_name']) }} as neighbourhood_id,
        neighbourhood_name,
        current_timestamp() as created_at,
        current_timestamp() as updated_at   
    from {{ ref('stg_property__neighbourhoods') }}
)

select *
from source
