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
         order_items.ORDER_ITEM_ID
       , orders.ORDER_ID
       , orders.CUSTOMER_ID
       , order_items.PRODUCT_ID
       , orders.STATUS
       , orders.SHIPPING_COMPANY
       , orders.ADDRESS_ID
       , orders.CREATED_DATE
       , orders.PROMO_ID
       , orders.ESTIMATED_DELIVERY_DATE
       , orders.DELIVERED_DATE
       , order_items.QUANTITY
       , product.PRICE as UNIT_PRICE
       , (product.PRICE * order_items.QUANTITY) as TOTAL_PRICE_PER_ITEM
       , orders.ORDER_COST -- this is a total cost from sum up all (item product price * quantity) per order
       ,(
        ((orders.ORDER_COST + orders.SHIPPING_COST) - orders.ORDER_TOTAL) 
        * ((product.PRICE * order_items.QUANTITY) / orders.ORDER_COST)    -- the discount per item in this order
        )::decimal(10,2) as ITEM_DISCOUNT_AMOUNT_EURO
       , (orders.ORDER_COST + orders.SHIPPING_COST) - orders.ORDER_TOTAL as TOTAL_DISCOUNT_ORDER
       , orders.SHIPPING_COST
       , orders.ORDER_TOTAL
    from orders
    inner join order_items
    on orders.ORDER_ID = order_items.ORDER_ID
    inner join {{ ref("stg_sql_server_dbo__products")}} product
    on order_items.PRODUCT_ID = product.PRODUCT_ID
    order by orders.CREATED_DATE

)

select * 
from orders_order_items_grained