with products as (
    select *
    from {{ ref("dim_products")}}
)
, 
stg_budget as (
    select 
          product_id
        , month
        , quantity
        , loaded_at
        
    from {{ ref("stg_google_sheets__budget") }} as budget
    left join products using(product_id)
)

select *
from stg_budget