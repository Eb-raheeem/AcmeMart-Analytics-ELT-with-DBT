with dim_products as (
    select * from {{ ref("stg_transactions")}}
)

select
    distinct product_id,
    product_name,
    category
from
    dim_products