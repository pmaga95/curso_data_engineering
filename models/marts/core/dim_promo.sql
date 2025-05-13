with stg_promo as(
    select 
        PROMO_ID
      , PROMO_STATUS
      , DISCOUNT_EURO
      , DELETE_DATE
      , LOAD_DATE
    from {{ ref('stg_sql_server_dbo__promo') }}
)

select * 
from stg_promo

