select 
  entity_id, 
  to_number(latitude) as latitude,
  to_number(longitude) as longitude
from (
  select 
    entity_id,
    latitude,
    longitude,
    row_number() over (partition by entity_id
                       order by addr_type_code desc, xsequence desc) as rn
  from cdw.d_bio_address_mv
  where
    addr_type_code in ('6', 'H')
    and addr_status_code in ('A', 'K')
    and latitude is not null 
    and trim(latitude) <> ' '
    and longitude is not null
    and trim(longitude) <> ' '
    and not regexp_like(street1, 'p\.?o\.? box', 'i')
) 
  where rn = 1
  and entity_id in (
    select entity_id from cdw.d_entity_mv 
    where person_or_org = 'P' and record_status_code = 'A'
  )
