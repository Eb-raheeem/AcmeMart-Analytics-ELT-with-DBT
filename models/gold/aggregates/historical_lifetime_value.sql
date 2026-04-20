select
    customer_id,
    count(distinct transaction_id) as total_orders,
    cast(sum(total_amount) as number(10,2)) as lifetime_value,
    cast(avg(total_amount) as number(10,2)) as avg_order_value

from {{ ref('fct_trn_history') }}
group by customer_id