with src_data as (
    select *
    from {{ source("sql_server_dbo", "addresses")}}
),
casted_renamed as (
    select 
        ADDRESS_ID
        , ZIPCODE
        , COUNTRY
        , ADDRESS as DESC_ADDRES
        , STATE
        , _FIVETRAN_DELETED
        , _FIVETRAN_SYNCED
    from src_data
)

select *
from casted_renamed

