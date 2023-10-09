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
Implementation of this project can be done in three main parts. First Data Aquisation, processing and Storage which covers the whole process of fetching and transforming the fetched data before being stored this whole process is automated by Orchestration and Scheduling tool Prefect. Second stage of this project is modelling the stored data into tables that caters to the needs of the analysts, DBT is the tool we are using in this project for data modelling. The last stage is to create visualization and reporting from the modelled data, here we have used Google's data studio as the reporting tool.

### Data Aquisation, Processing, and Storage.(with Orchestration and Scheduling) 
In this part data is downloaded from the source, processed and then stored in a storage, this process is autmoated by using Orchestratation tools.
There are multiple options of what tools you can use to orchestrate and monitor your scheduled data pipelines, in this case Prefect from https://www.prefect.io/ was used.

After the pipeline was set, a deployment with desired scheduling and monitoring was set configured and deployed.

#### Data Aquisation 
As explained above this data is being fetched from the NYC Taxi & Limousine Commission website, since this data is is available as in parquet format then we can directly fetch it into a pandas dataframe. The way data is fetched is different depending if we have the previous data already or not as discussed bellow.
##### First time (initial) Aquisation
In the case that this is the first time we are loading this data then we will have to load all the previous datasets. Care has to be given to attend the fact that you might not want to load all the data set if you do not have enough storage.
##### Routine Aquisation 
In this case data is loaded on a regular cadance ie once a month so we only load the data that was not loaded last time we loaded data. The simple way to do so is by looking at the current date and then obtain the valu to represent the previous month and use that to select needed data set.

#### Processing
After datqa aquisation now we can do some processing before we store this data into the Google's Bigquery, it is very important not to do a lot of modification here because we going to store this data in its crude format and downstream will model few tables that we need to keep.
In this case in particular only few columns were renamed and some rows that could cause issues downstream were removed.

#### Data storage 
The slightly modified data now is ready to be stored in BigQuery, we will store this data into two different tables. Data from the green taxi will be stored in green rides table and that from the yellow taxi will be stored in yellow rides table.

 
### Data Modelling 
Now at this stage we will end up with data into our storage, in simple case like this the analysts can easilty access the data from this storage and build dashbord or perfom analysis without a problem. But in cases where there is a lot of data from different sources Warehouse can easily end up being confusing and rander its advantages. Hence it is very important to get into a behavior of modelling this data into the easily consumed format.

While there are multiple tools you can use to model data, I have opted to use DBT for simplicity of this project.
#### Our models will be classified into two groups as follows
1. Core 
    - zones_ny Table
    - facts_trip Table
    - monthly_zone_revenue Table
    - monthly_zone_riders Table
1. Staging
    - stg_greeen_tripdata View
    - stg_yellow_tripdata View
#### Seeding(This is used to load files that do not change often)
- we are only seeding a look up file taxi_zone_lookup.cv for the ny zones
#### Testing in our models is implemented as follows
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
- get_payment_type_description.sql
- get_ratecode_description.sql
- get_triptype_description.sql
- get_vendorid_description.sql

## Data visualization on Google Data Studio
I have demonstrated data visualization of this modelled data using Google Data Studio for simplicity, you can acess that visualizaion here https://lookerstudio.google.com/reporting/990a2679-8d75-413b-9ec7-80d3c2595987

Different tools can be used in this case such as PowerBI, Tableau, or Sisense

## How to implement this project 
### part 1
1. Clone the repository
1. Install the required requirements from the requirements.txt
1. If you do not have a gcp account create one 
1. Create GCP credentials in your prefect UI
1. Now you can upload data to your storage
### part 2
1. create account with DBT cloud
1. Create project with DBT
1. Link the DBT project with repository
1. Connect DBT with your storage

### part 3 
1. Automate data aquisation
2. Automate data modelling
### part 4
1. Data visualization

