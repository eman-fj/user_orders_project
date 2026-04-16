with ranked as (
    select
        *,
        row_number() over (
            partition by user_id
            order by ingestion_timestamp desc
        ) as rn
    from {{ source('raw', 'users') }}
)

select
    user_id,
    first_name,
    last_name,
    email,
    phone,
    country,
    city,
    signup_source,
    is_active,
    created_at
from ranked
where rn = 1