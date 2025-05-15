with src_data as (
    select *
    from {{ source("sql_server_dbo", "addresses")}}
),
-- Add the default row 
default_record as (
    select 
        'Unknown_address' as address_id
        , -1 as zipcode
        , 'Missing_country' as country
        , 'Not_desc_address' as desc_address
        , 'Not_state' as state
        , null as _fivetran_deleted
        , '1998-01-01' as _fivetran_synced
),
--d2fbe240-64ac-4feb-a360-8a9197f8b8ae

-- merge the default row with all products raw
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
        {{dbt_utils.generate_surrogate_key(['address_id'])}} as address_id
        , zipcode
        , country
        , address as desc_address
        , state
        , _fivetran_deleted as is_data_deleted
        , _fivetran_synced as loaded_at
    from with_default_record
)

select *
from casted_renamed

