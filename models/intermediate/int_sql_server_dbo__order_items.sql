-- getting our orders staging model
with orders as (
    select * 
    from {{ ref("stg_sql_server_dbo__orders")}}
),
-- getting our order_items staging model
order_items as (
    select *
    from {{ ref("stg_sql_server_dbo__order_items")}}
)
,
orders_order_items_grained as (
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
       , order_items.quantity
       , product.price as unit_price
      -- ,(
      --  ((orders.order_cost + orders.shipping_cost) - orders.order_total) -- total discount per order. (It´s also posible getting that data from a promo table through the promo_id to get the discount)
       -- * ((product.price * order_items.quantity) / orders.order_cost)    -- the discount per item in this order distributed proportionally.  This is getting the relative value of product in a order
      --  )::decimal(10,2) as item_discount_amount_euro
      -- ,
       -- getting the shipping cost per item
       --(
       -- orders.shipping_cost
      --  * ((product.price * order_items.quantity) / orders.order_cost) 
       -- )::decimal(10,2) as item_shipping_cost_euro

       , product.price * order_items.quantity as subtotal_item_per_order

    from orders
    inner join order_items
    on orders.order_id = order_items.order_id
    inner join {{ ref("stg_sql_server_dbo__products")}} product
    on order_items.product_id = product.product_id
    order by orders.order_created_at

)

select distinct *
from orders_order_items_grained