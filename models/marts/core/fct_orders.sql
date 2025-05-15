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
          order_item_id
        , order_id
        , product_id
        , customer_id
        , promo_id
        , address_id
        , shipping_company
        , status
        , order_created_at
        , estimated_delivery_at
        , order_delivered_at
        , subtotal_item_per_order
        , item_discount_amount_euro
        , item_shipping_cost_euro
        , quantity
    from order_item
    left join orders using(order_id)
    

    
)

select *
from fact_order


