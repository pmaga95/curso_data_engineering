with src_data as (
    select *
    from {{ source("sql_server_dbo", "promos") }}
),
default_record as (
    select 
        'Unknown_promo' as promo_id
        , 0 as discount
        , 'Missing_status' as status
        , null as _fivetran_deleted
        , '1998-01-01' as _fivetran_synced
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
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id
        , discount::decimal(3) as discount_euro
        , status as promo_status
        , _fivetran_deleted as is_data_deleted
        , _fivetran_synced::timestamp_ntz as loaded_at
    from with_default_record
)

select *
from casted_renamed

