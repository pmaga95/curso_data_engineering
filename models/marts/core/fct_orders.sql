{{ config(
    materialized = 'incremental',
    unique_key = ['order_id', 'product_id'], 
    on_schema_change = 'fail'
) }}

-- getting our orders staging model
with orders as (
    select * 
    from {{ ref("stg_sql_server_dbo__orders")}}
    {% if is_incremental() %}
      where loaded_at > (select max(loaded_at) from {{ this }})
    {% endif %}
),
-- getting our order_items staging model
order_items as (
    select *
    from {{ ref("stg_sql_server_dbo__order_items")}}
    {% if is_incremental() %}
      where loaded_at > (select max(loaded_at) from {{ this }})
    {% endif %}
)
,
order_items_grained as (
    select
         order_items.order_item_id
       , orders.order_id
       , orders.customer_id
       , order_items.product_id
       , orders.status
       , orders.shipping_company
       , orders.address_id
       , orders.order_created_at
       , orders.promo_id
       , orders.estimated_delivery_at
       , orders.order_delivered_at
       -- facts 
       , order_items.quantity
       , product.price as unit_price
       , product.price * order_items.quantity as subtotal_item_per_order

    from orders
    left join order_items
    using(order_id)
    left join {{ ref("stg_sql_server_dbo__products")}} product
    using(product_id)
    left join {{ ref('stg_sql_server_dbo__addresses')}} address
    using(address_id)
    left join {{ ref('stg_sql_server_dbo__promo')}} promo
    using(promo_id)
    order by orders.order_created_at

)

select *
from order_items_grained


