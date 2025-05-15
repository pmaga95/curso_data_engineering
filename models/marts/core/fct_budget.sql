with products as (
    select *
    from {{ ref("dim_products")}}
)
, 
stg_budget as (
    select 
          PRODUCT_ID
        , MONTH
        , LOADED_TIMESTAMP
        , QUANTITY
    from {{ ref("stg_google_sheets__budget") }} as budget
    left join products using(PRODUCT_ID)
)

select *
from stg_budget