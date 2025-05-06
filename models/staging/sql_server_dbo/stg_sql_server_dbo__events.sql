with src_data as (
    select *
    from {{ source("sql_server_dbo", "events") }}
),

renamed_casted as (
    select 
            {{dbt_utils.generate_surrogate_key(['EVENT_ID'])}} as EVENT_ID -- use a surrogate key
          , PAGE_URL
          , EVENT_TYPE
          , USER_ID
          , PRODUCT_ID
          , SESSION_ID
          , CREATED_AT
          , ORDER_ID
          , _FIVETRAN_DELETED
          , _FIVETRAN_SYNCED
    from src_data
)

select *
from renamed_casted