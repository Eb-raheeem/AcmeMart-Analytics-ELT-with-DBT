select
    d.year,
    d.month,
    d.day,
    sum(f.total_amount) as revenue, 
    count(f.transaction_id) as transactions
from {{ ref('fct_trn_history') }} f
join {{ ref('dim_date') }} d
    on f.trn_date = d.date_day

group by 1,2,3