with stg_address as (
    select 
          address_id
        , desc_address
        , state
        , country
        , loaded_at
    from {{ ref('stg_sql_server_dbo__addresses') }}
)

select *
from stg_address