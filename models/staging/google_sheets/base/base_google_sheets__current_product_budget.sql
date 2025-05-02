select  name,
        inventory,
        b.product_id
from {{ source("google_sheets", "budget")}} b
join {{ source("sql_server_dbo", "products")}} p
on b.product_id = p.product_id
--where p.product_id is null