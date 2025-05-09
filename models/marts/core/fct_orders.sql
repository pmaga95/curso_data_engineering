with orders as (
    select * 
    from {{ ref("stg_sql_server_dbo__orders") }}
),

order_item as (
    select *
    from {{ ref("int_sql_server_dbo__order_items") }}
),

order_item_aggregated_per_order as (
    select
        ORDER_ITEM_ID
     ,  sum(TOTAL_PRICE_PER_ITEM) as TOTAL_ITEM_PRICE_ORDERED
     ,  sum(ITEM_DISCOUNT_AMOUNT_EURO) as GROSS_ITEM_DISCOUNT_AMOUNT_EURO
     ,  sum(QUANTITY) as QUANTITY_ORDERED
    from order_item
    group by  1 
),

fact_order (

)


