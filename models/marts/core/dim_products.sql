with stg_product as (
    select 
        product_id
      , desc_product
      , price
      , inventory
      , is_data_deleted
      , loaded_at
    from {{ ref('stg_sql_server_dbo__products') }}
)

select *
from stg_product