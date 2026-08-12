{{ config(
    severity='warn',
    store_failures=true
) }}

with superhosts_without_gov_id as (
  select *
  from {{ ref('dim_hosts')}}
  where host_is_super_host = 'True'  and  host_identity_verified = 'False' and verified_by_gov_id is  null 
)
select * from superhosts_without_gov_id