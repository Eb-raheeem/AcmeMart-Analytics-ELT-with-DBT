select 
    *
from
    {{ source('bronze','transaction_history')}}