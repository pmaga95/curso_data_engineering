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
       , (product.PRICE * order_items.QUANTITY) as ITEM_TOTAL_PRICE
       , orders.ORDER_TOTAL - orders.SHIPPING_COST as DISCOUNT_EURO
       , orders.SHIPPING_COST
    from orders 
    inner join order_items
    on orders.ORDER_ID = order_items.ORDER_ID
    inner join {{ ref("stg_sql_server_dbo__products")}} product
    on order_items.PRODUCT_ID = product.PRODUCT_ID
    order by orders.CREATED_DATE

)

select * 
from final