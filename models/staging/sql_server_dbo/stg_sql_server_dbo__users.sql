with src_data as (
    select *
    from {{ source("sql_server_dbo", "users")}}
),
-- this CTE is for getting the orders from source
/**
orders as (
    select ORDER_ID
        , USER_ID as CUSTOMER_ID
        , CREATED_AT
        , STATUS
    from {{ source("sql_server_dbo", "orders") }}
),
-- And on this we're gonna get the total order related for each customer to fill out the column TOTAL_ORDERS
-- from the table users
customer_orders as (
    select 
            CUSTOMER_ID
        , count(ORDER_ID) as NUMBER_OF_ORDERS
    from orders
    group by 1
),
**/
-- making some casting and concat the first and last name to be a unique column
-- with coalesce we get the total value from the order CTE and if is null then it'll be 0
casted_renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} as CUSTOMER_ID
        , concat(FIRST_NAME,' ',LAST_NAME) as FULL_NAME
        , UPDATED_AT::timestamp_ntz as CUSTOMER_UPDATE_DATE
        , ADDRESS_ID 
        , CREATED_AT::timestamp_ntz as CUSTOMER_CREATED_DATE
        , PHONE_NUMBER 
        --, coalesce(co.NUMBER_OF_ORDERS, 0) as TOTAL_ORDERS
        , EMAIL 
        , _FIVETRAN_DELETED as DELETE_DATE
        , _FIVETRAN_SYNCED::timestamp_ntz as LOAD_DATE
    from src_data
)


select *
from casted_renamed
