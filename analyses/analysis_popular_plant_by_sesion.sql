with order_details as (
    select 
        o.order_id,
        o.product_id,
        o.customer_id,
        o.order_date
    from {{ ref('fct_order_items') }} o
),

product_info as (
    select 
        product_id,
        desc_product,
        preferred_min_temperature,
        preferred_max_temperature
    from {{ ref('dim_products') }}
),

customer_state as (
    select 
        c.customer_id,
        a.state
    from {{ ref('dim_customers') }} c
    join {{ ref('dim_addresses') }} a
    on c.address_id = a.address_id
),

weather_on_order_date as (
    select 
        w.state,
        w.date,
        w.avg_temperature_c
    from {{ ref('dim_weather') }} w
),

date_info as (
    select 
        date_day,
        season
    from {{ ref('dim_date') }}
),

order_enriched as (
    select 
        od.order_id,
        od.product_id,
        od.customer_id,
        od.order_date,
        cs.state,
        pi.desc_product,
        pi.preferred_min_temperature,
        pi.preferred_max_temperature,
        wi.avg_temperature_c,
        di.season
    from order_details od
    join product_info pi using(product_id)
    join customer_state cs on od.customer_id = cs.customer_id
    join weather_on_order_date wi 
        on lower(cs.state) = lower(wi.state)
        and od.order_date = wi.date
    join date_info di 
        on od.order_date = di.date_day
),

filtered_orders as (
    select *
    from order_enriched
    where avg_temperature_c between preferred_min_temperature and preferred_max_temperature
),

plant_popularity as (
    select 
        desc_product,
        season,
        count(*) as orders_count
    from filtered_orders
    group by desc_product, season
)

select 
    desc_product,
    season,
    orders_count,
    rank() over (partition by season order by orders_count desc) as plant_rank
from plant_popularity
where plant_rank = 1
