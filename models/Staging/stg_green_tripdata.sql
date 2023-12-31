{{ config(materialized="view") }}

select
    -- identifiers
    {{ dbt_utils.surrogate_key(["vendorid", "pickup_datetime"]) }} as tripid,
    cast(vendorid as integer) as vendor_id,
    {{get_vendorid_description("vendorid")}} as vendor,
    cast(ratecodeid as integer) as ratecode_id,
    {{get_ratecodeid_description("ratecodeid")}} as ratecode,
    cast(pickup_location_id as integer) as pickup_location_id,
    cast(dropoff_location_id as integer) as dropoff_location_id,
    -- timestamps
    pickup_datetime,
    dropoff_datetime,
    -- trip info
    store_and_fwd_flag,
    cast(passenger_count as integer) as passenger_count,
    cast(trip_distance as numeric) as trip_distance,
    cast(trip_type as integer) as trip_type,
    {{get_triptype_description("trip_type")}} as trip_type_desc,
    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(ehail_fee as integer) as ehail_fee,
    cast(improvement_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    cast(payment_type as integer) as payment_type,
    {{get_payment_type_description("payment_type")}} as payment_type_description,
    cast(congestion_surcharge as numeric) as congestion_surcharge,

from {{ source("staging", "green_rides") }}
where vendorid is not null

