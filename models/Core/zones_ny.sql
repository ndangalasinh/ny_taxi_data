{{ config(materialized="table") }}
select locationid, borough, zone, replace(service_zone, "Boro", "Green") as service_zone
from {{ REF("taxi+_zone_lookup") }}
