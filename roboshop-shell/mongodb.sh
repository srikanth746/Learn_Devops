Log_file_location=/tmp/mongo.log
echo -e"\e[32mCopying the repo file of mongo db to install for a desired location\e[0m" | tee -a $Log_file_location
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e"\e[32mInstalling mongo db with updated repo\e[0m" | tee -a $Log_file_location
yum install mongodb-org -y &>> $Log_file_location


echo -e"\e[33mlisten address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf\e[0m" | tee -a $Log_file_location
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

echo -e"\e[34mEnabling and restart of mongo DB\e[0m" | tee -a $Log_file_location
systemctl enable mongod &>> $Log_file_location
systemctl restart mongod &>> $Log_file_location