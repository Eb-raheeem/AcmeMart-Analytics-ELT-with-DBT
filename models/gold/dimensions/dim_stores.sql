with dim_stores as (
    select * from {{ ref("stg_transactions")}}
)

select
    distinct store_id
from
    dim_stores