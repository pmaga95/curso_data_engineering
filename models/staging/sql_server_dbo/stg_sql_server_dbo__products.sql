with src_data as (
    select *
    from {{ source("sql_server_dbo" , "products")}}
),
-- Add the default row 
default_record as (
    select 
        'Unknown_prduct' as PRODUCT_ID
        , -1 as PRICE
        , 'Missing_name' as NAME
        , -1 as INVENTORY
        , null as _FIVETRAN_DELETED
        , '1998-01-01' as _FIVETRAN_SYNCED
),
-- merge the default row with all products raw
with_default_record as (
    select *
    from src_data
    union all
    select * 
    from default_record
)
,

-- uniqueness for product: we're gonna choose the product_id, price and name

casted_renamed as(
    select 
          {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID','PRICE', 'NAME']) }} as PRODUCT_SK
        , PRODUCT_ID 
        , PRICE::decimal(10,4) as PRICE
        , NAME 
        , INVENTORY
        , _FIVETRAN_DELETED 
        , _FIVETRAN_SYNCED
    from with_default_record
)

select *
from casted_renamed
