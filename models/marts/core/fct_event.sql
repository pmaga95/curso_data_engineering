with stg_events as (
    select
          event_id
        , customer_id
        , session_id
        , event_type
        , product_id
        , order_id
        , web_page_url
        , event_created_at
        , loaded_at
        , is_data_deleted
        
    from {{ ref('stg_sql_server_dbo__events') }}
    ),

-- derived date field
derived_date as (
select
      events.event_id
    , events.customer_id
    , events.session_id
    , events.event_type
    , events.product_id
    , events.order_id
    , events.web_page_url
    , events.event_created_at
    -- Optional derived fields
    , cast(events.event_created_at as date) as event_date
    , {{ dbt_date.week_start('events.event_created_at') }} as event_week
    , events.loaded_at
from stg_events events
)

select * 
from derived_date


