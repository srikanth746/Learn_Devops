#!/bin/bash

# Database credentials
USER="mainuser"
PASSWORD="50JSsv3XZMYp5z8XyqDR"
HOST="data-masking.cbwgs6ucei2k.us-east-1.rds.amazonaws.com"
DB_NAME="personal_db"
TABLE_NAME="tmp_Users"

# Fetch column names
COLUMNS=$(mysql -u $USER -p$PASSWORD -h $HOST -D $DB_NAME -se "SHOW COLUMNS FROM $TABLE_NAME;" | awk '{print $1}')

# Print column names
echo "Columns in table $TABLE_NAME:"
for i in $COLUMNS
do
    col=$(echo "$i" | tr '[:upper:]' '[:lower:]')
    if [ "$col" == "phone_number" ]; then
        # code to execute if condition is true
        echo "Please mask the data"
    elif [ "$col" == "social_security_number" ]; then
        # code to execute if another_condition is true
        echo "Please mask SSN"
    fi

done
