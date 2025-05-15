with stg_customer as (
    select 
        customer.customer_id
      , full_name
      , address_id
      , email
      , phone_number
      , customer_update_at
      , customer_created_at
      , is_data_deleted
      , loaded_at
      , total_orders
    from {{ref('stg_sql_server_dbo__users')}} customer
    inner join {{ ref("int_sql_server_dbo__customer_refined") }} refined_customer
    using(customer_id)
)

select *
from stg_customer