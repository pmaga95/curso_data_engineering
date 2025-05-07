with src_data as (
    select *
    from {{ source("sql_server_dbo", "addresses")}}
),
-- Add the default rows 
default_record as (
    select 
        'Unknown_address' as ADDRESS_ID
        , -1 as ZIPCODE
        , 'Missing_country' as COUNTRY
        , 'Not_desc_address' as DESC_ADDRES
        , 'Not_state' as STATE
        , null as _FIVETRAN_DELETED
        , '1998-01-01' as _FIVETRAN_SYNCED
),
-- merge the default row with all products raws
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
        {{dbt_utils.generate_surrogate_key(['ADDRESS_ID'])}} as ADDRESS_ID
        , ZIPCODE
        , COUNTRY
        , ADDRESS as DESC_ADDRES
        , STATE
        , _FIVETRAN_DELETED as DELETE_DATE
        , _FIVETRAN_SYNCED::timestamp_ntz as LOAD_DATE
    from with_default_record
)

select *
from casted_renamed


