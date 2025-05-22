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
        where order_loaded_at > (select max(order_loaded_at) from {{ this }})
    {% endif %}
),
-- getting our order_items staging model
order_items as (
    select *
    from {{ ref("stg_sql_server_dbo__order_items")}}
    {% if is_incremental() %}
      where order_item_loaded_at > (select max(order_item_loaded_at) from {{ this }})
    {% endif %}
)
,
order_items_grained as (
    select
         order_items.order_item_id -- The surrogate key got from a order_item
       , orders.order_id
       , orders.customer_id
       , order_items.product_id
       , orders.status
       , orders.shipping_company
       , orders.address_id
       , to_date(orders.order_created_at) as order_date
      -- , to_time(orders.order_created_at) as order_time
       , orders.estimated_delivery_at
       , orders.order_delivered_at
       -- our facts measures
       , order_items.quantity
       , product.price as unit_price_usd
       , product.price * order_items.quantity as subtotal_item_per_order_usd
       , order_loaded_at
       , order_item_loaded_at

    from orders
    left join order_items
    using(order_id)
    left join {{ ref("stg_sql_server_dbo__products")}} product
    using(product_id)
    left join {{ ref('stg_sql_server_dbo__addresses')}} address
    using(address_id)
    left join {{ ref('dim_date') }} date
    on order_date = date.date_key
    order by order_date

)

select *
from order_items_grained


