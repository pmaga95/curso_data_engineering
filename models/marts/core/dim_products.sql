with stg_product as (
    select 
        PRODUCT_ID
      , PRODUCT_DESC
      , PRICE
      , INVENTORY
      , DELETE_DATE
      , LOAD_DATE
    from {{ ref('stg_sql_server_dbo__products') }}
)

select *
from stg_product