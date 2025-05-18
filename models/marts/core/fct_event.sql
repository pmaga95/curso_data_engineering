with stg_events as (
    select
            session_id
          , min(event_created_at) as session_start
          , max(event_created_at) as session_end
          , count(*) as total_events
          , count(distinct case when event_type = 'page_view' then web_page_url end) as page_visited
          , count(distinct case when event_type = 'checkout' then order_id end) as orders_placed
    from {{ ref('stg_sql_server_dbo__events') }}
    group by 1
    )

select * 
from stg_events