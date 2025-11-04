{% set neighbourhoods = ['Downtown' , 'Fairview' , 'West End'] %}

select 
    listing_id_stg,neighbourhood,
    {% for n in neighbourhoods %}
        case 
            when neighbourhood  = '{{n}}' then 1
            else 0
        end as  "{{ n }}" {% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('stg_listings_listings') }}