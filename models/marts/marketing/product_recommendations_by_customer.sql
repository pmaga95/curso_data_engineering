with customer_location as (
    select
        address_id
      , customer_id
      , state
    from {{ ref('dim_customers')}} customer
    inner join {{ ref('dim_addresses')}} address
    using(address_id)
),

location_weather as (
    select
         state
        , avg(avg_temperature_c) as avg_temperature
        , avg(min_temperature_c) as min_temperature
        , avg(max_temperature_c) as max_temperature
    from {{ ref('stg__weather') }}
    group by 1
)

