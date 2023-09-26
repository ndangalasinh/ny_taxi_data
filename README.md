This is still a work in progress, I will keep updating as I see it fit
## ny_taxi_data_modelling
Data to be used by the analyts is modelled here so that we can stay organized.

### Models included are as following
1. Core 
    - zones_ny Table
    - facts_trip Table
    - monthly_zone_revenue Table
    - monthly_zone_riders Table
1. Staging
    - stg_greeen_tripdata View
    - stg_yellow_tripdata View
### Seeding
    - we are only seeding a look up file taxi_zone_lookup.cv for the ny zones
### Testing
Only the basic tests have been implemented via schema of the models as follows
1. stg_green_tripdata 
    - columns to be tested 
        - tripid:
            - Tests: 
                1. Not Null warn
                1. Unique warn
        - vendorid
            - Tests:
                1. Relationship with locationid warn
        - dropoff_locationid
            - Tests:
                1. Relationship with locationid warn
        - payment_type
            - Tests:
                1. accepted_values warn
### Macros
- We only have one macro get_payment_description.sql which interprete the payment type code into a meaningful text







Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](http://community.getbdt.com/) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
