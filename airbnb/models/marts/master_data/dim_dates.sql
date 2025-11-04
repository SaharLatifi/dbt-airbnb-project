with date_spine as(
    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "cast('2020-01-01' as date)",
        end_date = "current_date()"
    )}}
) , date_spine_enriched as 
(
    select 
        date_day as date_day,
        extract(year from date_day) as date_year,
        extract(month from date_day) as date_month,
        extract(day from date_day) as date_day_of_month,
        extract(week from date_day) as date_week_of_year,
        extract(quarter from date_day) as date_quarter,
        case 
            when extract(dow from date_day) = 1 then 'Monday'
            when extract(dow from date_day) = 2 then 'Tuesday'
            when extract(dow from date_day) = 3 then 'Wednesday'
            when extract(dow from date_day) = 4 then 'Thursday'
            when extract(dow from date_day) = 5 then 'Friday'
            when extract(dow from date_day) = 6 then 'Saturday'
            when extract(dow from date_day) = 7 then 'Sunday'
        end as date_day_name,
        case 
            when extract(month from date_day) = 1 then 'January'
            when extract(month from date_day) = 2 then 'February'
            when extract(month from date_day) = 3 then 'March'
            when extract(month from date_day) = 4 then 'April'
            when extract(month from date_day) = 5 then 'May'
            when extract(month from date_day) = 6 then 'June'
            when extract(month from date_day) = 7 then 'July'
            when extract(month from date_day) = 8 then 'August'
            when extract(month from date_day) = 9 then 'September'
            when extract(month from date_day) = 10 then 'October'
            when extract(month from date_day) = 11 then 'November'
            when extract(month from date_day) = 12 then 'December'
        end as date_month_name ,
        case 
            when extract(dow from date_day) in (6,7) then true
            else false
        end as is_weekend
    from date_spine
)
select *
from date_spine_enriched
