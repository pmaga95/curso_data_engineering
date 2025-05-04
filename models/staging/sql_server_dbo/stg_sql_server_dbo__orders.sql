with src_data as(
    select ORDER_ID -- DATATYPE VARCHAR(256) NOT NULL
            , SHIPPING_SERVICE -- DATATYPE VARCHAR(256)
            , SHIPPING_COST -- DATATYPE FLOAT
            , ADDRESS_ID -- DATATYPE VARCHAR(256)
            , CREATED_AT -- DATATYPE TIMESTAMP_TZ(9)
            , case
                when PROMO_ID <> '' then PROMO_ID
                else 'Unknown_promo'
                end as PROMO_ID -- DATATYPE VARCHAR(256)
            , ESTIMATED_DELIVERY_AT -- DATATYPE TIMESTAMP_TZ(9)
            , ORDER_COST -- DATATYPE FLOAT
            , USER_ID -- DATATYPE VARCHAR(256)
            , ORDER_TOTAL -- DATATYPE FLOAT
            , DELIVERED_AT --DATATYPE TIMESTAMP_TZ(9)
            , TRACKING_ID --DATATYPE VARCHAR(256)
            , STATUS --DATATYPE VARCHAR(256)
            , _FIVETRAN_DELETED --DATATYPE BOOLEAN
            ,_FIVETRAN_SYNCED --DATATYPE TIMESTAMP_TZ(9)
    from {{ source("sql_server_dbo", "orders")}}

),
-- let´s change the datatype from those columns to be more representative
casted_renamed as(
    select 
            ORDER_ID 
            , SHIPPING_SERVICE 
            , SHIPPING_COST 
            , ADDRESS_ID 
            , CREATED_AT
            , p.PROMO_SK -- the surrogate key for promo_id
            , ESTIMATED_DELIVERY_AT 
            , ORDER_COST::decimal(10,4) as ORDER_COST
            , USER_ID 
            , ORDER_TOTAL::decimal(10,4) as ORDER_TOTAL
            , DELIVERED_AT 
            , TRACKING_ID 
            , o.STATUS 
            , o._FIVETRAN_DELETED 
            ,o._FIVETRAN_SYNCED 
    from src_data o
    inner join {{ ref('stg_sql_server_dbo__promo') }} p
    on  PROMO_ID  = p.DESC_PROMO

) 

select *
from casted_renamed