with get_data_from_orders as
(       select 
             TRACKING_ID
            , SHIPPING_COMPANY
            , SHIPPING_COST 
            , ADDRESS_ID 
            , ESTIMATED_DELIVERY_DATE 
            , DELIVERED_DATE  
            , STATUS 
        from {{ref("stg_sql_server_dbo__orders")}}
),
default_record as (
    select 
        'empty' as TRACKING_ID
        ,'Not_assigned' as SHIPPING_COMPANY
        , -1 as SHIPPING_COST
        , 'Missing' as ADDRESS_ID
        , '1999-02-12T23:30:34+01:00' as ESTIMATED_DELIVERY_DATE 
        , '1998-01-01T23:30:34+01:00' as DELIVERED_DATE
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
             TRACKING_ID
            , {{ dbt_utils.generate_surrogate_key(['SHIPPING_COMPANY'])}} as SHIPPING_COMPANY -- the surrogate key getting through the SHIPPING as a unique row
            , SHIPPING_COST 
            , ADDRESS_ID 
            , ESTIMATED_DELIVERY_DATE 
            , DELIVERED_DATE  
            , STATUS 
    from with_default_record

)

select * from hashed