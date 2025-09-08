with first_name_sex_cte as (
    select
        u.*,
        fns.sex as fns_sex
    from
        {{ source("scooters_raw", "users") }} as u
    left join
        {{ ref("first_name_sex") }} as fns
        using (first_name)
    order by u.id
)

select
    f.id,
    f.first_name,
    f.last_name,
    f.phone,
    f.sex,
    f.birth_date,
    coalesce(f.fns_sex, fnsm.sex) as sex_added
from
    first_name_sex_cte as f
left join {{ ref("first_name_sex_manual") }} as fnsm
    using (first_name)
