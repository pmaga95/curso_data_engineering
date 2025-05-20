with src_data as (
    select *
    from {{ source("sql_server_dbo", "events") }}
),

casted as (
    select 
            event_id::varchar(256) as event_id
          , page_url::varchar(256) as web_page_url
          , event_type::varchar(256) as event_type
          , user_id::varchar(256) as user_id
          , product_id::varchar(256) as product_id
          , session_id::varchar(256) as session_id
          , created_at as event_created_at
          , order_id::varchar(256) as order_id
          , _fivetran_deleted as is_data_deleted
          , _fivetran_synced::timestamp_ntz as loaded_at
    from src_data
)
,
renamed as (
    select 
            {{dbt_utils.generate_surrogate_key(['event_id'])}} as event_id -- use a surrogate key for event
          , casted.web_page_url
          , casted.event_type
          , {{dbt_utils.generate_surrogate_key(['user_id'])}} as customer_id
          , case 
                when casted.product_id <> '' then casted.product_id
                else 'No_product'
                end as product_id
          , casted.session_id
          , casted.event_created_at
          , case 
                when casted.order_id <> '' then casted.order_id
                else 'No_order'
                end as order_id
          , casted.is_data_deleted
          , casted.loaded_at
    from casted
)
select *
from renamed





