Log_file_location=/tmp/catalogue.log

echo -e "\e[32mCopying service and repo file to a desired location\e[0m" | tee -a $Log_file_location
cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32mDownloading the nodejs from web\e[0m" | tee -a $Log_file_location
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $Log_file_location

echo -e "\e[33mInstalling node JS for roboshop project\e[0m" | tee -a $Log_file_location
yum install nodejs -y &>> $Log_file_location

echo -e "\e[33mAdding roboshop user\e[0m" | tee -a $Log_file_location
useradd roboshop

echo -e "\e[33mInstalling MongoDB for the roboshop project\e[0m" | tee -a $Log_file_location
yum install mongodb-org-shell -y

#Creating a directory to add the catalogue content

echo -e "\e[33mCreating the directory called app\e[0m" | tee -a $Log_file_location
mkdir /app
cd /app
pwd

echo -e "\e[33mDownloading the required package from the DEV \e[0m" | tee -a $Log_file_location
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
unzip /tmp/catalogue.zip
npm install &>> $Log_file_location

echo -e "\e[33mUpdating the catalogues chema, java script to the mongo server\e[0m" | tee -a $Log_file_location
mongo --host mongo.srilearndevops.online </app/schema/catalogue.js

echo -e "\e[33mRestarting all the service in the server\e[0m" | tee -a $Log_file_location
systemctl daemon-reload
echo -e "\e[33mEnabling and restarting the catalogue service\e[0m" | tee -a $Log_file_location
systemctl enable catalogue &>> $Log_file_location
systemctl restart catalogue &>> $Log_file_location