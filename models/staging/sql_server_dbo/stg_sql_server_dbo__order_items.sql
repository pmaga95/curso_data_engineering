with src_data as (
    select *
    from {{ source("sql_server_dbo", "order_items") }}
),
casted_renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(['ORDER_ID','PRODUCT_ID']) }} as ORDER_ITEM_ID
        , {{dbt_utils.generate_surrogate_key(['ORDER_ID'])}} as ORDER_ID
        , {{dbt_utils.generate_surrogate_key(['PRODUCT_ID'])}} as PRODUCT_ID
        , QUANTITY
        , _FIVETRAN_DELETED as DELETE_DATE
        , _FIVETRAN_SYNCED::timestamp_ntz as LOAD_DATE
    from src_data 
    
)

select *
from casted_renamed
