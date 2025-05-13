with orders as (
    select * 
    from {{ ref("stg_sql_server_dbo__orders") }}
),

order_item as (
    select *
    from {{ ref("int_sql_server_dbo__order_items") }}
),


fact_order as (
    select
          ORDER_ITEM_ID
        , ORDER_ID
        , PRODUCT_ID
        , CUSTOMER_ID
        , PROMO_ID
        , ADDRESS_ID
        , SHIPPING_COMPANY
        , STATUS
        , CREATED_DATE
        , ESTIMATED_DELIVERY_DATE
        , DELIVERED_DATE
        , SUBTOTAL_ITEM_PER_ORDER
        , ITEM_DISCOUNT_AMOUNT_EURO
        , ITEM_SHIPPING_COST_EURO
        , QUANTITY
    from order_item
    left join orders using(ORDER_ID)
    

    
)

select *
from fact_order


