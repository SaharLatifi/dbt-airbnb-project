with source as 
(
    select 
        listing_id ,
	    id ,
	    date ,
	    reviewer_id ,
	    reviewer_name,
	    comments 
    from {{ source('listings' , 'reviews' ) }} 
) , data_type_casted as 
(
select 
    cast(listing_id as integer) as listing_id ,
    cast(id as integer) as review_id ,
    to_date(date)  as review_date ,
    cast(reviewer_id as integer) as reviewer_id ,
    nullif(nullif(nullif(trim(reviewer_name),'N/A'),'Unknown'),'Test') as reviewer_name,
    nullif(nullif(nullif(trim(comments),'N/A'),'Unknown'),'Test') as comments 
from source
) , cleaned_text as 
(
    select 
        listing_id, 
        review_id,
        review_date,
        reviewer_id,
        initcap(trim(regexp_replace(reviewer_name,'[^A-Za-z0-9 ]', ' ') ) )as reviewer_name,
        regexp_replace(
            regexp_replace(comments,'[^A-Za-z0-9 ]', ' '),
            '\\s+',' '
            ) as comments 
    from data_type_casted
) , filtered as 
(
    select 
        listing_id, 
        review_id,
        review_date,
        reviewer_id,
        reviewer_name,
        comments 
    from cleaned_text
    where 
        listing_id is not null and
        review_date is not null and
        reviewer_id is not null
) , deduped as
(
    select 
        listing_id, 
        review_id,
        review_date,
        reviewer_id,
        reviewer_name,
        comments,
        row_number() over (partition by listing_id, review_id order by review_date desc) as row_num
    from filtered
) , with_id as 
(
    select 
        {{ dbt_utils.generate_surrogate_key(['listing_id', 'review_id']) }} as review_id_stg,
        review_id, 
        listing_id, 
        review_date,
        reviewer_id,
        reviewer_name,
        comments
    from deduped
    where row_num = 1
)
select *
from with_id

