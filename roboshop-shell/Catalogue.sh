
cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

#Copying the service data to the catalogue location
#cp catalogue.service /etc/systemd/system/catalogue.service

#Adding the mongo db repo file
#cp mongo.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org-shell -y

#Creating a directory to add the catalogue content

mkdir /app
cd /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
unzip /tmp/catalogue.zip
npm install


mongo --host mongo.srilearndevops.online </app/schema/catalogue.js

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue