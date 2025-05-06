with get_data_from_orders as
(       select 
             TRACKING_ID
            ,  SHIPPING_SERVICE
            , SHIPPING_COST 
            , ADDRESS_ID 
            , ESTIMATED_DELIVERY_AT 
            , DELIVERED_AT  
            , STATUS 
        from {{ref("stg_sql_server_dbo__orders")}}
),
default_record as (
    select 
        'empty' as TRACKING_ID
        ,'Not_assigned' as SHIPPING_SERVICE
        , -1 as SHIPPING_COST
        , 'Missing' as ADDRESS_ID
        , '1999-02-12T23:30:34+01:00' as ESTIMATED_DELIVERY_AT
        , '1998-01-01T23:30:34+01:00' as DELIVERED_AT
        , 'Missing' as STATUS
),
with_default_record as (
    select *
    from get_data_from_orders
    union all
    select * 
    from default_record
),

hashed as (
    select 
          {{ dbt_utils.generate_surrogate_key(['TRACKING_ID','SHIPPING_SERVICE','SHIPPING_COST'])}} as SHIPMENT_ID -- the surrogate key getting through the tracking_id as a unique row
            , TRACKING_ID
            , SHIPPING_SERVICE
            , SHIPPING_COST 
            , ADDRESS_ID 
            , ESTIMATED_DELIVERY_AT 
            , DELIVERED_AT  
            , STATUS 
    from with_default_record

)

select * from hashed