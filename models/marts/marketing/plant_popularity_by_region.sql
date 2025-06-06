with product_customer_match_location as (
    select *
    from {{ ref('product_customer_match_location') }}
)

select
    desc_product
   , state
   , sum(matched_order_count) as total_orders
   , count(distinct customer_id) as unique_customers
  -- , approx_percentile(matched_order_count, 0.5) as median_orders_per_customer
from product_customer_match_location
-- getting just the order_item who matched location
where matched_order_count > 0
group by desc_product, state
order by total_orders desc
