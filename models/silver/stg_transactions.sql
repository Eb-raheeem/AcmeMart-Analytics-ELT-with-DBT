with stg_transactions as (select * from {{ ref("bronze_transactions") }})

select
    transaction_id,
    customer_id,
    store_id,
    product_id,
    product_name,
    category,
    payment_method,
    cast(quantity as integer) as quantity,
    cast(unit_price as number(10, 2)) as unit_price,
    cast(total_amount as number(10, 2)) as total_amount,
    -- standardized timestamp
    coalesce(
        try_to_timestamp(transaction_timestamp, 'YYYY-MM-DD HH24:MI:SS'),
        try_to_timestamp(transaction_timestamp, 'DD/MM/YYYY HH24:MI')
    ) as trn_timestamp,

    -- derived date
    cast(
        coalesce(
            try_to_timestamp(transaction_timestamp, 'YYYY-MM-DD HH24:MI:SS'),
            try_to_timestamp(transaction_timestamp, 'DD/MM/YYYY HH24:MI')
        ) as date
    ) as trn_date

from stg_transactions
