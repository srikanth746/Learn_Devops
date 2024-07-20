#!/bin/bash

# Database credentials
USER="mainuser"
PASSWORD="50JSsv3XZMYp5z8XyqDR"
HOST="data-masking.cbwgs6ucei2k.us-east-1.rds.amazonaws.com"
DB_NAME="personal_db"
TABLE_NAME="tmp_Users"
OUTPUT_FILE="table_dump.csv"

# Dump the table data
mysqldump --skip-column-statistics --no-create-info --compact --skip-extended-insert -u $USER -p$PASSWORD -h $HOST $DB_NAME $TABLE_NAME > table_dump.sql

# Convert SQL dump to CSV using sed
sed -n -e '/INSERT INTO/{s/.*VALUES //; s/),(/)\n(/g; p}' table_dump.sql |
sed -e 's/),(/\
/g; s/),/\
/g; s/(//g; s/)//g; s/,/","/g; s/^/"/; s/$/"/' > $OUTPUT_FILE

# Clean up
rm table_dump.sql

echo "Data has been exported to $OUTPUT_FILE"
