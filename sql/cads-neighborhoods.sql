/* sample */
with cads as (
    select 
        entity_id, 
        ST_SetSRID(ST_MakePoint(cads.longitude, cads.latitude), 4269) as geocode
    from cads.geocodes cads
)

select entity_id, state, county, city, name, regionid  
from 
    cads inner join zillow.neighborhoods zil
        on ST_WITHIN(cads.geocode, zil.the_geom)
