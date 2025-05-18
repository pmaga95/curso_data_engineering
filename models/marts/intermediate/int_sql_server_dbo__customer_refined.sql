-- this CTE is getting the orders from staging order model
with
    orders as (
        select order_id, customer_id, order_created_at, status
        from {{ ref("stg_sql_server_dbo__orders") }}
    )
-- And on this we're gonna get the total order related for each customer to fill out
-- the column TOTAL_ORDERS
-- from the table users
select 
    customer_id, 
    count(order_id) as total_orders
from orders
group by 1
