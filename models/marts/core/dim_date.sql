
 with date_dim as(
    {{ dbt_date.get_date_dimension("2017-01-01", "2025-01-31") }}
 )

 select * 
 from date_dim