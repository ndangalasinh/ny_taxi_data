# NYC Taxi & Limousine Commission
This is end to end Data Engineering project, data is being fetched from the NYC Taxi & Limousine Commision's website https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page then data is processed and stored into  Google's fully managed, serverless data warehouse. This data is then modelled using DBT to create several tables that then will be used by analysts to create dashboards and analysis.


I would like to thank DTC and all the instructors for providing access to all the materials from their amazing DE zoomcamp, I have borrowed most of the ideas from their examples and did minor changes to fit with my interest (You can fin more details about this amazing club and a lot of other free resources they provide here https://datatalks.club/).

I imagined to be a Data Engineer for an organization with interest in the ridership of this service and I have been tasked with setting  up a data workflow which will allow analysts and scientists to have access to clean and reliable datasets.

To achieve the above goal I have divided this task into three sub tasks.
- Data acquisation, processing and Ingesting
- Data Modelling using DBT
- Data visualization on Google Data Studio

## Data Acquisation
To be able to get this data set reliably a simple ETL has been established which fetches this data from the website in parquet format converts it to pandas dataframe and to some basic Transformations before injecting the dataframe into google's Big query.

for this project I am using Google's Big query for simplicity, but I could any other storage services that are available such as Amazon S3.

Due to the nature of the dataset and the request, the first time this ETL is being deployed we will be fetching all data from the source. However from the second time onward we should change the ETL to make sure that it only fetches data that does not exist in our data warehouse. (This can be done by a simple PR)

In this step we are dumping all the data we can find into the bq, assumption is made that there might some data that we do not need now but they can be very useful later so since storage is not a bottleneck we are off better to collect it now.

I am using Prefect (https://www.prefect.io/) to orchestrate this process, this tool enable me to manage well all the workflows in my ETL and batch it into deployment which can allow schedulling and notification to facilitate automation of the whole process.

In a real life case; this ETL will be run by prefect in an virtual machine or server somewhere which will enable it to be automated by using deployment and scheduling feature.

I chose prefect for this project but I could also use Dagster or Airflow to serve the same process 


## Data Modeling using DBT
Now after data aquisation we will end up with data into our storage, in simple case like this the analysts can easilty access the data from this storage and build dashbord or perfom analysis without a problem. But in cases where there is a lot of data from different sources Warehouse can easily end up being confusing and rander its advantages. Hence it is very important to get into a behavior of modelling this data into the easily consumed format.

While there are multiple tools you can use to model data, I have opted to use DBT for simplicity of this project.


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
We only have few macros that decode some of the basic information which was not given directly

## Data visualization on Google Data Studio
I have demonstrated data visualization of this modelled data using Google Data Studio for simplicity, you can acess that visualizaion here https://lookerstudio.google.com/reporting/990a2679-8d75-413b-9ec7-80d3c2595987

Different tools can be used in this case such as PowerBI, Tableau, or Sisense

