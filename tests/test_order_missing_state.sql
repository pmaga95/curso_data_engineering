
SELECT *
FROM {{ ref('fct_orders') }} o
LEFT JOIN {{ ref('dim_addresses') }} a ON o.address_id = a.address_id
WHERE a.state IS NULL OR a.state = 'Not_state'
