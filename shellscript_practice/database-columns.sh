#!/bin/bash

# Database credentials
USER="mainuser"
PASSWORD="50JSsv3XZMYp5z8XyqDR"
HOST="data-masking.cbwgs6ucei2k.us-east-1.rds.amazonaws.com"
DB_NAME="personal_db"
TABLE_NAME="Loan_Users"
OUTPUT_FILE="table_mask.csv"
START=$(date +%s)
# Fetch column names
COLUMNS=$(mysql -u $USER -p$PASSWORD -h $HOST -D $DB_NAME -se "SHOW COLUMNS FROM $TABLE_NAME;" | awk '{print $1}')
#SQL_QUERY="UPDATE $TABLE_NAME SET phone_number = CONCAT(REPEAT('X', LENGTH(phone_number) - 4), SUBSTR(phone_number, -4));"

declare -A states
states=(
  ["Alabama"]="AL"
  ["Alaska"]="AK"
  ["Arizona"]="AZ"
  ["Arkansas"]="AR"
  ["California"]="CA"
  ["Colorado"]="CO"
  ["Connecticut"]="CT"
  ["Delaware"]="DE"
  ["Florida"]="FL"
  ["Georgia"]="GA"
  ["Hawaii"]="HI"
  ["Idaho"]="ID"
  ["Illinois"]="IL"
  ["Indiana"]="IN"
  ["Iowa"]="IA"
  ["Kansas"]="KS"
  ["Kentucky"]="KY"
  ["Louisiana"]="LA"
  ["Maine"]="ME"
  ["Maryland"]="MD"
  ["Massachusetts"]="MA"
  ["Michigan"]="MI"
  ["Minnesota"]="MN"
  ["Mississippi"]="MS"
  ["Missouri"]="MO"
  ["Montana"]="MT"
  ["Nebraska"]="NE"
  ["Nevada"]="NV"
  ["New Hampshire"]="NH"
  ["New Jersey"]="NJ"
  ["New Mexico"]="NM"
  ["New York"]="NY"
  ["North Carolina"]="NC"
  ["North Dakota"]="ND"
  ["Ohio"]="OH"
  ["Oklahoma"]="OK"
  ["Oregon"]="OR"
  ["Pennsylvania"]="PA"
  ["Rhode Island"]="RI"
  ["South Carolina"]="SC"
  ["South Dakota"]="SD"
  ["Tennessee"]="TN"
  ["Texas"]="TX"
  ["Utah"]="UT"
  ["Vermont"]="VT"
  ["Virginia"]="VA"
  ["Washington"]="WA"
  ["West Virginia"]="WV"
  ["Wisconsin"]="WI"
  ["Wyoming"]="WY"
)

# Print column names
echo "Columns in table $TABLE_NAME:"
for i in $COLUMNS
do
    col=$(echo "$i" | tr '[:upper:]' '[:lower:]')
    if [[ "$col" == *"phone"* ]]; then
        # code to execute if condition is true
        echo "Masking the data for phone number"
        mysql -h "$HOST" -u "$USER" -p"$PASSWORD" "$DB_NAME" -e \
        "UPDATE $TABLE_NAME SET $col = CONCAT(
            FLOOR(100 + (RAND() * 900)), '-',    \
            FLOOR(100 + (RAND() * 900)), '-',    \
            FLOOR(1000 + (RAND() * 9000))        \
        );"


    elif [[ "$col" == *"social_security"* ]]; then
        # code to execute if another_condition is true
        echo "Please mask SSN"
        mysql -h "$HOST" -u "$USER" -p"$PASSWORD" "$DB_NAME" -e \
                "UPDATE $TABLE_NAME SET $col = CONCAT(
                    LPAD(FLOOR(RAND() * 900) + 100, 3, '0'), '-',
                    LPAD(FLOOR(RAND() * 90) + 10, 2, '0'), '-',
                    LPAD(FLOOR(RAND() * 9000) + 1000, 4, '0')
                );"
    elif [[ "$col" == *"address"* ]]; then
      echo "updating the address"
      for s in "${!states[@]}"; do
        #abbreviation=${states[$s]}
        mysql -h "$HOST" -u "$USER" -p"$PASSWORD" "$DB_NAME" -e "UPDATE $TABLE_NAME SET $col='$s' WHERE $col LIKE '%$s%';"
      done
    fi

done

mysqldump --skip-column-statistics --no-create-info --compact --skip-extended-insert -u $USER -p$PASSWORD -h $HOST $DB_NAME $TABLE_NAME > table_dump.sql
# Convert SQL dump to CSV using sed
sed -n -e '/INSERT INTO/{s/.*VALUES //; s/),(/)\n(/g; p}' table_dump.sql |
sed -e 's/),(/\
/g; s/),/\
/g; s/(//g; s/)//g; s/,/","/g; s/^/"/; s/$/"/' > $OUTPUT_FILE

# Clean up
rm table_dump.sql

java -jar arx-3.9.1-gtk-64.jar -project config.xml -input "$OUTPUT_FILE" -output ./maskdata/masked_data_file.csv

END=$(date +%s)

DURATION=$(( (END - START) ))

echo "Time taken: $DURATION seconds"
