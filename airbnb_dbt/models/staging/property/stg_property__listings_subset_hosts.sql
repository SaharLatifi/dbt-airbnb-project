{{ config(materialized='view')  }}

with source as (
    select distinct
        source_host_id,
        to_timestamp_ntz(last_scraped) as last_scraped,
        host_name,
        host_since , 
        host_response_time,
        host_acceptance_rate,
        host_response_rate,
        host_is_super_host,
        host_verifications,
        host_identity_verified
     from {{ ref('stg_property__listings') }} 
     where source_host_id is not null
)
select *
from source 



