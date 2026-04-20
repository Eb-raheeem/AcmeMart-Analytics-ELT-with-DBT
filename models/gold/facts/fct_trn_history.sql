with fct_trn_history as (select * from {{ ref("stg_transactions") }})

select
    transaction_id,
    customer_id,
    store_id,
    product_id,
    payment_method,
    quantity,
    unit_price,
    quantity * unit_price as total_amount,
    trn_timestamp,
    trn_date
from fct_trn_history
