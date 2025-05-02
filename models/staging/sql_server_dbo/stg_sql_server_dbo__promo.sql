with src_data as (
    select *
    from {{ source("sql_server_dbo", "promos") }}
),
casted_renamed as (
    select 
        PROMO_ID
        , DISCOUNT::decimal(5,2) as "DISCOUNT %"
        , STATUS
        , _FIVETRAN_DELETED
        , _FIVETRAN_SYNCED
    from src_data
)

select *
from casted_renamed

