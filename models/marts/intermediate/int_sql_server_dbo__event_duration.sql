with src_data as (
    select *
    from {{ source("sql_server_dbo", "events") }}
)


select * 
from src_data
group by session_id

/**
select 
    session_id,
    created_at,
    event_type,
    lead(created_at)over(
    partition by user_id 
    order by created_at)
    as next_time_event,
    datediff(
        second,
        created_at,
        lead(created_at)over(
        partition by user_id 
        order by created_at
        )
    ) as event_duration_seconds
    
from src_data_inv
**/