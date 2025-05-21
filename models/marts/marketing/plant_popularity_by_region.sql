with recommendations as (
    select
        customer_id
       , product_id
       , state
    from {{ ref('product_recommendations_by_customer') }}
),

plant_details as (
    select
        product_id
      , desc_product
    from {{ ref('dim_products') }}
),

combined as (
    select
         r.customer_id
       , r.state
       , p.product_id
       , p.desc_product
    from recommendations r
    inner join plant_details p on r.product_id = p.product_id
)

select
      state
    , desc_product
    ,count(*) as total_recommendations
from combined
group by state, desc_product
order by total_recommendations desc

