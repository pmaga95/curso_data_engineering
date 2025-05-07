-- getting data from a users
with user_base as (
    select 
        *
    from {{ ref("stg_sql_server_dbo__users")}}
)
,
customer_orders as (
    select
        USER_ID
    ,   count(distinct ORDER_ID) as TOTAL_ORDERS
    ,   count(distinct 
            case when STATUS = 'shipped'
            then ORDER_ID
            end) as NUM_ORDERS_SHIPPED
    ,   count(distinct 
            case when STATUS = 'delivered'
            then ORDER_ID
            end) as NUM_ORDERS_DELIVERED
    ,   count(distinct 
            case when STATUS = 'preparing'
            then ORDER_ID
            end) as NUM_ORDERS_PREPARING
    from {{ ref("stg_sql_server_dbo__orders")}} 
    group by 1
)

select *
from customer_orders