with ranked as (
    select
        *,
        row_number() over (
            partition by order_id
            order by ingestion_timestamp desc
        ) as rn
    from {{ source('raw', 'orders') }}
)

select
    order_id,
    user_id,
    order_date,
    order_amount,
    payment_method,
    order_status,
    discount_applied,
    shipping_fee,
    product_category
from ranked
where rn = 1