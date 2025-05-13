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
       , (product.PRICE * order_items.QUANTITY) as SUBTOTAL_PRICE_PER_ITEM
       ,(
        ((orders.ORDER_COST + orders.SHIPPING_COST) - orders.ORDER_TOTAL) -- total discount per order. (It´s also posible getting that data from a promo table through the promo_id to get the discount)
        * ((product.PRICE * order_items.QUANTITY) / orders.ORDER_COST)    -- the discount per item in this order distributed proportionally.  This is getting the relative value of product in a order
        )::decimal(10,2) as ITEM_DISCOUNT_AMOUNT_EURO
       ,
       -- getting the shipping cost per item
       (
        orders.SHIPPING_COST
        * ((product.PRICE * order_items.QUANTITY) / orders.ORDER_COST) 
        )::decimal(10,2) as ITEM_SHIPPING_COST_EURO

       , (product.PRICE * order_items.QUANTITY) -
         (
         ((orders.ORDER_COST + orders.SHIPPING_COST) - orders.ORDER_TOTAL)
        * ((product.PRICE * order_items.QUANTITY) / orders.ORDER_COST)
         ) +
         (
        orders.SHIPPING_COST
        * ((product.PRICE * order_items.QUANTITY) / orders.ORDER_COST) 
        )::decimal(10,2) as SUBTOTAL_ITEM_PER_ORDER

    from orders
    inner join order_items
    on orders.ORDER_ID = order_items.ORDER_ID
    inner join {{ ref("stg_sql_server_dbo__products")}} product
    on order_items.PRODUCT_ID = product.PRODUCT_ID
    order by orders.CREATED_DATE

)

select * 
from orders_order_items_grained