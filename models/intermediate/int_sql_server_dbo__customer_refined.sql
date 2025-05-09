-- this CTE is getting the orders from staging order model
with orders as (
    select 
        ORDER_ID
        , CUSTOMER_ID
        , CREATED_DATE
        , STATUS
    from {{ ref("stg_sql_server_dbo__orders")}}
)
-- And on this we're gonna get the total order related for each customer to fill out the column TOTAL_ORDERS
-- from the table users
select 
        CUSTOMER_ID
        , count(ORDER_ID) as NUMBER_OF_ORDERS
from orders
group by 1

