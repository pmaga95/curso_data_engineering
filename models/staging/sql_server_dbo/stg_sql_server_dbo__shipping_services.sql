with get_data_from_orders as
(       select  
             SHIPPING_SERVICE 
            , SHIPPING_COST 
            , ADDRESS_ID 
            , ESTIMATED_DELIVERY_AT 
            , DELIVERED_AT 
            , TRACKING_ID 
            , STATUS 
        from {{ref("stg_sql_server_dbo__orders")}}
)

select * from get_data_from_orders