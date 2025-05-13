with stg_customer as (
    select 
        customer.CUSTOMER_ID
      , FULL_NAME
      , ADDRESS_ID
      , EMAIL
      , PHONE_NUMBER
      , CUSTOMER_UPDATE_DATE
      , CUSTOMER_CREATED_DATE
      , DELETE_DATE
      , LOAD_DATE
      , NUMBER_OF_ORDERS
    from {{ref('stg_sql_server_dbo__users')}} customer
    inner join {{ ref("int_sql_server_dbo__customer_refined") }} refined_customer
    on customer.CUSTOMER_ID = refined_customer.CUSTOMER_ID
)

select *
from stg_customer