with date_spine as (
    --- generates a continuous sequence of 90 days starting from 2026-01-01
    select
        dateadd(day, seq4(), '2026-01-01') as date_day
    from table(generator(rowcount => 90))

)

select
    cast(date_day as date) as date_day,

    year(date_day) as year,
    month(date_day) as month,
    day(date_day) as day,

    quarter(date_day) as quarter,

    dayofweek(date_day) as day_of_week,
    dayname(date_day) as day_name,

    week(date_day) as week_of_year,

    case
        when dayofweek(date_day) in (1,7) then 'weekend'
        else 'weekday'
    end as day_type

from date_spine