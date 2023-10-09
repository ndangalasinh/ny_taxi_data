# Data Engineering End to End Project: Analysis of NYC Taxi & Limousine Commission data

## Tech Stack
- Prefect
    - Workflow orchestration tool for data https://www.prefect.io/
- Google BigQuery
    - Google's fully managed, serverless data warehouse that enables scalable analysis over petabytes of data. 
- DBT
    - An open-source command line tool that helps analysts and engineers transform data in their warehouse more effectively.
- Google Data Studio
    - A web-based data visualization tool that helps users build customized dashboards and easy-to-understand reports.
## Overview
This is end to end Data Engineering project where data is fetched batch processed and then made readily available for analysis. This data is being fetched from the NYC Taxi & Limousine Commision's website https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page, get processed, and then stored into  Google's fully managed serverless data warehouse. This data is then modelled using DBT to create several tables that then will be used by analysts to create dashboards and analysis.


Similar project was demonstrated in the Data Engineering Zoomcamp run by Data Talks Club(DTC), while I have altered some of the implementation I have borrowed most of their ideas. I highly recommend for this boot camp for novice Data Engineers, they can be found here https://datatalks.club/.
## Project's main components
Implementation of this project can be done in three main parts. First, data is aquired from the source and it is processed to obtain consistency needed and attend some of the issues inherited from the source. Second step is to store data into ware house. Third step is to model this stored data into the format that best fit our usecase and the last step is to now use the modeled data to do the visualization and analysis of the data.
### Data Aquisation and Processing
As explained above this data is being fetched from the NYC Taxi & Limousine Commission website, since this data is is available as in parquet format then we can directly fetch it into a pandas dataframe. The way data is fetched is different depending if we have the previous data already or not as discussed bellow.
#### First time (initial) Aquisation
In the case that this is the first time we are loading this data then we will have to load all the previous datasets. Care has to be given to attend the fact that you might not want to load all the data set if you do not have enough storage.
#### Routine Aquisation 
In this case data is loaded on a regular cadance ie once a month so we only load the data that was not loaded last time we loaded data. The simple way to do so is by looking at the current date and then obtain the valu to represent the previous month and use that to select needed data set.

The last thing to be done in this stage is to process data before we store it. While there are several things that can be cleaned and removed, in this implementation minimum transformations approach was selected. To chose between maximum transformation of data to minimum transformation of data one has to consider several factors such as storage capability and what are the likely hood that you might need such data in the future.

In this case in particular only few columns were renamed to ease the data processing down stream.

### Data storage 
The modified data now is ready to be stored in our storage, we will store this data into two different tables. Data from the green taxi will be stored in green rides table and that from the yellow taxi will be stored in yellow rides table in the Google's BigQuery.

Attention should be paid to making sure that the speed at which data is being injected will not overwelm the storage.
### Ochestration and Scheduling
In a real case scenario data fetching, downlodading, processing and storing need to be automated and monitored for failures or other erros.

There are multiple options of what tools you can use to orchestrate and monitor your scheduled data pipelines, in this case Prefect from https://www.prefect.io/ was used.

After the pipeline was set, a deployment with desired scheduling and monitoring was set configured and deployed. 

### Data Modelling 
### Data visualization 
## How to implement this project
#TODO
    1. Add the initial load workflow

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

