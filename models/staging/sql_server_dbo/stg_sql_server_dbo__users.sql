with src_data as (
    select *
    from {{ source("sql_server_dbo", "users")}}
),
-- making some casting and concat the first and last name to be a unique column
casted_renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(['user_id']) }} as customer_id
        , concat(first_name,' ',last_name) as full_name
        , updated_at::timestamp_ntz as customer_update_at
        , {{ dbt_utils.generate_surrogate_key(['address_id']) }} as address_id
        , created_at::timestamp_ntz as customer_created_at
        , phone_number 
        --, coalesce(co.NUMBER_OF_ORDERS, 0) as TOTAL_ORDERS
        , email 
        , _fivetran_deleted as is_data_deleted
        , _fivetran_synced::timestamp_ntz as loaded_at
    from src_data
)


select *
from casted_renamed
