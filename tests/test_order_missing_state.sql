
select *
from {{ ref('fct_order_items') }} order_items
left join {{ ref('dim_addresses') }} address ON order_items.address_id = address.address_id
where a.state is null or a.state = 'Not_state'
