with source as (
    select
        regexp_replace(trim(neighbourhood), '\\s+', ' ') as neighbourhood_name,
        nullif(regexp_replace(trim(neighbourhood_group), '\\s+', ' '), '') as   neighbourhood_group
	from 
        {{ source('property', 'neighbourhoods') }}
    where neighbourhood is not null and trim(neighbourhood) != ''
)
select *
from source 