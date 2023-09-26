{{config(materialized="table")}}
with trips_data as (select * from {{ ref("facts_trips") }})
select
    -- revenue grouping
    pickup_zone as revenue_zone,
    date_trunc(pickup_datetime, month) as revenue_month,
    service_type,

    -- revenue calculations
    sum(fare_amount) as revenue_monthly_fare,
    sum(extra) as revenue_monthly_extra,
    sum(mta_tax) as revenue_monthly_mta_tax,
    sum(tip_amount) as revenue_monthly_tip_amount,
    sum(tolls_amount) as revenue_monthly_tolls_amount,
    sum(improvement_surcharge) as revenue_monthly_improvement_surcharge,
    sum(total_amount) as revenue_monthly_total_amount,
    sum(congestion_surcharge) as revenue_monthly_congestion_surcharge,

    -- additional calculations
    count(tripid) as total_monthly_trips,
    avg(passenger_count) as avg_monthly_passenger_count,
    avg(trip_distance) as avg_monthly_trip_distance

from trips_data
group by 1, 2, 3