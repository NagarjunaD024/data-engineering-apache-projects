#!/bin/bash

set -e

# --- Download aws-java-sdk-bundle jar if missing ---
if [ ! -f ./spark/jars/aws-java-sdk-bundle-1.11.1026.jar ]; then
  echo "Downloading aws-java-sdk-bundle jar..."
  curl -L -o ./spark/jars/aws-java-sdk-bundle-1.11.1026.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar
else
  echo "aws-java-sdk-bundle jar already exists. Skipping download."
fi

# --- Download hadoop-aws jar if missing (THIS WAS THE MISSING PIECE) ---
if [ ! -f ./spark/jars/hadoop-aws-3.3.4.jar ]; then
  echo "Downloading hadoop-aws jar..."
  curl -L -o ./spark/jars/hadoop-aws-3.3.4.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar
else
  echo "hadoop-aws jar already exists. Skipping download."
fi

echo "Running notebook to create Iceberg tables..."
docker compose exec spark-iceberg jupyter execute /home/iceberg/notebooks/create_iceberg_tables.ipynb

echo "Loading data from Postgres to Iceberg..."
docker compose exec spark-iceberg /opt/spark/bin/spark-submit \
  --jars /home/iceberg/pyspark/jars/postgresql-42.7.6.jar \
  /home/iceberg/pyspark/scripts/postgres_loader.py

echo "Loading data from MinIO to Iceberg..."
docker compose exec spark-iceberg /opt/spark/bin/spark-submit \
  --jars /home/iceberg/pyspark/jars/hadoop-aws-3.3.4.jar,/home/iceberg/pyspark/jars/aws-java-sdk-bundle-1.11.1026.jar \
  /home/iceberg/pyspark/scripts/minio_loader.py

echo "Transforming bronze to silver tables..."
docker compose exec spark-iceberg /opt/spark/bin/spark-submit \
  /home/iceberg/pyspark/scripts/bronze_to_silver_transformer.py

echo "Lakehouse preparation pipeline completed."