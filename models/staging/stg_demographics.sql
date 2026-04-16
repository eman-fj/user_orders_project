select
    value:user_id::string as user_id,
    value:age::int as age,
    value:gender::string as gender,
    value:location::string as location,
    value:income_band::string as income_band,
    value:education_level::string as education_level,
    value:marital_status::string as marital_status,
    value:household_size::int as household_size,
    value:employment_status::string as employment_status
from {{ source('raw', 'demographics_raw') }},
lateral flatten(input => raw)