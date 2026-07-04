import time
import pandas as pd
from sqlalchemy import create_engine, event
import pyodbc

SERVER = "jtaservidor2.database.windows.net"
USERNAME = "CloudSAfbe8fbdc"
PASSWORD = "NewOutletdb_Pass7362738"
PROD_DATABASE = "AdventureWorksDW2025"
DEV_DATABASE = "Development_AdventureWorksDW2025"

SAMPLE_ROWS = 1500

TABLES = [
    "factinternetsales",
    "factresellersales",
    "factproductinventory",
    "DimProduct",
    "DimCustomer",
    "DimReseller",
    "DimGeography",
    "DimProductCategory",
    "DimProductSubcategory",

]


def get_engine(database: str, connect_timeout: int = 30):
    connection_string = (
        f"DRIVER={{ODBC Driver 18 for SQL Server}};"
        f"SERVER={SERVER};"
        f"DATABASE={database};"
        f"UID={USERNAME};"
        f"PWD={PASSWORD};"
        f"TrustServerCertificate=yes;"
        f"Encrypt=yes;"
        f"Connection Timeout={connect_timeout};"
    )
    engine = create_engine(
        "mssql+pyodbc://",
        creator=lambda: pyodbc.connect(connection_string, timeout=connect_timeout)
    )

    @event.listens_for(engine, "before_cursor_execute")
    def _fast_executemany(conn, cursor, statement, params, context, executemany):
        if executemany:
            cursor.fast_executemany = True

    return engine


def connect_with_retry(database, attempts=3, wait_seconds=20):
    last_error = None
    for attempt in range(1, attempts + 1):
        try:
            engine = get_engine(database)
            with engine.connect():
                pass
            print(f"Connected to '{database}' on attempt {attempt}.")
            return engine
        except Exception as e:
            last_error = e
            print(f"  Attempt {attempt} to connect to '{database}' failed: {e}")
            if attempt < attempts:
                print(f"  Waiting {wait_seconds}s and retrying (database may be resuming)...")
                time.sleep(wait_seconds)
    raise last_error


def sample_table(prod_engine, table_name, n_rows):
    print(f"Sampling up to {n_rows} rows from '{table_name}'...")
    query = f"SELECT TOP {n_rows} * FROM {table_name} ORDER BY NEWID()"
    df = pd.read_sql(query, prod_engine)
    print(f"  '{table_name}': {len(df)} rows sampled")
    return df


def load_to_sql(df: pd.DataFrame, table_name: str, engine):
    if df.empty:
        print(f"  Skipping load for '{table_name}' (empty).")
        return
    df.to_sql(table_name, engine, if_exists="replace", index=False, chunksize=1000)
    print(f"  Done. Table '{table_name}' loaded into dev. ({len(df)} rows)")


if __name__ == "__main__":
    prod_engine = connect_with_retry(PROD_DATABASE)
    dev_engine = connect_with_retry(DEV_DATABASE)

    for table_name in TABLES:
        df = sample_table(prod_engine, table_name, SAMPLE_ROWS)
        load_to_sql(df, table_name, dev_engine)

    print("All tables loaded into dev.")