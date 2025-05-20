with src_data as(
    select 
            order_id 
            , shipping_service 
            , shipping_cost
            , address_id
            , created_at
            , promo_id 
            , estimated_delivery_at
            , order_cost
            , user_id 
            , order_total 
            , delivered_at
            , tracking_id 
            , status
            , _fivetran_deleted
            ,_fivetran_synced
    from {{ source("sql_server_dbo", "orders")}}

),
-- let´s change the datatype from those columns to be more representative
casted_renamed as(
    select 
            {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_id
            , case 
                when shipping_service <> '' then shipping_service
                else 'Not_shipping_company'
                end as shipping_company
            , shipping_cost::decimal(10,2) as shipping_cost
            , {{ dbt_utils.generate_surrogate_key(['address_id']) }} as address_id
            , created_at::timestamp_ntz as order_created_at
            , case 
                when promo_id <> '' then {{ dbt_utils.generate_surrogate_key(['promo_id']) }}
                else {{ dbt_utils.generate_surrogate_key(["'Unknown_promo'"]) }}
                end as promo_id
            , coalesce(estimated_delivery_at::timestamp_ntz,'2000-01-01') as estimated_delivery_at
            , order_cost::decimal(10,2) as order_cost
            , {{ dbt_utils.generate_surrogate_key(['user_id']) }} as customer_id
            , order_total::decimal(10,2) as order_total
            , coalesce(delivered_at::timestamp_ntz,'2000-01-01') as order_delivered_at
            , case 
                when tracking_id <> '' then tracking_id
                else 'Not_tracking_assigned'
                end as tracking_id
            , status
            , _fivetran_deleted as is_data_deleted
            , _fivetran_synced::timestamp_ntz as loaded_at
    from src_data 
    

) 

select *
from casted_renamed