with source as (
    select 
        {{ dbt_utils.generate_surrogate_key(['source_reviewer_id']) }} as reviewer_id,
        source_reviewer_id,
        reviewer_name,
        current_timestamp() as created_at,
        current_timestamp() as updated_at
    from {{ ref('stg_reviews__reviews') }}

)
select *
from source    

