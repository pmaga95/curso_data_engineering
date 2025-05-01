select *
from {{ source("sql_server_dbo", "order_items") }}