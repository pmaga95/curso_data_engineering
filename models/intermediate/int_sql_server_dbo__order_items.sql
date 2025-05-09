with orders as (
    select * 
    from {{ ref("stg_sql_server_dbo__orders")}}
),

order_items as (
    select *
    from {{ ref("stg_sql_server_dbo__order_items")}}
)
,
final as (
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
       , orders.ORDER_COST -- this is a total cost from sum up all (item product price * quantity) per order
       , product.PRICE
       , (orders.ORDER_COST + orders.SHIPPING_COST) - orders.ORDER_TOTAL as TOTAL_DISCOUNT_ORDER
       -- Distribuited discount per item
       ,(
        ((orders.ORDER_COST + orders.SHIPPING_COST) - orders.ORDER_TOTAL) -- total discount
        * ((product.PRICE * order_items.QUANTITY) / orders.ORDER_COST)    -- the discount per item in this order
        )::decimal(10,2) as ITEM_DISCOUNT_EURO
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
from final