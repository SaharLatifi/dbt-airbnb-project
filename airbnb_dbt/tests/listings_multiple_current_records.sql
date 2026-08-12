{{ config(
    severity='error',
    store_failures=true
) }}

with listings_multiple_current_records as (
  select 
    source_listing_id,
    count(*) as current_records_count
  from {{ ref('scd_property__listings')}}
  where dbt_valid_to is null
  group by source_listing_id
  having count(*) > 1
) 
select * from listings_multiple_current_records
