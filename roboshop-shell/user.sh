Log_file_location=/tmp/user.log
echo -e"\e[32mCopying the user service and Mongo repo file to the desired location\e[0m" | tee -a $Log_file_location
cp user.service /etc/systemd/system/user.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e"\e[34mDownloading the node resource file\e[0m" | tee -a $Log_file_location
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e"\e[34mInstalling the node JS \e[0m" | tee -a $Log_file_location
yum install nodejs -y &>> $Log_file_location

echo -e"\e[32mAdding roboshop user\e[0m" | tee -a $Log_file_location
useradd roboshop

echo -e"\e[33mCreating a directory\e[0m" | tee -a $Log_file_location
mkdir /app

echo -e"\e[33mDownloading the roboshop user code from DEV team\e[0m" | tee -a $Log_file_location
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

cd /app

pwd
echo -e "\e[34mUnzipping the downloaded user file\e[0m" | tee -a $Log_file_location
unzip /tmp/user.zip

echo -e "\e[33m Installing npm is started\e[0m" | tee -a $Log_file_location
npm install &>> $Log_file_location
echo -e "\e[34m Completed installation of npm\e[0m" | tee -a $Log_file_location

yum install mongodb-org-shell -y

echo -e "\e[32mUpdating the schema of user to mongo server\e[0m" | tee -a $Log_file_location
mongo --host mongo.srilearndevops.online </app/schema/user.js

echo -e "\e[34m restarting all the user service\e[0m" | tee -a $Log_file_location
systemctl daemon-reload &>> /dev/null
echo -e "\e[34m enabling and restarting the user service\e[0m" | tee -a $Log_file_location
systemctl enable user &>> $Log_file_location
systemctl restart user &>> $Log_file_location
