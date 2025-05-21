with stg_address as (
    select 
          address_id
        , desc_address
        , state
        , country
        , is_data_deleted
        , loaded_at
    from {{ ref('stg_sql_server_dbo__addresses') }}
)

select distinct state
from stg_address