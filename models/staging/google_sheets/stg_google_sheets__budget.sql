with src_budget as (
    select *
    from {{ source('google_sheets', 'budget')}}
),

renamed_casted as (
    select
        --{{ dbt_utils.generate_surrogate_key(['MONTH','PRODUCT_ID'])}} as budget_id -- datatype number(38,0) and is the primary_key
          quantity      
        , month          
        , product_id     
        , _fivetran_synced as loaded_at 
    from  src_budget
)

select * from renamed_casted

