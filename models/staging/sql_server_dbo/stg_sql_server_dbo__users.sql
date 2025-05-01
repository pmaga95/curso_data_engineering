select *
from {{ source("sql_server_dbo", "users")}}