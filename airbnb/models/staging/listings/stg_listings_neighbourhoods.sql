with source as (
    select 
        neighbourhood
    from {{ source('listings','neighbourhoods')}} 
)
, cleaned_placeholders as (
    select 
        nullif(nullif(nullif(trim(neighbourhood), 'N/A'),'UNKNOWN'),'--')as neighbourhood
    from source
) , cleaned_text_format as (
    select 
    initcap(
        trim(
            regexp_replace(
                regexp_replace(
                    neighbourhood,
                    '\\s+',' '
                ),
                '[^A-Za-z0-9 ]',''
            )
        )
    ) as neighbourhood
    from cleaned_placeholders
) , filtered as (
    select 
        neighbourhood
    from cleaned_text_format
    where 
        neighbourhood is not null and
        neighbourhood != '' and
        lower(neighbourhood) not like 'test%' and
        lower(neighbourhood) not like '%sample%' and
        lower(neighbourhood) not like '%dummy%'  and
        lower(neighbourhood) not like 'asdf%'
) , deduped as (
    select 
        neighbourhood,
        row_number() over (partition by neighbourhood order by neighbourhood) as row_num
    from filtered
) , with_id as (
    select 
        {{ dbt_utils.generate_surrogate_key(['neighbourhood']) }} as neighborhood_id_stg,
        neighbourhood 
    from deduped
    where row_num = 1
)
select  *
from with_id
