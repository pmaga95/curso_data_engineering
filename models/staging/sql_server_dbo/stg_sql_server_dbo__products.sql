with src_data as (
    select *
    from {{ source("sql_server_dbo" , "products")}}
),
casted_renamed as(
    select 
         PRODUCT_ID 
        , PRICE::decimal(10,4) as PRICE
        , NAME 
        , INVENTORY
        , _FIVETRAN_DELETED 
        , _FIVETRAN_SYNCED
    from src_data 
)

select *
from casted_renamed
