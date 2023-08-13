Log_file_location=/tmp/cart.log
echo -e "\e[31m Copying the cart service to a desired location\e[0m" | tee -a $Log_file_location
cp cart.service /etc/systemd/system/cart.service

echo -e "\e[33m Downloading the node js from the web page\e[0m" | tee -a $Log_file_location
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[34m Installing the node JS application\e[0m" | tee -a $Log_file_location
yum install nodejs -y &>> $Log_file_location

echo -e "\e[33mAdding roboshop user\e[0m" | tee -a $Log_file_location
useradd roboshop

echo -e "\e[35m Creating a directory\e[0m" | tee -a $Log_file_location
mkdir /app

echo -e "\e[36m Downloading the cart development file\e[0m" | tee -a $Log_file_location
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

cd /app
echo -e "\e[36m Unzipping the cart file\e[0m" | tee -a $Log_file_location
unzip /tmp/cart.zip
pwd
echo -e "\e[36m Installing the npm\e[0m" | tee -a $Log_file_location
npm install &>> $Log_file_location

echo -e "\e[36m Restarting all the service present in server \e[0m" | tee -a $Log_file_location
systemctl daemon-reload &>> /dev/null

echo -e "\e[34m Enabling and restarting the cart application\e[0m" | tee -a $Log_file_location
systemctl enable cart &>> /dev/null
systemctl restart cart &>> $Log_file_location

echo -e "\e[31m Status of cart application\e[0m" | tee -a $Log_file_location
systemctl status cart ; tail -f /var/log/messages &>> $Log_file_location