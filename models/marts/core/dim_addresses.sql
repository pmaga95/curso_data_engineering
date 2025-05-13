with stg_addresss as (
    select 
          ADDRESS_ID
        , DESC_ADDRESS
        , STATE
        , COUNTRY
        , DELETED_DATE
        , LOAD_DATE
    from {{ ref('stg_sql_server_dbo__addresses') }}
)

select *
from stg_addresss