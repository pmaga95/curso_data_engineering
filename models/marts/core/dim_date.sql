
 with date_dim as(
    {{ dbt_date.get_date_dimension("2015-01-01", "2025-12-31") }}
 )

 select * 
 from date_dim