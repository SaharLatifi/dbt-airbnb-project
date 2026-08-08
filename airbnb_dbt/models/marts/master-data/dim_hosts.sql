with source as (
    select  
        {{ dbt_utils.generate_surrogate_key(['source_host_id']) }}  as host_id ,
        source_host_id , 
        host_name ,
        d.date_id as host_since_date_id ,
        host_response_time,
        host_response_rate,
        host_acceptance_rate,
        host_is_super_host,
        --host_verifications,
        host_identity_verified ,
        contains(host_verifications, '''government_id''') as verified_by_gov_id,
        contains(host_verifications, '''email''') or  contains(host_verifications, '''work_email''') as verified_by_email,
        contains(host_verifications, '''phone''') as verified_by_phone,
        dbt_valid_from  as valid_from,
        dbt_valid_to    as valid_to,
        iff(dbt_valid_to is null , True , False) as is_active,
        current_timestamp() as created_at ,
        current_timestamp() as updated_at 
 
    from {{ ref('scd_property__hosts') }} as h
        inner join {{ ref('dim_dates') }}  as d on h.host_since = d.date_day
) 
    select
          *
    from source
