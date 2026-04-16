with users as (
    select * from {{ ref('stg_users') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

demographics as (
    select * from {{ ref('stg_demographics') }}
),

aggregated as (
    select
        user_id,
        count(order_id) as total_orders,
        sum(order_amount) as total_order_amount,
        avg(order_amount) as avg_order_value
    from orders
    group by user_id
)
select
    u.user_id,
    u.first_name,
    u.last_name,
    u.country,
    u.city,
    u.signup_source,
    u.is_active,
    d.age,
    d.gender,
    d.location,
    d.income_band,
    d.education_level,
    d.marital_status,
    d.household_size,
    d.employment_status,
    case
        when d.age between 18 and 24 then '18-24'
        when d.age between 25 and 34 then '25-34'
        when d.age between 35 and 44 then '35-44'
        else '45+'
    end as age_group,
    coalesce(a.total_orders, 0) as total_orders,
    coalesce(a.total_order_amount, 0) as total_order_amount,
    coalesce(a.avg_order_value, 0) as avg_order_value
from users u
left join aggregated a
    on u.user_id = a.user_id
left join demographics d
    on u.user_id = d.user_id