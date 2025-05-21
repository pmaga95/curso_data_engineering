with src_data as (
    select *
    from {{ source("plant", "plant_details")}}
),

casted as (
    select 
           plant_name::varchar(50) as plant_name
         , left(preferred_temperature,2)::float as preferred_min_temperature
         , right(preferred_temperature,2)::float as preferred_max_temperature
         , humidity::varchar(50) as humidity
         , light_requirement::varchar(50) as light_requirement
         , climate_summary::varchar(50) as climate_summary
    from src_data
)

select * 
from casted