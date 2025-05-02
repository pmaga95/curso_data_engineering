with src_data as (
    select *
    from {{ source("sql_server_dbo", "users")}}
),
casted_renamed as (
    select 
        USER_ID
        , concat(FIRST_NAME,' ',LAST_NAME) as NAME
        , UPDATED_AT 
        , ADDRESS_ID 
        , CREATED_AT 
        , PHONE_NUMBER 
        , TOTAL_ORDERS  
        , EMAIL 
        , _FIVETRAN_DELETED 
        , _FIVETRAN_SYNCED 
    from src_data
)

select *
from casted_renamed
