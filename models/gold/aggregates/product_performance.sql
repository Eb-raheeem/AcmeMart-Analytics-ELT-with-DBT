select
    p.product_id,
    p.product_name,
    p.category,
    sum(f.total_amount) as revenue,
    sum(f.quantity) as units_sold,
    count(distinct f.transaction_id) as transactions

from {{ ref('fct_trn_history') }} f
left join {{ ref('dim_products') }} p
    on f.product_id = p.product_id

group by 1, 2, 3