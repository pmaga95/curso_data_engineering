with src_data as (
    select *
    from {{ source("weather", "weather_usa")}}
),

casted as (
    select 
        "Data.Precipitation"::float as precipitation
       , "Date.Full"::date as full_date
       , "Date.Week of"::int as week_start_date
       , "Date.Year"::int as year
       , "Station.City"::varchar as city
       , "Station.State"::varchar as state
       , "Data.Temperature.Avg Temp"::float as avg_temperature
       , "Data.Temperature.Max Temp"::float as max_temperature
       , "Data.Temperature.Min Temp"::float as min_temperature
       , "Data.Wind.Direction"::float as wind_direction
       , "Data.Wind.Speed"::float as wind_speed
    from src_data
),
-- convert into celsius from fahrenheit
convert_temperature as (
    select 
        precipitation
       , full_date
       , week_start_date
       , year
       , city
       , state
       , round({{ f_to_c('avg_temperature') }})::int as avg_temperature_c
       , round({{ f_to_c('max_temperature') }})::int as max_temperature_c
       , round({{ f_to_c('min_temperature') }})::int as min_temperature_c
       , wind_direction
       , wind_speed
    from casted
)

select *
from convert_temperature