with src_data as (
    select *
    from {{ source("sql_server_dbo" , "products")}}
),
-- Add the default row 
default_record as (
    select 
        'Unknown_prduct' as product_id
        , -1 as price
        , 'Missing_name' as name
        , -1 as inventory
        , null as _fivetran_deleted
        , '1998-01-01' as _fivetran_synced
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

-- uniqueness for product: we're gonna choose the product_id as a surrogate key

casted_renamed as(
    select 
          {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_id
        , price::decimal(3) as price
        , name as desc_product
        , inventory
        , _fivetran_deleted as is_data_deleted
        , _fivetran_synced::timestamp_ntz as loaded_at
    from with_default_record
)

select *
from casted_renamed
