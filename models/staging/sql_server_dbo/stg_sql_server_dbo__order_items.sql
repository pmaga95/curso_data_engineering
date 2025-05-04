with src_data as (
    select *
    from {{ source("sql_server_dbo", "order_items") }}
),
casted_renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(['ORDER_ID','sd.PRODUCT_ID','QUANTITY']) }} as ORDER_ITEM_ID
        , ORDER_ID
        , p.PRODUCT_SK
        , QUANTITY
        , sd._FIVETRAN_DELETED
        , sd._FIVETRAN_SYNCED
    from src_data sd
    inner join {{ ref("stg_sql_server_dbo__products") }} p
    on sd.PRODUCT_ID = p.PRODUCT_ID
)

select *
from casted_renamed
