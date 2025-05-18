with src_data as (
    select *
    from {{ source("sql_server_dbo", "events") }}
),

renamed_casted as (
    select 
            {{dbt_utils.generate_surrogate_key(['event_id::varchar(256)'])}} as event_id -- use a surrogate key
          , page_url::varchar(256) as web_page_url
          , event_type::varchar(256) as event_type
          , {{dbt_utils.generate_surrogate_key(['user_id::varchar(256)'])}} as customer_id
          , product_id::varchar(256) as product_id
          , session_id::varchar(256) as session_id
          , created_at as event_created_at
          , order_id::varchar(256) as order_id
          , _fivetran_deleted as is_data_deleted
          , _fivetran_synced::timestamp_ntz as loaded_at
    from src_data
)

select *
from renamed_casted





