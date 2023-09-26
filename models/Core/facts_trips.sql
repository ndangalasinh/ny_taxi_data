{{ config(materialized="table") }}

with
    green_data as (
        select
            tripid,
            vendor,
            ratecode,
            pickup_location_id,
            dropoff_location_id,
            pickup_datetime,
            dropoff_datetime,
            store_and_fwd_flag,
            passenger_count,
            trip_distance,
            trip_type_desc,
            fare_amount,
            extra,
            mta_tax,
            tip_amount,
            tolls_amount,
            ehail_fee,
            improvement_surcharge,
            total_amount,
            payment_type_description,
            congestion_surcharge,
            "Green" as service_type
        from {{ ref("stg_green_tripdata") }}
    ),
    yellow_data as (
        select
            tripid,
            vendor,
            ratecode,
            pickup_location_id,
            dropoff_location_id,
            pickup_datetime,
            dropoff_datetime,
            store_and_fwd_flag,
            passenger_count,
            trip_distance,
            "Not Provided" as trip_type_desc,
            fare_amount,
            extra,
            mta_tax,
            tip_amount,
            tolls_amount,
            Null as ehail_fee,
            improvement_surcharge,
            total_amount,
            payment_type_description,
            congestion_surcharge,
            "Yellow" as service_type
        from {{ ref("stg_yellow_tripdata") }}
    ),
    trips_unioned as (
        select *
        from green_data
        union all
        select *
        from yellow_data
    ),
    dim_zones as (select * from{{ ref("zones_ny") }} where borough != 'Unknown')
select
    trips_unioned.tripid,
    trips_unioned.vendor,
    trips_unioned.service_type,
    trips_unioned.ratecode,
    trips_unioned.pickup_location_id,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    trips_unioned.dropoff_location_id,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
    trips_unioned.pickup_datetime,
    trips_unioned.dropoff_datetime,
    trips_unioned.store_and_fwd_flag,
    trips_unioned.passenger_count,
    trips_unioned.trip_distance,
    trips_unioned.trip_type_desc,
    trips_unioned.fare_amount,
    trips_unioned.extra,
    trips_unioned.mta_tax,
    trips_unioned.tip_amount,
    trips_unioned.tolls_amount,
    trips_unioned.ehail_fee,
    trips_unioned.improvement_surcharge,
    trips_unioned.total_amount,
    trips_unioned.payment_type_description,
    trips_unioned.congestion_surcharge
from trips_unioned
inner join
    dim_zones as pickup_zone
    on trips_unioned.pickup_location_id = pickup_zone.location_id
inner join
    dim_zones as dropoff_zone
    on trips_unioned.dropoff_location_id = dropoff_zone.location_id
