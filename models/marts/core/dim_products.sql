with stg_product as (
    select 
        product_id
      , desc_product
      , price
      , inventory
      , is_data_deleted
      , loaded_at
    from {{ ref('stg_sql_server_dbo__products') }}
),
stg_plant as (
    select 
        plant_name
      , preferred_min_temperature
      , preferred_max_temperature
      , humidity
      , light_requirement
      , climate_summary
    from {{ ref("stg__plant")}}
)

select 
        product_id
      , desc_product
      , preferred_min_temperature
      , preferred_max_temperature
      , humidity
      , light_requirement
      , climate_summary
      , price
      , inventory
      , is_data_deleted
      , loaded_at

from stg_product as product
left join stg__plant as plant
on product.desc_product = plant.plant_name