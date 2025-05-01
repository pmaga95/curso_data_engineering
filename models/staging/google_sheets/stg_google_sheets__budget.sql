with src_budget as (
    select *
    from {{ source('google_sheets', 'budget')}}
),

renamed_casted as (
    select
        _row as budget_id -- datatype number(38,0) and is the primary_key
        , quantity        -- datatype number(38,0)
        , month           -- datatype date,
        , product_id      -- varchar(256)
        , _fivetran_synced as loaded_timestamp -- timestamp_tz(9)
    from  src_budget
)

select * from renamed_casted

