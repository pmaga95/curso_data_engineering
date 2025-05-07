/**
-- getting data from a users
with user_base as (
    select 
        *
    from {{ ref("stg_sql_server_dbo__users")}}
)
,
-- let´s summary all the orders and those status related for the customer
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
    from {{ ref("stg_sql_server_dbo__orders")}} orders
    inner join {{ ref("stg_sql_server_dbo__order_items")}} order_item
    group by 1
)
,
-- Let's get the total amount of customer and the total item purchased
csutomer_order_item(
    select
        USER_ID
    ,   SUM()
)
,
-- now we're gonna see all session that was made by a customer and wich page
tracking_web as(
    select
        USER_ID  
     ,  count(distinct SESSION_ID) as NUMBER_WEB_SESSIONS
    from {{ ref("stg_sql_server_dbo__events")}} 
    group by 1
)

select 
    USER_ID
,   NAME
,   ADDRESS_ID
,   
from customer_orders
**/