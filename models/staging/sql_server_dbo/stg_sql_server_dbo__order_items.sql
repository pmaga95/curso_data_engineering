with src_data as (
    select *
    from {{ source("sql_server_dbo", "order_items") }}
),
casted_renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(['order_id','product_id']) }} as order_item_id
        , {{dbt_utils.generate_surrogate_key(['order_id'])}} as order_id
        , {{dbt_utils.generate_surrogate_key(['product_id'])}} as product_id
        , quantity
        , _fivetran_deleted as is_data_deleted
        , _fivetran_synced::timestamp_ntz as loaded_at
    from src_data 
    
)

select *
from casted_renamed
