select
    trn_date,
    product_id,
    sum(quantity) as total_units_sold,
    sum(total_amount) as total_revenue,
    count(distinct transaction_id) as total_transactions

from {{ ref("fct_trn_history") }}
group by 1, 2