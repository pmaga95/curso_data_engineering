with stg_promo as(
    select 
        promo_id
      , promo_status
      , discount_euro
      , is_data_deleted
      , loaded_at
    from {{ ref('stg_sql_server_dbo__promo') }}
)

select * 
from stg_promo

