
 with date_dim as(
    {{ dbt_date.get_date_dimension("2017-01-01", "2025-01-31") }}
 )

 select *,
        cast(to_char(date_day, 'YYYYMMDD') as date) as date_key
 from date_dim