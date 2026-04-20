with dim_customers as (select * from {{ ref("stg_transactions") }})

select distinct customer_id
from dim_customers
