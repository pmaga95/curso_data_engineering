
{{ config(
    materialized = 'incremental',
    unique_key = 'order_id', 
    on_schema_change = 'fail'
) }}
with stg_orders as (
    select *
    from {{ ref('stg_sql_server_dbo__orders') }}
     {% if is_incremental() %}
        where order_loaded_at > (select max(order_loaded_at) from {{ this }})
    {% endif %}
),

aggregated as (
    select
          order_id
        , customer_id
        , min(order_created_at) as order_date
        , sum(shipping_cost) as total_shipping_cost_usd
        , sum(promo.discount_usd) as total_discount_usd
        , sum(order_total) as total_order_value_usd
    from stg_orders
    left join {{ ref('stg_sql_server_dbo__promo')}} promo
    using(promo_id)
    left join {{ ref('dim_date') }} date
    on order_date = date.date_key
    group by order_id, customer_id
)

select *
from aggregated
