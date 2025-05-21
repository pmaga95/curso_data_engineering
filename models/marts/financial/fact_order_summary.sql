with stg_orders as (
    select
          order_id
        , customer_id
        , promo_id
        , shipping_cost
        , order_cost
        , order_total
        , order_created_at::date as order_date
    from {{ ref('stg_sql_server_dbo__orders') }}
),

order_aggregates as (
    select
          customer_id
        , promo_id
        -- aggregate by month
        , date_trunc('month', order_date) as order_month
        -- all possible agreggated metrics for customer
        , count(*) as number_of_orders
        , sum(order_total) as total_order_value
        , sum(shipping_cost) as total_shipping_cost
        , sum(order_cost) as total_product_cost
        , abs(sum(order_total - shipping_cost - order_cost)) as total_discount_estimated

        , min(order_date) as first_order_date
        , max(order_date) as last_order_date
    from stg_orders
    group by 1, 2, 3
)

select * from order_aggregates
