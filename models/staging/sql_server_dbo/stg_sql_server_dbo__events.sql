with src_data as (
    select *
    from {{ source("sql_server_dbo", "events") }}
),

renamed_casted as (
    select 
            {{dbt_utils.generate_surrogate_key(['EVENT_ID::varchar(256)'])}} as EVENT_ID -- use a surrogate key
          , PAGE_URL::varchar(256) as WEB_PAGE_URL
          , EVENT_TYPE::varchar(256) as EVENT_TYPE
          , {{dbt_utils.generate_surrogate_key(['USER_ID::varchar(256)'])}} as CUSTOMER_ID
          , PRODUCT_ID::varchar(256) as PRODUCT_ID
          , SESSION_ID::varchar(256) as SESSION_ID
          , CREATED_AT
          , ORDER_ID::varchar(256) as ORDER_ID
          , _FIVETRAN_DELETED as DELETE_DATE
          , _FIVETRAN_SYNCED::timestamp_ntz as LOAD_DATE
    from src_data
)

select *
from renamed_casted