import pandas as pd
from datetime import datetime

from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


@task(log_prints=True)
def fetch(url: str) -> pd.DataFrame:
    """
    Download the data from the source into the dataframe.
    """
    df_raw = pd.read_parquet(url)

    return df_raw


@task(log_prints=True)
def clean_data(df: pd.DataFrame, table_name: str) -> pd.DataFrame:
    """
    Clean data and prepare it for storage in our Warehouse
    """
    if table_name == "green":
        df.rename(
            columns={
                "lpep_pickup_datetime": "pickup_datetime",
                "lpep_dropoff_datetime": "dropoff_datetime",
                "PULocationID": "pickup_location_ID",
                "DOLocationID": "dropoff_location_ID",
            },
            inplace=True,
        )
    else:
        df.rename(
            columns={
                "tpep_pickup_datetime": "pickup_datetime",
                "tpep_dropoff_datetime": "dropoff_datetime",
                "PULocationID": "pickup_location_ID",
                "DOLocationID": "dropoff_location_ID",
            },
            inplace=True,
        )
    return df


@task(log_prints=True)
def write_to_bq(df: pd.DataFrame, table_name: str) -> None:
    """Write cleaned data into big query"""

    gcp_creds = GcpCredentials.load("gcp-credentials")
    df.to_gbq(
        destination_table=f"dezoomcamp.{table_name}_rides",
        project_id="first-provider-397409",
        chunksize=500000,
        if_exists="append",
        credentials=gcp_creds.get_credentials_from_service_account(),
    )


@flow()
def etl_to_gcs() -> None:
    """
    The main function to extract transform and load data into the datalake
    """
    years = [2023]  # TODO make sure it is stated in the Readme
    tables = ["yellow", "green"]

    for table in tables:
        for year in years:
            if year == datetime.now().year:
                months = range(1, datetime.now().month - 2)
            else:
                months = range(1, 13)
            for month in months:  # TODO modify and automate it
                dataset_file = f"{table}_tripdata_{year}-{month:02}"
                dataset_url = f"https://d37ci6vzurychx.cloudfront.net/trip-data/{dataset_file}.parquet"
                df = fetch(dataset_url)
                df_cleaned = clean_data(df, table_name=table)
                write_to_bq(df_cleaned, table_name=table)
                print(f"Done injecting data for the {month} of {year}")


if __name__ == "__main__":
    etl_to_gcs()
