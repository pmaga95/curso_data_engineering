with src_data as (
    select *
    from {{ source("sql_server_dbo", "order_items") }}
),
casted_renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(['ORDER_ID','PRODUCT_ID','QUANTITY']) }} as ORDER_ITEM_ID
        , ORDER_ID
        , PRODUCT_ID
        , QUANTITY
        , _FIVETRAN_DELETED
        , _FIVETRAN_SYNCED
    from src_data 
    
)

select *
from casted_renamed
