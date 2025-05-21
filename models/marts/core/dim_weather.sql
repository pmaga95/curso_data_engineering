with stg_weather as (
    select 
          *
    from {{ ref('stg__weather') }}
)

select 
    *
from stg_weather
