with customer_location as (
    select
        customer.address_id
      , customer_id
      , state
    from {{ ref('dim_customers')}} customer
    left join {{ ref('dim_addresses')}} address
    using(address_id)
),

location_weather as (
    select
         state
        , round(avg(avg_temperature_c)) as avg_temperature
        , round(avg(min_temperature_c)) as min_temperature
        , round(avg(max_temperature_c)) as max_temperature
    from {{ ref('dim_weather') }}
    group by 1
),

plant_catalog as (
    select
        product_id
      , desc_product
      , preferred_min_temperature
      , preferred_max_temperature 
      , humidity as preferred_humidity
      , climate_summary
    from {{ ref('dim_products') }}
),

-- Join address and climate

customer_weather as (
    select
         cl.customer_id
       , cl.state
       , lw.avg_temperature
       , lw.min_temperature
       , lw.max_temperature
    from customer_location cl
    left join location_weather lw
    on lower(cl.state) = lower(lw.state)
),

-- Recommend products(plants) matching the customer's climate
recommend_plants as (
    select
       pc.product_id
      , pc.desc_product
      , cw.customer_id
      , cw.state
      , pc.climate_summary
    from customer_weather as cw
    join plant_catalog pc
    on cw.avg_temperature between pc.preferred_min_temperature and pc.preferred_max_temperature
)

select *
from recommend_plants


