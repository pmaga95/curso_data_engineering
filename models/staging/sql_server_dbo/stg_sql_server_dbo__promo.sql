with src_data as (
    select *
    from {{ source("sql_server_dbo", "promos") }}
),
default_record as (
    select 
        'Unknown_promo' as PROMO_ID
        , -1 as DISCOUNT
        , 'Missing_status' as STATUS
        , null as _FIVETRAN_DELETED
        , '1998-01-01' as _FIVETRAN_SYNCED
),
with_default_record as (
    select *
    from src_data
    union all
    select * 
    from default_record
)
,
casted_renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} as PROMO_ID
        , DISCOUNT::decimal(5,2) as DISCOUNT_EURO
        , STATUS as PROMO_STATUS
        , _FIVETRAN_DELETED as DELETE_DATE
        , _FIVETRAN_SYNCED::timestamp_ntz as LOAD_DATE
    from with_default_record
)

select *
from casted_renamed

